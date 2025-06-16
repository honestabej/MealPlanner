import CoreData
import Foundation

@objc(Recipe)
public class Recipe: NSManagedObject {
    // Relatinoship accessors
    var templateMealsArray: [TemplateMeal] {
        let set = templateMeals as? Set<TemplateMeal> ?? []
        return set.sorted { ($0.day) < ($1.day) }
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
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRecipe()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRecipe()
    }
    
    private func validateRecipe() throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw RecipeValidationError.emptyName
        }
    }
}

enum RecipeValidationError: LocalizedError {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Recipe name cannot be empty"
        }
    }
}

// Core Data Properties
extension Recipe {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    
    // Declare attributes
    @NSManaged public var rid: UUID
    @NSManaged public var name: String
    @NSManaged public var ingredients: [String]
    @NSManaged public var instructions: String?
    @NSManaged public var image: Data?
    @NSManaged public var tags: [String]
    @NSManaged public var alertsData: Data?
    
    // Declare relationships
    @NSManaged public var family: Family
    @NSManaged public var templateMeals: NSSet?
    @NSManaged public var scheduledMeals: NSSet?
    @NSManaged public var groceries: NSSet?
    
    // Handle RecipeAlertsData struct converison
    public var alerts: [RecipeAlertData] {
        get {
            guard let data = alertsData else { return [] }
            return (try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, RecipeAlertData.self], from: data)) as? [RecipeAlertData] ?? []
        }
        set {
            alertsData = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: true)
        }
    }

}
