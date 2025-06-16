import CoreData
import Foundation

@objc(Family)
public class Family: NSManagedObject {
    // Relationship accessors
    var usersArray: [User] {
        let set = users as? Set<User> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    var recipesArray: [Recipe] {
        let set = recipes as? Set<Recipe> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    var mealPlansArray: [MealPlan] {
        let set = mealPlans as? Set<MealPlan> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    var scheduledMealsArray: [ScheduledMeal] {
        let set = scheduledMeals as? Set<ScheduledMeal> ?? []
        return set.sorted { ($0.date) < ($1.date) }
    }
    
    var groceriesArray: [Grocery] {
        let set = groceries as? Set<Grocery> ?? []
        return set.sorted { ($0.name) < ($1.name) }
    }
    
    // Data validation
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateFamily()
    }
    
    private func validateFamily() throws {
        if let name = name {
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw FamilyValidationError.emptyName
            }
        }
        
        if startDay < 1 || startDay > 7 {
            throw FamilyValidationError.invalidStartDay
        }
    }
}

enum FamilyValidationError: LocalizedError {
    case emptyName
    case invalidStartDay
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        case .invalidStartDay:
            return "Invalid start day selected"
        }
    }
}

// Core Data Properties
extension Family {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Family> {
        return NSFetchRequest<Family>(entityName: "Family")
    }
    
    // Declare attributes
    @NSManaged public var fid: UUID
    @NSManaged public var name: String?
    @NSManaged public var startDay: Int16
    
    // Declare relationships
    @NSManaged public var users: NSSet
    @NSManaged public var recipes: NSSet?
    @NSManaged public var mealPlans: NSSet?
    @NSManaged public var scheduledMeals: NSSet?
    @NSManaged public var groceries: NSSet?
}
