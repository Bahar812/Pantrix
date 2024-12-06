import SwiftUI

struct ShoppingList: View {
    @State private var isAddItemPresented: Bool = false
    @State private var searchText: String = ""  // To store the search query
    @State private var items: [ShoppingItem] = [] // Start with an empty list of items
    
    let shoppingController = ShoppingController() // Instance of ShoppingController
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // List of Items with Search Bar
                    List {
                        ForEach(filteredItems, id: \.id) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.name)
                                        .font(.headline)
                                        .strikethrough(item.purchased, color: .gray)
                                        .foregroundColor(item.purchased ? .gray : .black)
                                    
                                    Text(item.quantity)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                Button(action: {
                                    togglePurchased(item)
                                }) {
                                    Image(systemName: item.purchased ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                        .foregroundColor(item.purchased ? .green : .orange)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .searchable(text: $searchText)  // Add Search Bar
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isAddItemPresented = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.orange)
                                .clipShape(Circle())
                                .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        .sheet(isPresented: $isAddItemPresented) {
                            AddShoppingList(onAdd: {
                                // After adding the item, fetch the updated list
                                fetchItems()
                            }, shoppingController: shoppingController)
                        }
                    }
                }
            }
            .navigationTitle("Shopping List")
            .onAppear {
                fetchItems() // Fetch items when the view appears
            }
        }
        .onChange(of: items) { _ in
            // Sort the items array: move purchased items to the bottom
            items.sort { !$0.purchased && $1.purchased }
        }
    }
    
    // Fetch items from Core Data and convert to ShoppingItem
    private func fetchItems() {
        let fetchedItems = shoppingController.fetchItems()
        items = fetchedItems.map { ShoppingItem(id: $0.id ?? UUID(), name: $0.name ?? "", quantity: $0.quantity ?? "", purchased: $0.purchased) }
    }
    
    // Filter items based on search query
    private var filteredItems: [ShoppingItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    // Toggle purchased state
    private func togglePurchased(_ item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            // Update purchased status in Core Data (toggle)
            shoppingController.updatePurchasedStatus(for: item)
            
            // Toggle the purchased status in the local array (for immediate UI update)
            items[index].purchased.toggle()
        }
    }

    
    // Delete item
    private func deleteItem(at offsets: IndexSet) {
        // Assuming ShoppingController has delete method to remove items from Core Data
        offsets.forEach { index in
            let item = items[index]
            shoppingController.deleteItem(item) // Delete from Core Data
        }
        items.remove(atOffsets: offsets) // Remove from the local array
    }
}

// Model for shopping list item
struct ShoppingItem: Identifiable, Equatable {
    let id: UUID
    var name: String
    var quantity: String
    var purchased: Bool
    
    init(id: UUID = UUID(), name: String, quantity: String, purchased: Bool) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.purchased = purchased
    }
    
    static func == (lhs: ShoppingItem, rhs: ShoppingItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.quantity == rhs.quantity && lhs.purchased == rhs.purchased
    }
}

#Preview {
    ShoppingList()
}
