import CoreData
import Foundation

@objc(MealPlan)
public class MealPlan: NSManagedObject {
    // Relationship accessors
    var templateMealsArray: [TemplateMeal] {
        let set = templateMeals as? Set<TemplateMeal> ?? []
        return set.sorted { ($0.day) < ($1.day) }
    }
    
    // Data validation
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
            return "Name cannot be empty"
        }
    }
}

// Core Data Properties
extension MealPlan {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlan> {
        return NSFetchRequest<MealPlan>(entityName: "MealPlan")
    }
    
    // Declare attributes
    @NSManaged public var mid: UUID
    @NSManaged public var name: String
    
    // Declare relationships
    @NSManaged public var family: Family
    @NSManaged public var templateMeals: NSSet?
}
