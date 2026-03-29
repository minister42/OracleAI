import Foundation

// MARK: - AnswerValue

enum AnswerValue: String, CaseIterable {
    case yes = "Yes"
    case probably = "Probably"
    case dontKnow = "Don't Know"
    case probablyNot = "Probably Not"
    case no = "No"
}

// MARK: - QAPair

struct QAPair: Codable {
    let question: String
    let answer: String
}

// MARK: - GuessData

struct GuessData {
    let character: String
    let description: String
    let confidence: Double
}

// MARK: - OracleResponse

enum OracleResponse {
    case questions([String])
    case guess(GuessData)
    case giveUp
}

// MARK: - GamePhase

enum GamePhase: Equatable {
    case home
    case asking
    case fetchingBatch
    case guessing
    case won
    case lost
}
