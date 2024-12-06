import SwiftUI

struct AddMealPlan: View {
    @State private var mealName: String = ""
    @State private var preparationTime: Int = 0
    @State private var servings: Int = 1
    @State private var image: Image? = nil
    @State private var showImagePicker: Bool = false
    @State private var inputImage: UIImage? = nil
    
    @Environment(\.dismiss) var dismiss // Untuk menutup form setelah selesai
    
    var body: some View {
        NavigationView {
            Form {
                // Meal Name
                Section(header: Text("Meal Details")) {
                    TextField("Meal Name", text: $mealName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Stepper("Preparation Time: \(preparationTime) min", value: $preparationTime, in: 0...120)
                    
                    Stepper("Servings: \(servings)", value: $servings, in: 1...10)
                }
                
                // Image Picker
                Section(header: Text("Meal Image")) {
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    } else {
                        Button("Select Image") {
                            showImagePicker = true
                        }
                    }
                }
            }
            .navigationTitle("Add Meal Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMeal()
                        dismiss()
                    }
                    .disabled(mealName.isEmpty || preparationTime == 0) // Disable jika form kosong
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImage() }
        }
    }
    
    // Load image from the ImagePicker
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    // Save meal (placeholder for actual save logic)
    func saveMeal() {
        print("Meal saved: \(mealName), Time: \(preparationTime), Servings: \(servings)")
        // Implement saving logic to model or backend here
    }
}

#Preview {
    AddMealPlan()
}
