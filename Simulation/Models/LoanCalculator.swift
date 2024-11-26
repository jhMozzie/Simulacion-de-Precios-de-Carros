import SwiftUI

struct LoanSimulatorView: View {
    // Variables de entrada
    @State private var vehiclePrice: String = ""
    @State private var downPaymentPercentage: String = ""
    @State private var loanTerm: Int = 12
    @State private var annualInterestRate: String = ""
    @State private var includeInsurance: Bool = false
    @State private var annualInsuranceCost: String = ""

    // Resultados calculados
    @State private var downPayment: Double = 0.0
    @State private var loanAmount: Double = 0.0
    @State private var monthlyInstallment: Double = 0.0

    // Opciones para el plazo del crédito
    let loanTerms = [12, 24, 36, 48, 60]

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Simulador de Préstamo")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Detalles del vehículo
                GroupBox(label: Text("DETALLES DEL VEHÍCULO").bold()) {
                    VStack(spacing: 8) {
                        TextField("Precio del vehículo", text: $vehiclePrice)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Porcentaje de pago inicial (%)", text: $downPaymentPercentage)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }

                // Opciones del crédito
                GroupBox(label: HStack {
                    Text("FINANCIAMIENTO EN").bold()
                    Spacer()
                    Picker("Plazo del crédito (meses)", selection: $loanTerm) {
                        ForEach(loanTerms, id: \.self) { term in
                            Text("\(term) meses").tag(term)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 150) // Ajusta el ancho máximo del picker
                }) {
                    VStack(spacing: 8) {
                        TextField("Tasa de interés anual (%)", text: $annualInterestRate)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Toggle("¿Incluir seguro anual?", isOn: $includeInsurance)

                        if includeInsurance {
                            TextField("Costo del seguro anual", text: $annualInsuranceCost)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }

                // Botón de calcular
                Button(action: calculateLoan) {
                    Text("Calcular")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)

                // Resultados
                GroupBox(label: Text("RESULTADOS").bold()) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pago inicial: S/ \(String(format: "%.2f", downPayment))")
                        Text("Monto total financiado: S/ \(String(format: "%.2f", loanAmount))")
                        Text("Cuota mensual: S/ \(String(format: "%.2f", monthlyInstallment))")
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    // Método para calcular el préstamo
    private func calculateLoan() {
        guard let price = Double(vehiclePrice),
              let downPercentage = Double(downPaymentPercentage),
              let interestRate = Double(annualInterestRate) else {
            return
        }

        let downPaymentValue = price * (downPercentage / 100)
        let loanAmountValue = price - downPaymentValue
        let monthlyInterestRate = (interestRate / 100) / 12

        let monthlyInstallmentValue = loanAmountValue * monthlyInterestRate /
            (1 - pow(1 + monthlyInterestRate, Double(-loanTerm)))

        // Agregar seguro si está habilitado
        let insuranceCost = includeInsurance ? (Double(annualInsuranceCost) ?? 0) / 12 : 0

        // Asignar valores calculados
        downPayment = downPaymentValue
        loanAmount = loanAmountValue
        monthlyInstallment = monthlyInstallmentValue + insuranceCost
    }
}

#Preview {
    LoanSimulatorView()
}
