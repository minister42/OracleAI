import Foundation

class APIService {
    private let systemPrompt = """
    You are an AI Oracle playing a character guessing game (like Akinator). The user is thinking of a real or fictional character, person, animal, or entity. You will receive a JSON object with: history (array of {question, answer} pairs) and guessAttempts (number of wrong guesses so far). Respond ONLY with one of these JSON formats \u2014 no markdown, no explanation. To ask 5 more questions: {"type":"questions","questions":["q1","q2","q3","q4","q5"]}. To make a guess: {"type":"guess","character":"Name","description":"Brief description","confidence":0.92}. To give up: {"type":"give_up"}. Rules: questions must be yes/no answerable; ask broad category questions first (real vs fictional, human vs animal, etc.) then narrow down; if you are fairly confident make a guess; after guessAttempts >= 2 make your best guess or give up; never output anything except valid JSON.
    """

    func fetchBatch(history: [QAPair], guessAttempts: Int) async throws -> OracleResponse {
        let historyPayload = history.map { qa -> [String: String] in
            ["question": qa.question, "answer": qa.answer]
        }

        let payload: [String: Any] = [
            "history": historyPayload,
            "guessAttempts": guessAttempts
        ]

        let payloadData = try JSONSerialization.data(withJSONObject: payload)
        let payloadString = String(data: payloadData, encoding: .utf8) ?? "{}"

        let body: [String: Any] = [
            "model": Config.model,
            "max_tokens": Config.maxTokens,
            "system": systemPrompt,
            "messages": [
                ["role": "user", "content": payloadString]
            ]
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: body)

        var request = URLRequest(url: URL(string: "https://api.anthropic.com/v1/messages")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = bodyData

        var lastError: Error?
        for attempt in 0..<2 {
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                return try parseResponse(data)
            } catch {
                lastError = error
                if attempt == 0 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                }
            }
        }
        throw lastError ?? URLError(.badServerResponse)
    }

    private func parseResponse(_ data: Data) throws -> OracleResponse {
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["content"] as? [[String: Any]],
              let first = content.first,
              let text = first["text"] as? String else {
            throw URLError(.cannotParseResponse)
        }

        guard let textData = text.data(using: .utf8),
              let parsed = try JSONSerialization.jsonObject(with: textData) as? [String: Any],
              let type = parsed["type"] as? String else {
            throw URLError(.cannotParseResponse)
        }

        switch type {
        case "questions":
            guard let questions = parsed["questions"] as? [String] else {
                throw URLError(.cannotParseResponse)
            }
            return .questions(questions)

        case "guess":
            guard let character = parsed["character"] as? String,
                  let description = parsed["description"] as? String else {
                throw URLError(.cannotParseResponse)
            }
            let confidence = parsed["confidence"] as? Double ?? 0.5
            return .guess(GuessData(character: character, description: description, confidence: confidence))

        case "give_up":
            return .giveUp

        default:
            throw URLError(.cannotParseResponse)
        }
    }
}
