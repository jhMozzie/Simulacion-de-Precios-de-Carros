import SwiftUI

struct CarCardView: View {
    let car: Car

    var body: some View {
        HStack {
            Image(car.imageName)
                .resizable()
                .frame(width: 100, height: 60)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(car.name)
                    .font(.headline)
                Text("s/ \(car.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.green) // Precio en verde
                HStack {
                    Text("⭐️ \(car.rating, specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    CarCardView(car: Car(name: "Toyota Corolla 2024", price: 15000, imageName: "ToyotaCorolla001", rating: 4.5, type: .sedan))
}
