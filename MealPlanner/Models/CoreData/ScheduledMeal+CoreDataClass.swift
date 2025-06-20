import CoreData
import Foundation

@objc(ScheduledMeal)
public class ScheduledMeal: NSManagedObject {
    // Relationship accessors
    var usersArray: [User] {
        let set = users as? Set<User> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    // Data validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateScheduledMeal()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateScheduledMeal()
    }
    
    private func validateScheduledMeal() throws {
        if meal != "Breakfast" && meal != "Lunch" && meal != "Dinner" && meal != "Snack" && meal != "Unscheduled" {
            throw ScheduledMealValidationError.invalidMeal
        }
    }
}

enum ScheduledMealValidationError: LocalizedError {
    case invalidMeal
    
    var errorDescription: String? {
        switch self {
        case .invalidMeal:
            return "Meal type is invalid"
        }
    }
}

// Core Data Properties
extension ScheduledMeal {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduledMeal> {
        return NSFetchRequest<ScheduledMeal>(entityName: "ScheduledMeal")
    }
    
    // Declare attributes
    @NSManaged public var sid: UUID
    @NSManaged public var date: Date
    @NSManaged public var meal: String
    @NSManaged public var isChecked: Bool
    
    // Declare relationships
    @NSManaged public var family: Family
    @NSManaged public var users: NSSet?
    @NSManaged public var recipe: Recipe
}
