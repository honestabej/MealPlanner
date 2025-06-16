import CoreData
import Foundation

class GroceryService {
    // Create a new Grocery entity
    static func create(name: String, family: Family, recipes: [Recipe] = [], in context: NSManagedObjectContext) -> Grocery {
        let grocery = Grocery(context: context)
        grocery.gid = UUID()
        grocery.name = name
        grocery.family = family

        for recipe in recipes {
            addRecipe(grocery: grocery, recipe: recipe)
        }

        return grocery
    }

    
    // Delete a Grocery entity
    static func delete(grocery: Grocery, in context: NSManagedObjectContext) {
        context.delete(grocery)
    }
    
    // Manage Recipe relationships
    static func addRecipe(grocery: Grocery, recipe: Recipe) {
        var currentRecipes = grocery.recipes as? Set<Recipe> ?? []
        currentRecipes.insert(recipe)
        grocery.recipes = NSSet(set: currentRecipes)
    }
    
    static func removeRecipe(grocery: Grocery, recipe: Recipe) {
        var currentRecipes = grocery.recipes as? Set<Recipe> ?? []
        currentRecipes.remove(recipe)
        grocery.recipes = NSSet(set: currentRecipes)
    }
}
