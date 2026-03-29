import SwiftUI

struct GuessView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "2D1B69"), Color(hex: "1A0E3E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Text("\u{1F52E}")
                    .font(.system(size: 80))

                Text("Is it\u{2026}")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))

                Text(vm.currentGuess?.character ?? "")
                    .font(.system(size: 38, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "FFD700"))
                    .multilineTextAlignment(.center)

                Text(vm.currentGuess?.description ?? "")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                HStack(spacing: 16) {
                    Button(action: { vm.confirmGuess(correct: true) }) {
                        Text("Yes!")
                            .font(.headline)
                            .foregroundColor(Color(hex: "1A0E3E"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(hex: "FFD700"))
                            .cornerRadius(14)
                    }

                    Button(action: { vm.confirmGuess(correct: false) }) {
                        Text("No")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
    }
}
