import CoreData
import Foundation

@objc(TemplateMeal)
public class TemplateMeal: NSManagedObject {
    // Recipe accessors
    var usersArray: [User] {
        let set = users as? Set<User> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    // Data validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateTemplateMeal()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateTemplateMeal()
    }
    
    private func validateTemplateMeal() throws {
        if meal != "Breakfast" && meal != "Lunch" && meal != "Dinner" && meal != "Snack" && meal != "Unscheduled" {
            throw TemplateMealValidationError.invalidMeal
        }
    }
}

enum TemplateMealValidationError: LocalizedError {
    case invalidMeal
    
    var errorDescription: String? {
        switch self {
        case .invalidMeal:
            return "Meal type is invalid"
        }
    }
}

// Core Data Properties
extension TemplateMeal {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemplateMeal> {
        return NSFetchRequest<TemplateMeal>(entityName: "TemplateMeal")
    }
    
    // Declare attributes
    @NSManaged public var tid: UUID
    @NSManaged public var day: String
    @NSManaged public var meal: String
    
    // Declare relationships
    @NSManaged public var users: NSSet?
    @NSManaged public var mealPlan: MealPlan
    @NSManaged public var recipe: Recipe
}
