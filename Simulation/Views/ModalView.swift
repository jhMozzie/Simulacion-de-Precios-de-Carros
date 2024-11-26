import SwiftUI

struct ModalView: View {
    let car: Car

    // Variables de entrada
    @State private var downPaymentPercentage: String = ""
    @State private var loanTerm: Int = 12
    @State private var annualInterestRate: String = ""
    @State private var includeInsurance: Bool = false
    @State private var annualInsuranceCost: String = ""
    @State private var startDate: Date = Date() // Fecha inicial
    @State private var endDate: Date = Date() // Fecha final calculada

    // Resultados calculados
    @State private var downPayment: Double = 0.0
    @State private var loanAmount: Double = 0.0
    @State private var monthlyInstallment: Double = 0.0
    @State private var paymentSchedule: [(String, Double, Double)] = [] // Cronograma de pagos

    // Opciones para el plazo del crédito
    let loanTerms = [12, 24, 36, 48, 60]

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView { // Habilita el desplazamiento
                VStack(spacing: 16) {
                    // Título del Modal
                    Text("Simulador Financiero")
                        .font(.title2)
                        .bold()

                    // Mostrar datos del vehículo
                    GroupBox(label: Text("DATOS DEL VEHÍCULO").bold()) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Marca: \(car.name)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Precio: S/ \(String(format: "%.2f", car.price))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.subheadline)
                        .padding(.top, 1)
                    }
                    .padding(.bottom, 16) // Espaciado adicional debajo de "DATOS DEL VEHÍCULO"

                    // Entradas del simulador
                    GroupBox(label: Text("TIEMPO DE FINANCIACION (MESES)").bold()) {
                        VStack(spacing: 8) {
                            Picker("Plazo (meses)", selection: $loanTerm) {
                                ForEach(loanTerms, id: \.self) { term in
                                    Text("\(term)")
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())

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

                    // Campo: Porcentaje inicial
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingrese Porcentaje Inicial")
                            .font(.headline)
                        TextField("Porcentaje de pago inicial (%)", text: $downPaymentPercentage)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Fechas
                    GroupBox(label: Text("FECHAS").bold()) {
                        VStack(spacing: 8) {
                            DatePicker("Fecha Inicial", selection: $startDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .onChange(of: startDate) { _ in
                                    calculateEndDate()
                                }

                            Text("Fecha Final: \(formattedDate(endDate))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Botón para calcular
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Monto total financiado: S/ \(String(format: "%.2f", loanAmount))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Cuota mensual: S/ \(String(format: "%.2f", monthlyInstallment))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 1)
                    }
                }
                .padding()
            }
            .navigationTitle("Simulador Financiero")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }

    private func calculateLoan() {
        guard let downPercentage = Double(downPaymentPercentage),
              let annualRate = Double(annualInterestRate) else { return }

        let price = car.price
        downPayment = price * (downPercentage / 100)
        loanAmount = price - downPayment

        // Calculamos la tasa mensual de interés
        let monthlyRate = (annualRate / 100) / 12

        // Calculamos la cuota mensual base sin seguro
        var monthlyInstallmentValue = loanAmount * monthlyRate / (1 - pow(1 + monthlyRate, Double(-loanTerm)))

        // Agregamos el seguro mensual si está habilitado
        if includeInsurance, let annualInsurance = Double(annualInsuranceCost) {
            let monthlyInsurance = annualInsurance / 12
            monthlyInstallmentValue += monthlyInsurance
        }

        // Actualizamos los resultados calculados
        monthlyInstallment = monthlyInstallmentValue

        // Calculamos la fecha final del préstamo
        calculateEndDate()
    }


    private func calculateEndDate() {
        endDate = Calendar.current.date(byAdding: .month, value: loanTerm, to: startDate) ?? startDate
    }


    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ModalView(car: Car(name: "Toyota Corolla 2024", price: 15000, imageName: "ToyotaCorolla001", rating: 4.5, type: .sedan))
}
