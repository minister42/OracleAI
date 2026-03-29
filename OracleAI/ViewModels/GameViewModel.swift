import Foundation
import SwiftUI

@MainActor
class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .home
    @Published var currentQuestion: String = ""
    @Published var questionCount: Int = 0
    @Published var history: [QAPair] = []
    @Published var currentGuess: GuessData? = nil
    @Published var guessAttempts: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var pendingQuestions: [String] = []
    private var pendingIndex: Int = 0

    private let api = APIService()

    func startGame() {
        phase = .fetchingBatch
        currentQuestion = ""
        questionCount = 0
        history = []
        currentGuess = nil
        guessAttempts = 0
        isLoading = true
        errorMessage = nil
        pendingQuestions = []
        pendingIndex = 0
        Task { await fetchBatch() }
    }

    func submitAnswer(_ answer: AnswerValue) {
        let qaPair = QAPair(question: currentQuestion, answer: answer.rawValue)
        history.append(qaPair)
        questionCount += 1

        pendingIndex += 1
        if pendingIndex < pendingQuestions.count {
            currentQuestion = pendingQuestions[pendingIndex]
        } else {
            Task { await fetchBatch() }
        }
    }

    func confirmGuess(correct: Bool) {
        if correct {
            phase = .won
        } else {
            guessAttempts += 1
            if guessAttempts >= 3 {
                phase = .lost
            } else {
                Task { await fetchBatch() }
            }
        }
    }

    func goHome() {
        phase = .home
    }

    private func fetchBatch() async {
        phase = .fetchingBatch
        isLoading = true
        errorMessage = nil

        do {
            let response = try await api.fetchBatch(history: history, guessAttempts: guessAttempts)
            isLoading = false
            handleResponse(response)
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            if !history.isEmpty {
                phase = .asking
            } else {
                phase = .home
            }
        }
    }

    private func handleResponse(_ response: OracleResponse) {
        switch response {
        case .questions(let questions):
            pendingQuestions = questions
            pendingIndex = 0
            if let first = questions.first {
                currentQuestion = first
                phase = .asking
            }
        case .guess(let guessData):
            currentGuess = guessData
            phase = .guessing
        case .giveUp:
            phase = .lost
        }
    }
}
