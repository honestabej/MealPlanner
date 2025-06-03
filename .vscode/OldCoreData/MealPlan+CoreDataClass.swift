import CoreData
import Foundation

@objc(MealPlan)
public class MealPlan: NSManagedObject {
    
    // MARK: - Convenience Properties
    var scheduledMealsArray: [ScheduledMeal] {
        let set = scheduledMeals as? Set<ScheduledMeal> ?? []
        return set.sorted { meal1, meal2 in
            if meal1.date == meal2.date {
                return meal1.mealTimeOrder < meal2.mealTimeOrder
            }
            return meal1.date < meal2.date
        }
    }
    
    // MARK: - Factory Method
    static func create(name: String, user: User, in context: NSManagedObjectContext) -> MealPlan {
        let mealPlan = MealPlan(context: context)
        mealPlan.name = name
        mealPlan.user = user
        mealPlan.createdAt = Date()
        mealPlan.updatedAt = Date()
        return mealPlan
    }
    
    // MARK: - Validation
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
    
    // MARK: - Meal Management
    func addScheduledMeal(_ scheduledMeal: ScheduledMeal) {
        addToScheduledMeals(scheduledMeal)
        updatedAt = Date()
    }
    
    func removeScheduledMeal(_ scheduledMeal: ScheduledMeal) {
        removeFromScheduledMeals(scheduledMeal)
        updatedAt = Date()
    }
    
    func getScheduledMeals(for date: Date) -> [ScheduledMeal] {
        let calendar = Calendar.current
        return scheduledMealsArray.filter { meal in
            calendar.isDate(meal.date, inSameDayAs: date)
        }
    }
    
    func getScheduledMeals(from startDate: Date, to endDate: Date) -> [ScheduledMeal] {
        return scheduledMealsArray.filter { meal in
            meal.date >= startDate && meal.date <= endDate
        }
    }
    
    func getScheduledMeal(for date: Date, mealType: String) -> ScheduledMeal? {
        let calendar = Calendar.current
        return scheduledMealsArray.first { meal in
            calendar.isDate(meal.date, inSameDayAs: date) && meal.dayMeal.lowercased() == mealType.lowercased()
        }
    }
    
    // MARK: - Statistics
    var totalScheduledMeals: Int {
        return scheduledMeals?.count ?? 0
    }
    
    var dateRange: (start: Date?, end: Date?) {
        let meals = scheduledMealsArray
        guard !meals.isEmpty else { return (nil, nil) }
        
        let dates = meals.map { $0.date }
        return (dates.min(), dates.max())
    }
    
    var uniqueRecipes: [Recipe] {
        let recipes = scheduledMealsArray.map { $0.recipe }
        var uniqueRecipes: [Recipe] = []
        
        for recipe in recipes {
            if !uniqueRecipes.contains(where: { $0.objectID == recipe.objectID }) {
                uniqueRecipes.append(recipe)
            }
        }
        
        return uniqueRecipes.sorted { $0.name < $1.name }
    }
    
    var upcomingMeals: [ScheduledMeal] {
        let now = Date()
        return scheduledMealsArray.filter { $0.date > now }
    }
    
    var pastMeals: [ScheduledMeal] {
        let now = Date()
        return scheduledMealsArray.filter { $0.date < now }
    }
    
    // MARK: - Convenience Methods
    func scheduleRecipe(_ recipe: Recipe, for date: Date, mealType: String) -> ScheduledMeal? {
        guard let context = managedObjectContext else { return nil }
        
        // Check if meal already exists for this date and meal type
        if let existingMeal = getScheduledMeal(for: date, mealType: mealType) {
            existingMeal.recipe = recipe
            return existingMeal
        } else {
            let scheduledMeal = ScheduledMeal.create(date: date, dayMeal: mealType, recipe: recipe, mealPlan: self, in: context)
            return scheduledMeal
        }
    }
    
    func clearSchedule(for date: Date) {
        let mealsToRemove = getScheduledMeals(for: date)
        for meal in mealsToRemove {
            removeScheduledMeal(meal)
            managedObjectContext?.delete(meal)
        }
    }
    
    func clearSchedule(from startDate: Date, to endDate: Date) {
        let mealsToRemove = getScheduledMeals(from: startDate, to: endDate)
        for meal in mealsToRemove {
            removeScheduledMeal(meal)
            managedObjectContext?.delete(meal)
        }
    }
    
    // MARK: - Lifecycle
    override public func willSave() {
        super.willSave()
        if isUpdated && !isInserted {
            updatedAt = Date()
        }
    }
    
    // MARK: - Description
    override public var description: String {
        return "MealPlan: \(name) (\(totalScheduledMeals) meals)"
    }
}

// MARK: - Meal Plan Validation Errors
enum MealPlanValidationError: LocalizedError {
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Meal plan name cannot be empty"
        }
    }
}

// MARK: - Core Data Properties
extension MealPlan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealPlan> {
        return NSFetchRequest<MealPlan>(entityName: "MealPlan")
    }
    
    @NSManaged public var name: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var user: User
    @NSManaged public var scheduledMeals: NSSet?
}

// MARK: - Generated accessors for scheduledMeals
extension MealPlan {
    @objc(addScheduledMealsObject:)
    @NSManaged public func addToScheduledMeals(_ value: ScheduledMeal)
    
    @objc(removeScheduledMealsObject:)
    @NSManaged public func removeFromScheduledMeals(_ value: ScheduledMeal)
    
    @objc(addScheduledMeals:)
    @NSManaged public func addToScheduledMeals(_ values: NSSet)
    
    @objc(removeScheduledMeals:)
    @NSManaged public func removeFromScheduledMeals(_ values: NSSet)
}