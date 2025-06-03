import CoreData
import Foundation
import UIKit

struct RecipeAlertData: Codable {
    let title: String
    let message: String
    let hoursBeforeStart: Double
    let isEnabled: Bool
    let notificationIdentifier: String?
}

@objc(Recipe)
public class Recipe: NSManagedObject {
    
    // Convenience Properties
    var scheduledMealsArray: [ScheduledMeal] {
        let set = scheduledMeals as? Set<ScheduledMeal> ?? []
        return set.sorted { $0.date < $1.date }
    }
    
    var alertsArray: [RecipeAlertData] {
        guard let alerts = alerts, !alerts.isEmpty else { return [] }
        return try! JSONDecoder().decode([RecipeAlertData].self, from: alerts.data(using: .utf8)!)
    }
    
    // Create a new Recipe Item
    static func create(name: String, ingredients: [String], instructions: String, user: User, in context: NSManagedObjectContext) -> Recipe {
        let recipe = Recipe(context: context)
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.user = user
        return recipe
    }
    
    // Image Handling
    var recipeImage: UIImage? {
        get {
            guard let imageData = image else { return nil }
            return UIImage(data: imageData)
        }
        set {
            if let newImage = newValue {
                // Compress image to reasonable size (max 1MB)
                if let compressedData = newImage.jpegData(compressionQuality: 0.7) {
                    image = compressedData
                }
            } else {
                image = nil
            }
        }
    }
    
    // Validation
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
    
    // Update Methods
    func updateTags(_ newTags: [String]) {
        tags = newTags.joined(separator: ", ")
    }
    
    func updateAlerts(_ newAlerts: [String]) {
        alerts = newAlerts.joined(separator: ", ")
    }
    
    func addTag(_ tag: String) {
        var currentTags = tagsArray
        if !currentTags.contains(tag) {
            currentTags.append(tag)
            updateTags(currentTags)
        }
    }
    
    func removeTag(_ tag: String) {
        var currentTags = tagsArray
        currentTags.removeAll { $0 == tag }
        updateTags(currentTags)
    }
    
    // Lifecycle
    override public func willSave() {
        super.willSave()
    }
    
    // Computed Properties
    var isScheduled: Bool {
        return (scheduledMeals?.count ?? 0) > 0
    }
    
    var nextScheduledDate: Date? {
        let futureMeals = scheduledMealsArray.filter { $0.date > Date() }
        return futureMeals.first?.date
    }
}

// Recipe Validation Errors
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
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    
    @NSManaged public var name: String
    @NSManaged public var ingredients: [String]
    @NSManaged public var instructions: String
    @NSManaged public var alerts: String?
    @NSManaged public var tags: String?
    @NSManaged public var image: Data?
    @NSManaged public var user: User
    @NSManaged public var scheduledMeals: NSSet?
}

// Generated accessors for scheduledMeals
extension Recipe {
    @objc(addScheduledMealsObject:)
    @NSManaged public func addToScheduledMeals(_ value: ScheduledMeal)
    
    @objc(removeScheduledMealsObject:)
    @NSManaged public func removeFromScheduledMeals(_ value: ScheduledMeal)
    
    @objc(addScheduledMeals:)
    @NSManaged public func addToScheduledMeals(_ values: NSSet)
    
    @objc(removeScheduledMeals:)
    @NSManaged public func removeFromScheduledMeals(_ values: NSSet)
}