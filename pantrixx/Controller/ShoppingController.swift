import Foundation
import CoreData

class ShoppingController {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ShopList")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Failed \(error.localizedDescription)")
            }
        }
    }
    
    // Function to save list item into Core Data
    func saveListItem(name: String, quantity: String, purchased: Bool) {
        
        let newItem = Item(context: persistentContainer.viewContext)
        newItem.name = name
        newItem.quantity = quantity
        newItem.purchased = purchased
        newItem.id = UUID()  // You can use UUID for unique identification
        
        // Save context
        do {
            try persistentContainer.viewContext.save()
            print("Item saved successfully!")
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }
    

   //  Function to fetch all Items
    func fetchItems() -> [Item] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteItem(_ item: ShoppingItem) {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            
            // Find the item to delete by its UUID (matching with ShoppingItem id)
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            
            do {
                let items = try context.fetch(fetchRequest)
                if let itemToDelete = items.first {
                    context.delete(itemToDelete)
                    try context.save() // Save context after deletion
                    print("Item deleted successfully!")
                }
            } catch {
                print("Failed to delete item: \(error.localizedDescription)")
            }
        }
    
    func updatePurchasedStatus(for item: ShoppingItem) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Find the item to update by its UUID (matching with ShoppingItem id)
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
        
        do {
            let items = try context.fetch(fetchRequest)
            if let itemToUpdate = items.first {
                // Toggle the purchased status
                itemToUpdate.purchased.toggle()
                try context.save()  // Save context after update
                print("Item purchased status updated successfully!")
            }
        } catch {
            print("Failed to update purchased status: \(error.localizedDescription)")
        }
    }

}
