import CoreData
import Foundation
import UIKit

public struct RecipeAlertData: Codable {
    let title: String
    let message: String
    let hoursBeforeStart: Double
    let isEnabled: Bool
    let notificationIdentifier: String?
}

@objc(Recipe)
public class Recipe: NSManagedObject {
    
    // Create a new Recipe
    static func create(name: String, image: Data? = nil, ingredients: [String] = [], instructions: String = "", tags: [String] = [], alerts: [RecipeAlertData] = [], user: User, in context: NSManagedObjectContext) -> Recipe {
        let recipe = Recipe(context: context)
        recipe.name = name
        recipe.image = image
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.tags = tags
        recipe.alerts = alerts
        recipe.user = user
        return recipe
    }

    // Image handling
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

    // Lifecycle
    override public func willSave() {
        super.willSave()
    }

    // Helper functions
    func addTags(_ tagsToAdd: [String]) {
        for tag in tagsToAdd {
            if !tags.contains(tag) {
                tags.append(tag)
            }
        }
    }

    func addIngredients(_ ingredientsToAdd: [String]) {
        for ingredient in ingredientsToAdd {
            if !ingredients.contains(ingredient) {
                ingredients.append(ingredient)
            }
        }
    }

    func addAlert(_ alertToAdd: RecipeAlertData) {
        alerts.append(alertToAdd)
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

extension Recipe {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }
    
    @NSManaged public var name: String
    @NSManaged public var image: Data?
    @NSManaged public var ingredients: [String]
    @NSManaged public var instructions: String
    @NSManaged private var alertsData: Data?
    @NSManaged public var tags: [String]
    @NSManaged public var user: User
    @NSManaged public var scheduledMeals: NSSet?
    
    public var alerts: [RecipeAlertData] { 
        get {
            guard let data = alertsData else { return [] }
            return (try? JSONDecoder().decode([RecipeAlertData].self, from: data)) ?? []
        }
        set {
            alertsData = try? JSONEncoder().encode(newValue)
        }
    }
}