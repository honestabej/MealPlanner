import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()
    
    init() {}
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MealPlanner")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // In production, you should handle this error appropriately
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        
        // Automatically merge changes from parent context
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // Main Context (UI Context)
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Background Context for heavy operations
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // Save Context
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved Core Data save error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Save Background Context
    func saveBackgroundContext(_ context: NSManagedObjectContext) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nsError = error as NSError
                    print("Unresolved background context save error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    // Batch Delete
    func batchDelete(entityName: String, predicate: NSPredicate? = nil) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes = [NSDeletedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable: Any], into: [context])
        } catch {
            print("Batch delete error: \(error)")
        }
    }
    
    // Delete all CoreData entites, but keep the persistent store structure
    func deleteAllEntities(in context: NSManagedObjectContext) {
        let entities = persistentContainer.managedObjectModel.entities

        for entity in entities {
            guard let name = entity.name else { continue }

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
            } catch {
                print("Failed to delete entity \(name): \(error)")
            }
        }

        try? context.save()
    }
    
    // Completely reset the CoreData persistent Store structure
    func deletePersistentStore() -> String {
        guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
            print("❌ Store URL not found.")
            return "❌ Store URL not found."
        }

        let coordinator = persistentContainer.persistentStoreCoordinator

        do {
            var returnString = ""
            try coordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            print("🧨 Old Persistent store deleted.")
            returnString.append("🧨 Old Persistent store deleted.")

            // Recreate the store
            persistentContainer = NSPersistentContainer(name: "MealPlanner")
            persistentContainer.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to reload store: \(error)")
                }
                print("✅ New persistent store created.")
                returnString.append("\n✅ New persistent store created.")
            }
            
            return returnString
        } catch {
            print("❌ Failed to delete persistent store: \(error)")
            return "❌ Failed to delete persistent store: \(error)"
        }
    }

}
