import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "2D1B69"), Color(hex: "1A0E3E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if vm.phase == .fetchingBatch {
                VStack(spacing: 20) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "FFD700")))
                        .scaleEffect(2.0)

                    Text("Oracle is thinking\u{2026}")
                        .font(.title3)
                        .foregroundColor(Color(hex: "FFD700"))
                }
            } else {
                VStack(spacing: 30) {
                    Text("Question \(vm.questionCount + 1)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text(vm.currentQuestion)
                        .font(.system(size: 26, weight: .semibold, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    Spacer()

                    VStack(spacing: 12) {
                        ForEach(AnswerValue.allCases, id: \.self) { answer in
                            Button(action: { vm.submitAnswer(answer) }) {
                                Text(answer.rawValue)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "FFD700").opacity(0.4), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .alert("Error", isPresented: Binding<Bool>(
            get: { vm.errorMessage != nil },
            set: { if !$0 { vm.errorMessage = nil } }
        )) {
            Button("Retry") { vm.startGame() }
            Button("Home") { vm.goHome() }
        } message: {
            Text(vm.errorMessage ?? "An error occurred.")
        }
    }
}
