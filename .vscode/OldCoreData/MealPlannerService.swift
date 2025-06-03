import CoreData
import Foundation

class MealPlannerService {
    
    // MARK: - Properties
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    
    // MARK: - Initialization
    init() {
        self.mainContext = CoreDataStack.shared.mainContext
        self.backgroundContext = CoreDataStack.shared.newBackgroundContext()
    }
    
    // MARK: - User Management
    func createUser(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        backgroundContext.perform {
            do {
                // Check if user already exists
                if self.userExists(email: email, in: self.backgroundContext) {
                    DispatchQueue.main.async {
                        completion(.failure(MealPlannerError.userAlreadyExists))
                    }
                    return
                }
                
                let user = User.create(name: name, email: email, password: password, in: self.backgroundContext)
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    let mainContextUser = self.mainContext.object(with: user.objectID) as! User
                    completion(.success(mainContextUser))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func authenticateUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        backgroundContext.perform {
            do {
                let request: NSFetchRequest<User> = User.fetchRequest()
                request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
                request.fetchLimit = 1
                
                let users = try self.backgroundContext.fetch(request)
                
                DispatchQueue.main.async {
                    if let user = users.first {
                        let mainContextUser = self.mainContext.object(with: user.objectID) as! User
                        completion(.success(mainContextUser))
                    } else {
                        completion(.failure(MealPlannerError.invalidCredentials))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchUser(by email: String) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1
        
        do {
            return try mainContext.fetch(request).first
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
    }
    
    private func userExists(email: String, in context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
    
    // MARK: - Recipe Management
    func createRecipe(name: String, ingredients: [String], instructions: String, tags: [String] = [], alerts: [String] = [], user: User, completion: @escaping (Result<Recipe, Error>) -> Void) {
        backgroundContext.perform {
            do {
                let bgUser = self.backgroundContext.object(with: user.objectID) as! User
                let recipe = Recipe.create(name: name, ingredients: ingredients, instructions: instructions, user: bgUser, in: self.backgroundContext)
                
                if !tags.isEmpty {
                    recipe.updateTags(tags)
                }
                
                if !alerts.isEmpty {
                    recipe.updateAlerts(alerts)
                }
                
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    let mainContextRecipe = self.mainContext.object(with: recipe.objectID) as! Recipe
                    completion(.success(mainContextRecipe))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchRecipes(for user: User, searchText: String = "", tags: [String] = []) -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        var predicates: [NSPredicate] = [NSPredicate(format: "user == %@", user)]
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name CONTAINS[cd] %@", searchText))
        }
        
        if !tags.isEmpty {
            let tagPredicates = tags.map { NSPredicate(format: "tags CONTAINS[cd] %@", $0) }
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: tagPredicates))
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error fetching recipes: \(error)")
            return []
        }
    }
    
    func updateRecipe(_ recipe: Recipe, name: String? = nil, ingredients: [String]? = nil, instructions: String? = nil, tags: [String]? = nil, alerts: [String]? = nil) {
        if let name = name { recipe.name = name }
        if let ingredients = ingredients { recipe.ingredients = ingredients }
        if let instructions = instructions { recipe.instructions = instructions }
        if let tags = tags { recipe.updateTags(tags) }
        if let alerts = alerts { recipe.updateAlerts(alerts) }
        
        saveMainContext()
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        mainContext.delete(recipe)
        saveMainContext()
    }
    
    // MARK: - Meal Plan Management
    func createMealPlan(name: String, user: User, completion: @escaping (Result<MealPlan, Error>) -> Void) {
        backgroundContext.perform {
            do {
                let bgUser = self.backgroundContext.object(with: user.objectID) as! User
                let mealPlan = MealPlan.create(name: name, user: bgUser, in: self.backgroundContext)
                
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    let mainContextMealPlan = self.mainContext.object(with: mealPlan.objectID) as! MealPlan
                    completion(.success(mainContextMealPlan))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchMealPlans(for user: User) -> [MealPlan] {
        let request: NSFetchRequest<MealPlan> = MealPlan.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MealPlan.name, ascending: true)]
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error fetching meal plans: \(error)")
            return []
        }
    }
    
    func deleteMealPlan(_ mealPlan: MealPlan) {
        mainContext.delete(mealPlan)
        saveMainContext()
    }
    
    // MARK: - Scheduled Meal Management
    func scheduleRecipe(_ recipe: Recipe, for date: Date, mealType: String, in mealPlan: MealPlan, completion: @escaping (Result<ScheduledMeal, Error>) -> Void) {
        backgroundContext.perform {
            do {
                let bgRecipe = self.backgroundContext.object(with: recipe.objectID) as! Recipe
                let bgMealPlan = self.backgroundContext.object(with: mealPlan.objectID) as! MealPlan
                
                let scheduledMeal = ScheduledMeal.create(date: date, dayMeal: mealType, recipe: bgRecipe, mealPlan: bgMealPlan, in: self.backgroundContext)
                
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    let mainContextScheduledMeal = self.mainContext.object(with: scheduledMeal.objectID) as! ScheduledMeal
                    completion(.success(mainContextScheduledMeal))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchScheduledMeals(for mealPlan: MealPlan, from startDate: Date, to endDate: Date) -> [ScheduledMeal] {
        let request: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        request.predicate = NSPredicate(format: "mealPlan == %@ AND date >= %@ AND date <= %@", 
                                       mealPlan, startDate as NSDate, endDate as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ScheduledMeal.date, ascending: true),
            NSSortDescriptor(keyPath: \ScheduledMeal.dayMeal, ascending: true)
        ]
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error fetching scheduled meals: \(error)")
            return []
        }
    }
    
    func fetchScheduledMeals(for date: Date, mealPlan: MealPlan) -> [ScheduledMeal] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return fetchScheduledMeals(for: mealPlan, from: startOfDay, to: endOfDay)
    }
    
    func updateScheduledMeal(_ scheduledMeal: ScheduledMeal, date: Date? = nil, mealType: String? = nil, recipe: Recipe? = nil) {
        if let date = date { scheduledMeal.date = date }
        if let mealType = mealType { scheduledMeal.dayMeal = mealType }
        if let recipe = recipe { scheduledMeal.recipe = recipe }
        
        saveMainContext()
    }
    
    func deleteScheduledMeal(_ scheduledMeal: ScheduledMeal) {
        mainContext.delete(scheduledMeal)
        saveMainContext()
    }
    
    // MARK: - Batch Operations
    func bulkScheduleRecipes(_ recipeSchedules: [(recipe: Recipe, date: Date, mealType: String)], in mealPlan: MealPlan, completion: @escaping (Result<[ScheduledMeal], Error>) -> Void) {
        backgroundContext.perform {
            do {
                let bgMealPlan = self.backgroundContext.object(with: mealPlan.objectID) as! MealPlan
                var scheduledMeals: [ScheduledMeal] = []
                
                for schedule in recipeSchedules {
                    let bgRecipe = self.backgroundContext.object(with: schedule.recipe.objectID) as! Recipe
                    let scheduledMeal = ScheduledMeal.create(
                        date: schedule.date,
                        dayMeal: schedule.mealType,
                        recipe: bgRecipe,
                        mealPlan: bgMealPlan,
                        in: self.backgroundContext
                    )
                    scheduledMeals.append(scheduledMeal)
                }
                
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    let mainContextScheduledMeals = scheduledMeals.map { 
                        self.mainContext.object(with: $0.objectID) as! ScheduledMeal 
                    }
                    completion(.success(mainContextScheduledMeals))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func clearMealPlan(_ mealPlan: MealPlan, from startDate: Date, to endDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform {
            do {
                let bgMealPlan = self.backgroundContext.object(with: mealPlan.objectID) as! MealPlan
                let request: NSFetchRequest<NSFetchRequestResult> = ScheduledMeal.fetchRequest()
                request.predicate = NSPredicate(format: "mealPlan == %@ AND date >= %@ AND date <= %@", 
                                               bgMealPlan, startDate as NSDate, endDate as NSDate)
                
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try self.backgroundContext.execute(batchDeleteRequest)
                try self.backgroundContext.save()
                
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Search and Analytics
    func searchRecipes(query: String, user: User) -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@ AND (name CONTAINS[cd] %@ OR ingredients CONTAINS[cd] %@ OR tags CONTAINS[cd] %@)", 
                                       user, query, query, query)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Recipe.name, ascending: true)]
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error searching recipes: \(error)")
            return []
        }
    }
    
    func getMostUsedRecipes(for user: User, limit: Int = 10) -> [Recipe] {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        request.sortDescriptors = [NSSortDescriptor(key: "scheduledMeals.@count", ascending: false)]
        request.fetchLimit = limit
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error fetching most used recipes: \(error)")
            return []
        }
    }
    
    func getUpcomingMeals(for user: User, days: Int = 7) -> [ScheduledMeal] {
        let now = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: days, to: now)!
        
        let request: NSFetchRequest<ScheduledMeal> = ScheduledMeal.fetchRequest()
        request.predicate = NSPredicate(format: "mealPlan.user == %@ AND date >= %@ AND date <= %@", 
                                       user, now as NSDate, futureDate as NSDate)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ScheduledMeal.date, ascending: true),
            NSSortDescriptor(keyPath: \ScheduledMeal.dayMeal, ascending: true)
        ]
        
        do {
            return try mainContext.fetch(request)
        } catch {
            print("Error fetching upcoming meals: \(error)")
            return []
        }
    }
    
    // MARK: - Helper Methods
    private func saveMainContext() {
        CoreDataStack.shared.saveContext()
    }
    
    private func saveBackgroundContext() {
        CoreDataStack.shared.saveBackgroundContext(backgroundContext)
    }
}

// MARK: - Custom Errors
enum MealPlannerError: LocalizedError {
    case userAlreadyExists
    case invalidCredentials
    case recipeNotFound
    case mealPlanNotFound
    case invalidMealType
    
    var errorDescription: String? {
        switch self {
        case .userAlreadyExists:
            return "A user with this email already exists"
        case .invalidCredentials:
            return "Invalid email or password"
        case .recipeNotFound:
            return "Recipe not found"
        case .mealPlanNotFound:
            return "Meal plan not found"
        case .invalidMealType:
            return "Invalid meal type"
        }
    }
}