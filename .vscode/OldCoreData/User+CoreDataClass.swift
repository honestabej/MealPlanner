import CoreData
import Foundation

@objc(User)
public class User: NSManagedObject {
    
    // MARK: - Convenience Properties
    var recipesArray: [Recipe] {
        let set = recipes as? Set<Recipe> ?? []
        return set.sorted { $0.name < $1.name }
    }
    
    var mealPlansArray: [MealPlan] {
        let set = mealPlans as? Set<MealPlan> ?? []
        return set.sorted { $0.name < $1.name }
    }
    
    // MARK: - Factory Method
    static func create(name: String, email: String, password: String, in context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.name = name
        user.email = email
        user.password = password
        user.uuid = UUID().uuidString
        return user
    }
    
    // MARK: - Validation
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateUser()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateUser()
    }
    
    private func validateUser() throws {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError.emptyName
        }
        
        if !email.contains("@") || !email.contains(".") {
            throw ValidationError.invalidEmail
        }
        
        if password.count < 6 {
            throw ValidationError.passwordTooShort
        }
    }
    
    // MARK: - Computed Properties
    var recipeCount: Int {
        return recipes?.count ?? 0
    }
    
    var mealPlanCount: Int {
        return mealPlans?.count ?? 0
    }
    
    // MARK: - Helper Methods
    func addRecipe(_ recipe: Recipe) {
        addToRecipes(recipe)
    }
    
    func removeRecipe(_ recipe: Recipe) {
        removeFromRecipes(recipe)
    }
    
    func addMealPlan(_ mealPlan: MealPlan) {
        addToMealPlans(mealPlan)
    }
    
    func removeMealPlan(_ mealPlan: MealPlan) {
        removeFromMealPlans(mealPlan)
    }
}

// MARK: - Validation Errors
enum ValidationError: LocalizedError {
    case emptyName
    case invalidEmail
    case passwordTooShort
    
    var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Name cannot be empty"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 6 characters long"
        }
    }
}

// MARK: - Core Data Properties
extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var uuid: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var recipes: NSSet?
    @NSManaged public var mealPlans: NSSet?
}

// MARK: - Generated accessors for recipes
extension User {
    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: Recipe)
    
    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: Recipe)
    
    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSSet)
    
    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSSet)
}

// MARK: - Generated accessors for mealPlans
extension User {
    @objc(addMealPlansObject:)
    @NSManaged public func addToMealPlans(_ value: MealPlan)
    
    @objc(removeMealPlansObject:)
    @NSManaged public func removeFromMealPlans(_ value: MealPlan)
    
    @objc(addMealPlans:)
    @NSManaged public func addToMealPlans(_ values: NSSet)
    
    @objc(removeMealPlans:)
    @NSManaged public func removeFromMealPlans(_ values: NSSet)
}






    
    // func createUser() {
    //     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    //     do {
    //         let user = User.create(name: "Jane Doe", email: "jane@example.com", password: "mypassword", in: context)
    //         try context.save()
    //         print("User saved: \(user.name)")
    //     } catch {
    //         print("Error saving user: \(error.localizedDescription)")
    //     }
    // }
    
    // func fetchUsers() -> [User] {
    //     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //     let request: NSFetchRequest<User> = User.fetchRequest()
        
    //     do {
    //         return try context.fetch(request)
    //     } catch {
    //         print("Error fetching users: \(error)")
    //         return []
    //     }
    // }