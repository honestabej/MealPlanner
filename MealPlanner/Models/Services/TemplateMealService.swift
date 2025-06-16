import CoreData
import Foundation

class TemplateMealService {
    // Create a new TemplateMeal entity
    static func create(day: String, meal: String, users: [User] = [], mealPlan: MealPlan, recipe: Recipe, in context: NSManagedObjectContext) -> TemplateMeal{
        let templateMeal = TemplateMeal(context: context)
        templateMeal.tid = UUID()
        templateMeal.day = day
        templateMeal.meal = meal
        templateMeal.users = NSSet(array: users)
        templateMeal.mealPlan = mealPlan
        templateMeal.recipe = recipe
        return templateMeal
    }
    
    // Delete a template meal
    static func delete(templateMeal: TemplateMeal, in context: NSManagedObjectContext) {
        context.delete(templateMeal)
    }
    
    // Manage User relationships
    static func addUser(templateMeal: TemplateMeal, user: User) {
        var currentUsers = templateMeal.users as? Set<User> ?? []
        currentUsers.insert(user)
        templateMeal.users = NSSet(set: currentUsers)
    }
    
    static func removeUser(templateMeal: TemplateMeal, user: User) {
        var currentUsers = templateMeal.users as? Set<User> ?? []
        currentUsers.remove(user)
        templateMeal.users = NSSet(set: currentUsers)
    }
}
