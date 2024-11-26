import SwiftUI

struct ContentView: View {
    @State private var selectedType: CarType = .sedan
    @State private var selectedCar: Car? // Para el carro seleccionado
    @State private var showModal = false // Para mostrar el modal

    let cars = [
        Car(name: "Toyota Corolla 2024", price: 15000, imageName: "ToyotaCorolla001", rating: 4.5, type: .sedan),
        Car(name: "Nissan Versa 2024", price: 20000, imageName: "NissanVersa001", rating: 4.2, type: .sedan),
        Car(name: "Kia Rio 2024", price: 21500, imageName: "KiaRio001", rating: 4.2, type: .sedan),
        Car(name: "Toyota Hilux 2024", price: 32500, imageName: "ToyotaHilux001", rating: 4.2, type: .camioneta)
    ]

    var filteredCars: [Car] {
        cars.filter { $0.type == selectedType }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Título
            Text("Carros Disponibles")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // Filtros
            HStack {
                Button(action: {
                    selectedType = .sedan
                }) {
                    Text("Sedan")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedType == .sedan ? Color.blue : Color(.systemGray6))
                        .foregroundColor(selectedType == .sedan ? .white : .black)
                        .cornerRadius(10)
                }

                Button(action: {
                    selectedType = .camioneta
                }) {
                    Text("Camioneta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedType == .camioneta ? Color.blue : Color(.systemGray6))
                        .foregroundColor(selectedType == .camioneta ? .white : .black)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            // Lista de carros
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(filteredCars) { car in
                        CarCardView(car: car)
                            .onTapGesture {
                                selectedCar = car
                                showModal = true
                            }
                    }
                }
                .padding()
            }
        }
        .padding(.top, 16)
        // Presentar el ModalView
        .sheet(isPresented: $showModal) {
            if let car = selectedCar {
                ModalView(car: car) // Pasa el carro seleccionado al modal
            }
        }
    }
}

#Preview {
    ContentView()
}
