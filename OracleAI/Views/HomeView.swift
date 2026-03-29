import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "2D1B69"), Color(hex: "1A0E3E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Text("\u{1F52E}")
                    .font(.system(size: 100))

                Text("Oracle")
                    .font(.system(size: 48, weight: .bold, design: .serif))
                    .foregroundColor(Color(hex: "FFD700"))

                Text("Think of any character, person, or thing.")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                Spacer()

                Button(action: { vm.startGame() }) {
                    Text("Begin")
                        .font(.headline)
                        .foregroundColor(Color(hex: "1A0E3E"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(hex: "FFD700"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}
