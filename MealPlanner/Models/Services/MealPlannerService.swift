import CoreData
import Foundation

class MealPlannerService {
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext

    init() {
        self.mainContext = CoreDataStack.shared.mainContext
        self.backgroundContext = CoreDataStack.shared.newBackgroundContext()
    }

    private func saveMainContext() {
        CoreDataStack.shared.saveContext()
    }
    
    private func saveBackgroundContext() {
        CoreDataStack.shared.saveBackgroundContext(backgroundContext)
    }

    // Creates a new user with validation and error handling
    func createUser(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                // Check if user with email already exists
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "email == %@", email)
                
                let existingUsers = try self.backgroundContext.fetch(fetchRequest)
                if !existingUsers.isEmpty {
                    completion(.failure(UserError.emailAlreadyExists))
                    return
                }
                
                // Create new user
                let user = User.create(name: name, email: email, password: password, in: self.backgroundContext)

                // Also create FamilySettings for the new user
                FamilySettings.create(user: user, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                // Get the user in main context for UI updates
                let mainContextUser = self.mainContext.object(with: user.objectID) as! User
                completion(.success(mainContextUser))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Updates an existing user
    func updateUser(_ user: User, name: String? = nil, email: String? = nil, password: String? = nil, completion: @escaping (Result<User, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                // Get user in background context
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User
                
                // If updating email, check for duplicates
                if let newEmail = email, newEmail != backgroundUser.email {
                    let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "email == %@ AND uuid != %@", newEmail, backgroundUser.uuid)
                    
                    let existingUsers = try self.backgroundContext.fetch(fetchRequest)
                    if !existingUsers.isEmpty {
                        completion(.failure(UserError.emailAlreadyExists))
                        return
                    }
                }
                
                // Update user
                User.update(user: backgroundUser, name: name, email: email, password: password, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                // Get updated user in main context
                let mainContextUser = self.mainContext.object(with: user.objectID) as! User
                completion(.success(mainContextUser))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetches all users
    func fetchAllUsers() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try mainContext.fetch(fetchRequest)
            return users
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
    
    // Fetches user by email
    func fetchUser(by email: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1
        
        do {
            return try mainContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch user by email: \(error)")
            return nil
        }
    }
    
    // Deletes a user
    func deleteUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User
                self.backgroundContext.delete(backgroundUser)
                try self.backgroundContext.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Update Family Settings
    
    
    // Fetch Family Settings
    func fetchFamilySettings(for user: User) -> FamilySettings? {
        let fetchRequest: NSFetchRequest<FamilySettings> = FamilySettings.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        fetchRequest.fetchLimit = 1
        
        do {
            return try mainContext.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch family settings: \(error)")
            return nil
        }
    }

    // Create a recipe
    func createRecipe(name: String, image: Data? = nil, ingredients: [String] = [], instructions: String = "", tags: [String] = [], alerts: [RecipeAlertData] = [], user: User, completion: @escaping (Result<Recipe, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                // Get the user in the background context using its objectID
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User

                // Create new recipe
                let recipe = Recipe.create(name: name, image: image, ingredients: ingredients, instructions: instructions, tags: tags, alerts: alerts, user: backgroundUser, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                // Get the user in main context for UI updates
                completion(.success(recipe))
                
            } catch {
                completion(.failure(error))
            }
        }
    }

    // Update an existing recipe


    // Fetch all recipes of a user
    func fetchRecipes(for user: User) -> [Recipe] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        do {
            let recipes = try mainContext.fetch(fetchRequest)
            return recipes
        } catch {
            print("Failed to fetch recipes for user: \(error)")
            return []
        }
    }

    // Fetch a recipe of a user by name
    func fetchRecipeNamed(_ name: String, for user: User) -> Recipe? {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND user == %@", name, user)
        do {
            let recipes = try mainContext.fetch(fetchRequest)
            return recipes.first
        } catch {
            print("Failed t fetch recipe \(name)")
            return nil
        }
    }


    // Delete a recipe


    // Create a meal plan
    func createMealPlan(name: String, user: User, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            do {
                // Get the user in the background context using its objectID
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User

                // Create new recipe
                let mealPlan = MealPlan.create(name: name, user: backgroundUser, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                completion(.success(mealPlan))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Fetch all meal plans of a user
    func fetchMealPlans(for user: User) -> [MealPlan] {
        let fetchRequest: NSFetchRequest<MealPlan> = MealPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        do {
            let mealPlans = try mainContext.fetch(fetchRequest)
            return mealPlans
        } catch {
            print("Failed to fetch meal plans for user: \(error)")
            return []
        }
    }

    // Update a meal plan
    
    
    // Delete a meal plan
    
    
    // Create a scheduled meal
    func createScheduledMeal(daysAndMeals: [String: [String]] = [:], weekOf: Date? = nil, recipe: Recipe, user: User, mealPlan: MealPlan? = nil, completion: @escaping (Result<ScheduledMeal, Error>) -> Void) {
        backgroundContext.perform{ [weak self] in
            guard let self = self else { return }
            
            do {
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User
                let backgroundRecipe = self.backgroundContext.object(with: recipe.objectID) as! Recipe
                let backgroundMealPlan = mealPlan != nil ? self.backgroundContext.object(with: mealPlan!.objectID) as? MealPlan : nil
                
                // Create new scheduledMeal
                let scheduledMeal = ScheduledMeal.create(daysAndMeals: daysAndMeals, weekOf: weekOf, recipe: backgroundRecipe, user: backgroundUser, mealPlan: backgroundMealPlan, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                completion(.success(scheduledMeal))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Update a scheduled meal
    
    
    // Delete a scheduled meal
    
    
    // Fetch all scheduled meals of a user
    func fetchScheduledMeals(for user: User) -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        do {
            let mealPlans = try mainContext.fetch(fetchRequest)
            return mealPlans
        } catch {
            print("Failed to fetch scheduled meals for user: \(error)")
            return []
        }
    }
    
    // Fetch all scheduled meals of a meal plan
    func fetchScheduledMealsOfMealPlan(for mealPlan: MealPlan) -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mealPlan == %@", mealPlan)
        do {
            let mealPlans = try mainContext.fetch(fetchRequest)
            return mealPlans
        } catch {
            print("Failed to fetch scheduled meals for meal plan: \(error)")
            return []
        }
    }
    
    // Fetch all scheduled meals for a week of
    func fetchScheduledMealsOfWeek(for weekOf: Date) -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekOf == %@", weekOf as CVarArg)
        do {
            let mealPlans = try mainContext.fetch(fetchRequest)
            return mealPlans
        } catch {
            print("Failed to fetch scheduled meals for week of: \(error)")
            return []
        }
    }
    
    // Fetch all scheduled meals with weekOf populated
    func fetchScheduledMealsWithWeekOf(for user: User) -> [ScheduledMeal] {
        let fetchRequest: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "weekOf != nil AND user == %@", user)
        do {
            let scheduledMeals = try mainContext.fetch(fetchRequest)
            return scheduledMeals
        } catch {
            print("Failed to fetch scheduled meals with weekOf for user: \(error)")
            return []
        }
    }
    
    // Create a new grocery
    func createGrocery(name: String, user: User, completion: @escaping (Result<Grocery, Error>) -> Void) {
        backgroundContext.perform{ [weak self] in
            guard let self = self else { return }
            
            do {
                let backgroundUser = self.backgroundContext.object(with: user.objectID) as! User
                
                // Create new scheduledMeal
                let grocery = Grocery.create(name: name, user: backgroundUser, in: self.backgroundContext)
                
                // Save to background context
                try self.backgroundContext.save()
                
                completion(.success(grocery))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Delete a grocery
    
    
    // Fetch all groceries of a user
    func fetchGroceries(of user: User) -> [Grocery] {
        let fetchRequest: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", user as CVarArg)
        do {
            let groceries = try mainContext.fetch(fetchRequest)
            return groceries
        } catch {
            print("Failed to fetch groceries of user \(user)")
            return []
        }
    }
}

// Custom Errors
enum UserError: LocalizedError {
    case emailAlreadyExists
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyExists:
            return "A user with this email already exists"
        case .userNotFound:
            return "User not found"
        }
    }
}
