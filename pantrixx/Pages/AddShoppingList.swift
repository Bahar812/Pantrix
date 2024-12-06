import SwiftUI
struct AddShoppingList: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var itemName: String = ""
    @State private var quantity: String = ""
    @State private var category: String = "Vegetable" // Default category
    @State private var categories: [String] = ["Vegetable", "Protein", "Fruit", "Drink", "Other"]
    
    var onAdd: () -> Void // Closure for adding item to the shopping list
    var shoppingController: ShoppingController // Instance of ShoppingController
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    // Input for item name
                    TextField("Item Name", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Input for quantity
                    TextField("Quantity (e.g., 2 kg, 1 unit)", text: $quantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                }
                
                Section(header: Text("Category")) {
                    // Picker for category selection
                    Picker("Select Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Button to add item
                Section {
                    Button(action: {
                        // Save item using ShoppingController
                        shoppingController.saveListItem(name: itemName, quantity: quantity, purchased: false)
                        onAdd() // Call the onAdd closure to update the list
                        presentationMode.wrappedValue.dismiss() // Dismiss the view after adding
                    }) {
                        Text("Add Item")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .foregroundColor(.white)
                            .background(itemName.isEmpty || quantity.isEmpty ? Color.gray : Color.orange)
                            .cornerRadius(10)
                    }
                    .disabled(itemName.isEmpty || quantity.isEmpty) // Disable if inputs are empty
                }
            }
            .navigationTitle("Add Shopping Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss() // Close view on cancel
                    }
                }
            }
        }
    }
}


#Preview {
    AddShoppingList(onAdd: { }, shoppingController: ShoppingController())
}

