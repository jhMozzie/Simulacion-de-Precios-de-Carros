import SwiftUI

// Definición del tipo de vehículo
enum CarType: String {
    case sedan = "Sedan"
    case camioneta = "Camioneta"
}

// Estructura del carro con el tipo añadido
struct Car: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let imageName: String
    let rating: Double
    let type: CarType
}
