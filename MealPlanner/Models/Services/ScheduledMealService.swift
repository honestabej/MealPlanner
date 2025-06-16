import CoreData
import Foundation

class ScheduledMealService {
    // Create a new ScheduledMeal entity
    static func create(date: Date, meal: String, family: Family, recipe: Recipe, in context: NSManagedObjectContext) -> ScheduledMeal{
        let scheduledMeal = ScheduledMeal(context: context)
        scheduledMeal.sid = UUID()
        scheduledMeal.date = date
        scheduledMeal.meal = meal
        scheduledMeal.isChecked = false
        scheduledMeal.family = family
        scheduledMeal.recipe = recipe
        return scheduledMeal
    }
    
    // Delete a template meal
    static func delete(scheduledMeal: ScheduledMeal, in context: NSManagedObjectContext) {
        context.delete(scheduledMeal)
    }
    
    // Manage User relationships
    static func addUser(scheduledMeal: ScheduledMeal, user: User) {
        var currentUsers = scheduledMeal.users as? Set<User> ?? []
        currentUsers.insert(user)
        scheduledMeal.users = NSSet(set: currentUsers)
    }
    
    static func removeUser(scheduledMeal: ScheduledMeal, user: User) {
        var currentUsers = scheduledMeal.users as? Set<User> ?? []
        currentUsers.remove(user)
        scheduledMeal.users = NSSet(set: currentUsers)
    }
    
    // Get functions
    static func getAllByDate(date: Date, in context: NSManagedObjectContext) throws -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch scheduledMeals for date \(date): \(error.localizedDescription)")
            return []
        }
    }
    
    static func getAllByDateRange(startDate: Date, endDate: Date, in context: NSManagedObjectContext) throws -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch scheduledMeals for date range \(startDate) to \(endDate): \(error.localizedDescription)")
            return []
        }
    }
    
    static func getAllByDateOfUser(date: Date, user: User, in context: NSManagedObjectContext) throws -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date == %@) AND (users CONTAINS %@)", date as CVarArg, user as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch scheduledMeals of user \(user.name) for date \(date): \(error.localizedDescription)")
            return []
        }
    }
    
    static func getAllByDateRangeOfUser(startDate: Date, endDate: Date, user: User, in context: NSManagedObjectContext) throws -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (users CONTAINS %@)", startDate as CVarArg, endDate as CVarArg, user as CVarArg)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch scheduledMeals of user \(user.name) for date range \(startDate) to \(endDate): \(error.localizedDescription)")
            return []
        }
    }
}
