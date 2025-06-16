import CoreData
import Foundation

class MealPlanService {
    // Create a new MealPlan entity
    static func create(name: String, family: Family, in context: NSManagedObjectContext) -> MealPlan {
        let mealPlan = MealPlan(context: context)
        mealPlan.mid = UUID()
        mealPlan.name = name
        mealPlan.family = family
        return mealPlan
    }
    
    // Delete mealPlan function
    static func delete(mealPlan: MealPlan, in context: NSManagedObjectContext) {
        context.delete(mealPlan)
    }
    
    // Manage templateMeal relationships
    static func addTemplateMeal(mealPlan: MealPlan, templateMeal: TemplateMeal) {
        var currentTemplateMeals = mealPlan.templateMeals as? Set<TemplateMeal> ?? []
        currentTemplateMeals.insert(templateMeal)
        mealPlan.templateMeals = NSSet(set: currentTemplateMeals)
    }
    
    static func removeTemplateMeal(mealPlan: MealPlan, templateMeal: TemplateMeal) {
        var currentTemplateMeals = mealPlan.templateMeals as? Set<TemplateMeal> ?? []
        currentTemplateMeals.remove(templateMeal)
        mealPlan.templateMeals = NSSet(set: currentTemplateMeals)
    }
    
    // Get functions
    static func getByName(name: String, in context: NSManagedObjectContext) throws -> MealPlan? {
        let fetchRequest: NSFetchRequest<MealPlan> = MealPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch mealPlan by name \(name): \(error.localizedDescription)")
            return nil
        }
    }
}
