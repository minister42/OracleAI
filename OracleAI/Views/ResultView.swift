import SwiftUI

struct ResultView: View {
    let won: Bool
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "2D1B69"), Color(hex: "1A0E3E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                Text(won ? "\u{2728}" : "\u{1F614}")
                    .font(.system(size: 80))

                Text(won ? "I knew it!" : "You stumped me!")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "FFD700"))

                Text(won ? "The Oracle sees all." : "You win this round.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                Button(action: { vm.startGame() }) {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(Color(hex: "1A0E3E"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FFD700"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)

                Button(action: { vm.goHome() }) {
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.bottom, 40)
            }
        }
    }
}
