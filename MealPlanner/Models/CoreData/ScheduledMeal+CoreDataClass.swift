import CoreData
import Foundation

@objc(ScheduledMeal)
public class ScheduledMeal: NSManagedObject {

    // Create a new ScheduledMeal
    static func create(daysAndMeals: [String: [String]] = [:], weekOf: Date? = nil, recipe: Recipe, user: User, mealPlan: MealPlan? = nil, in context: NSManagedObjectContext) -> ScheduledMeal {
        let scheduledMeal = ScheduledMeal(context: context)
        scheduledMeal.daysAndMeals = daysAndMeals
        scheduledMeal.weekOf = weekOf
        scheduledMeal.recipe = recipe
        scheduledMeal.user = user
        scheduledMeal.mealPlan = mealPlan
        return scheduledMeal
    }

}

extension ScheduledMeal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduledMeal> {
        return NSFetchRequest<ScheduledMeal>(entityName: "ScheduledMeal")
    }
    
    @NSManaged public var daysAndMeals: [String: [String]]
    @NSManaged public var weekOf: Date?
    @NSManaged public var recipe: Recipe
    @NSManaged public var user: User
    @NSManaged public var mealPlan: MealPlan?
}
