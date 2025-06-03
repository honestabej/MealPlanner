import CoreData
import Foundation

@objc(ScheduledMeal)
public class ScheduledMeal: NSManagedObject {
    
    // MARK: - Meal Type Enum
    enum MealType: String, CaseIterable {
        case breakfast = "breakfast"
        case lunch = "lunch"
        case dinner = "dinner"
        case snack = "snack"
        case brunch = "brunch"
        
        var displayName: String {
            return rawValue.capitalized
        }
        
        var order: Int {
            switch self {
            case .breakfast: return 0
            case .brunch: return 1
            case .lunch: return 2
            case .snack: return 3
            case .dinner: return 4
            }
        }
    }
    
    // MARK: - Convenience Properties
    var mealType: MealType? {
        get {
            return MealType(rawValue: dayMeal.lowercased())
        }
        set {
            dayMeal = newValue?.rawValue ?? dayMeal
        }
    }
    
    var mealTimeOrder: Int {
        return mealType?.order ?? 999
    }
    
    var displayMealType: String {
        return mealType?.displayName ?? dayMeal.capitalized
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    // MARK: - Factory Method
    static func create(date: Date, dayMeal: String, recipe: Recipe, mealPlan: MealPlan, in context: NSManagedObjectContext) -> ScheduledMeal {
        let scheduledMeal = ScheduledMeal(context: context)
        scheduledMeal.date = date
        scheduledMeal.dayMeal = dayMeal.lowercased()
        scheduledMeal.recipe = recipe
        scheduledMeal.mealPlan = mealPlan
        scheduledMeal.createdAt = Date()
        return scheduledMeal
    }
    
    // MARK: - Validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateScheduledMeal()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateScheduledMeal()
    }
    
    private func validateScheduledMeal() throws {
        if dayMeal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ScheduledMealValidationError.emptyMealType
        }
        
        // Validate that the meal type is recognized
        if MealType(rawValue: dayMeal.lowercased()) == nil {
            // Allow custom meal types, but log a warning
            print("Warning: Unrecognized meal type '\(dayMeal)'. Consider using standard types.")
        }
    }
    
    // MARK: - Status Properties
    var isPast: Bool {
        return date < Date()
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(date)
    }
    
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(date)
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        let now = Date()
        return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
    }
    
    var daysFromNow: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        return components.day ?? 0
    }
    
    // MARK: - Convenience Methods
    func reschedule(to newDate: Date) {
        date = newDate
    }
    
    func changeMealType(to newMealType: MealType) {
        dayMeal = newMealType.rawValue
    }
    
    func changeRecipe(to newRecipe: Recipe) {
        recipe = newRecipe
    }
    
    func moveToMealPlan(_ newMealPlan: MealPlan) {
        // Remove from current meal plan
        mealPlan.removeFromScheduledMeals(self)
        
        // Add to new meal plan
        mealPlan = newMealPlan
        newMealPlan.addToScheduledMeals(self)
    }
    
    // MARK: - Notification Support
    var notificationIdentifier: String {
        return "meal_\(objectID.uriRepresentation().absoluteString)"
    }
    
    func scheduleNotification(minutesBefore: Int = 30) {
        // This would integrate with UNUserNotificationCenter
        // Implementation depends on your notification requirements
        let notificationDate = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: date)
        print("Would schedule notification for \(recipe.name) at \(notificationDate?.description ?? "unknown time")")
    }
    
    // MARK: - Description
    override public var description: String {
        return "\(displayMealType): \(recipe.name) on \(dateString)"
    }
    
    // MARK: - Comparison
    static func < (lhs: ScheduledMeal, rhs: ScheduledMeal) -> Bool {
        if lhs.date == rhs.date {
            return lhs.mealTimeOrder < rhs.mealTimeOrder
        }
        return lhs.date < rhs.date
    }
}

// MARK: - Scheduled Meal Validation Errors
enum ScheduledMealValidationError: LocalizedError {
    case emptyMealType
    
    var errorDescription: String? {
        switch self {
        case .emptyMealType:
            return "Meal type cannot be empty"
        }
    }
}

// MARK: - Core Data Properties
extension ScheduledMeal {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduledMeal> {
        return NSFetchRequest<ScheduledMeal>(entityName: "ScheduledMeal")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var dayMeal: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var recipe: Recipe
    @NSManaged public var mealPlan: MealPlan
}

// MARK: - Hashable Conformance
extension ScheduledMeal {
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ScheduledMeal else { return false }
        return self.objectID == other.objectID
    }
    
    public override var hash: Int {
        return objectID.hashValue
    }
}