import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
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
}