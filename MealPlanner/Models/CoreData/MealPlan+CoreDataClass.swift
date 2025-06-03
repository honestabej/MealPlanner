import CoreData
import Foundation

@objc(MealPlan)
public class MealPlan: NSManagedObject {
    static func create(name: String, user: User, in context: NSManagedObjectContext) -> MealPlan {
        let mealPlan = MealPlan(context: context)
        mealPlan.name = name
        mealPlan.user = user
        return mealPlan
    }

    // Validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateMealPlan()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateMealPlan()
    }
    
    private func validateMealPlan() throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw MealPlanValidationError.emptyName
        }
    }
}

enum MealPlanValidationError: LocalizedError {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Meal plan name cannot be empty"
        }
    }
}

// Core Data Properties
extension MealPlan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlan> {
        return NSFetchRequest<MealPlan>(entityName: "MealPlan")
    }
    
    @NSManaged public var name: String
    @NSManaged public var user: User
    @NSManaged public var scheduledMeals: NSSet?
}   