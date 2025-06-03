import CoreData
import Foundation

@objc(Grocery)
public class Grocery: NSManagedObject {
    // Create a new grocery
    static func create(name: String, user: User, in context: NSManagedObjectContext) -> Grocery {
        let grocery = Grocery(context: context)
        grocery.name = name
        grocery.user = user
        return grocery
    }
}

enum GroceryValidationError: LocalizedError {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Grocery name cannot be empty"
        }
    }
}

// Core Data Properties
extension Grocery {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery")
    }
    
    @NSManaged public var name: String
    @NSManaged public var user: User
} 
