import CoreData
import Foundation

@objc(Grocery)
public class Grocery: NSManagedObject {
    // Relationship accessors
    var recipesArray: [Recipe] {
        let set = recipes as? Set<Recipe> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    // Data validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateGrocery()
    }
    
    private func validateGrocery() throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw GroceryValidationError.emptyName
        }
    }
}

enum GroceryValidationError: LocalizedError {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        }
    }
}

// Core Data Properties
extension Grocery {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery")
    }
    
    // Declare attributes
    @NSManaged public var gid: UUID
    @NSManaged public var name: String
    
    // Declare relationships
    @NSManaged public var family: Family
    @NSManaged public var recipes: NSSet?
}
