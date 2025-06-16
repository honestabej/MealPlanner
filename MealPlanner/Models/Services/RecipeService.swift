import CoreData
import Foundation

class RecipeService {
    // Create a new Recipe entity
    static func create(name: String, ingredients: [String] = [], instructions: String = "", image: Data? = nil, tags: [String] = [], alerts: [RecipeAlertData] = [], family: Family, in context: NSManagedObjectContext) -> Recipe {
        let recipe = Recipe(context: context)
        recipe.rid = UUID()
        recipe.name = name
        recipe.ingredients = ingredients
        recipe.instructions = instructions
        recipe.image = image
        recipe.tags = tags
        recipe.alerts = alerts
        recipe.family = family
        return recipe
    }
    
    // Update alerts
    static func addAlertData(recipe: Recipe, alertData: RecipeAlertData) {
        recipe.alerts.append(alertData)
    }
    
    static func removeAlertData(recipe: Recipe, alertData: RecipeAlertData) {
        recipe.alerts.removeAll { $0.alertID == alertData.alertID }
    }
    
    // Delete a Recipe entity
    static func delete(recipe: Recipe, in context: NSManagedObjectContext) {
        context.delete(recipe)
    }
    
    // Get functions
    static func getByName(name: String, in context: NSManagedObjectContext) -> Recipe? {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch recipe by name \(name): \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getAllByTags(tags: [String], in context: NSManagedObjectContext) -> [Recipe] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tags CONTAINS %@", tags.joined(separator: ","))

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recipe by tags \(tags.joined(separator: ",")): \(error.localizedDescription)")
            return []
        }
    }
    
    static func getAllByIngredients(ingredients: [String], in context: NSManagedObjectContext) -> [Recipe] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ingredients CONTAINS %@", ingredients.joined(separator: ","))

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recipes by ingredients \(ingredients.joined(separator: ",")): \(error.localizedDescription)")
            return []
        }
    }
}
