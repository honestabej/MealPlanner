import UIKit
import CoreData

class ProfileViewController: UIViewController {
    let mealPlannerService = MealPlannerService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"

        let createUserButton = UIButton(type: .system)
        createUserButton.setTitle("Set Test Data", for: .normal)
        createUserButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        createUserButton.backgroundColor = UIColor.systemBlue
        createUserButton.setTitleColor(.white, for: .normal)
        createUserButton.layer.cornerRadius = 8
        createUserButton.translatesAutoresizingMaskIntoConstraints = false
        createUserButton.addTarget(self, action: #selector(setTestDataPressed), for: .touchUpInside)
        view.addSubview(createUserButton)

        let printTestDataButton = UIButton(type: .system)
        printTestDataButton.setTitle("Print Test Data", for: .normal)
        printTestDataButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        printTestDataButton.backgroundColor = UIColor.systemGreen
        printTestDataButton.setTitleColor(.white, for: .normal)
        printTestDataButton.layer.cornerRadius = 8
        printTestDataButton.translatesAutoresizingMaskIntoConstraints = false
        printTestDataButton.addTarget(self, action: #selector(printTestData), for: .touchUpInside)
        view.addSubview(printTestDataButton)
        
        NSLayoutConstraint.activate([
            createUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createUserButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            createUserButton.widthAnchor.constraint(equalToConstant: 160),
            createUserButton.heightAnchor.constraint(equalToConstant: 44),

            printTestDataButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            printTestDataButton.topAnchor.constraint(equalTo: createUserButton.bottomAnchor, constant: 16),
            printTestDataButton.widthAnchor.constraint(equalToConstant: 160),
            printTestDataButton.heightAnchor.constraint(equalToConstant: 44)
        ])        
    }

    @objc private func setTestDataPressed() {
        print("Setting test data...")
        Task {
            await createTestUsers()
            await createTestRecipes()
            await createTestMealPlans()
            await createTestScheduledMeals()
            await createTestGroceries()
            print("Test data set successfully")
        }
    }

    @objc private func printTestData() {
        print("Fetching all data...")
        let allUsers = mealPlannerService.fetchAllUsers()
        for user in allUsers {
            print("\(user.name), \(user.email), with following relationships:")
            
            print("  Family Settings:")
            let familySettings = mealPlannerService.fetchFamilySettings(for: user)
            print("    Start Day: \(String(describing: familySettings!.startDay))")
            
            print("  Recipes:")
            let allRecipes = mealPlannerService.fetchRecipes(for: user)
            for recipe in allRecipes {
                print("    \(recipe.name)")
            }

            print("  Meal Plans:")
            let allMealPlans = mealPlannerService.fetchMealPlans(for: user)
            for mealPlan in allMealPlans {
                print("    \(mealPlan.name)")
                let mealPlanScheduledMeals = mealPlannerService.fetchScheduledMealsOfMealPlan(for: mealPlan)
                for meal in mealPlanScheduledMeals {
                    print("      \(meal.recipe.name), \(meal.daysAndMeals)")
                }
            }

            print("  Scheduled Meals (with weekOf):")
            let allScheduledMeals = mealPlannerService.fetchScheduledMealsWithWeekOf(for: user)
            for scheduledMeal in allScheduledMeals {
                print("    \(scheduledMeal.recipe.name), \(scheduledMeal.daysAndMeals), weekOf: \(String(describing: scheduledMeal.weekOf))")
            }
            
            print("  Groceries:")
            let allGroceries = mealPlannerService.fetchGroceries(of: user)
            for grocery in allGroceries {
                print("    \(grocery.name)")
            }
        }
        print("Data fetched successfully.")
    }

    private func createTestUsers() async {
        // User 1
        await withCheckedContinuation { continuation in
            mealPlannerService.createUser(name: "Abe Johnson", email: "Abe@example.com", password: "password123") { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let user):
                            print("User created successfully: \(user.name)")
                            continuation.resume()
                            
                        case .failure(let error):
                            print("Failed to create user: \(error.localizedDescription)")
                            continuation.resume()
                    }
                }
            }
        }

        // User 2
        await withCheckedContinuation { continuation in
            mealPlannerService.createUser(name: "Shae Johnson", email: "Shae@example.com", password: "password123") { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let user):
                            print("User created successfully: \(user.name)")
                            continuation.resume()
                            
                        case .failure(let error):
                            print("Failed to create user: \(error.localizedDescription)")
                            continuation.resume()
                    }
                }
            }
        }
    }

    private func createTestRecipes() async {
        guard let uiImage = UIImage(named: "RecipeDefault"), let imageData = uiImage.pngData() else {
            print("⚠️ Failed to load image or convert to Data")
            return
        }

        let testRecipeAlert = RecipeAlertData(
            title: "Test Alert",
            message: "This is a test alert for your recipe.",
            hoursBeforeStart: 2.0,
            isEnabled: true,
            notificationIdentifier: nil
        )

        guard let user = mealPlannerService.fetchUser(by: "Abe@example.com") else {
            print("Failed to find user")
            return
        }

        // Recipe 1
        await withCheckedContinuation { continuation in
            mealPlannerService.createRecipe(name: "Test Recipe 1", image: imageData, ingredients: ["Test Ing 1", "Test Ing 2", "Test Ing 3"], instructions: "1. Do step 1 here.\n2. Now after step 1, do step2.\n3. And finally, after both of the first two steps, complete step 3.", tags: ["Test Tag 1", "Test Tag 2", "Test Tag 3", "Test Tag 4"], alerts: [testRecipeAlert], user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipe):
                        print("Recipe 1 created: \(recipe.name)")
                    case .failure(let error):
                        print("Failed to create Recipe 1: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // Recipe 2
        await withCheckedContinuation { continuation in
            mealPlannerService.createRecipe(name: "Test Recipe 2", image: imageData, ingredients: ["Test Ing 1", "Test Ing 2", "Test Ing 3"], instructions: "1. Do step 1 here.\n2. Now after step 1, do step2.\n3. And finally, after both of the first two steps, complete step 3.", tags: ["Test Tag 1", "Test Tag 2", "Test Tag 3", "Test Tag 4"], alerts: [testRecipeAlert], user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipe):
                        print("Recipe 2 created: \(recipe.name)")
                    case .failure(let error):
                        print("Failed to create Recipe 2: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // Recipe 3
        await withCheckedContinuation { continuation in
            mealPlannerService.createRecipe(name: "Test Recipe 3", image: imageData, ingredients: ["Test Ing 1", "Test Ing 2", "Test Ing 3"], instructions: "1. Do step 1 here.\n2. Now after step 1, do step2.\n3. And finally, after both of the first two steps, complete step 3.", tags: ["Test Tag 1", "Test Tag 2", "Test Tag 3", "Test Tag 4"], alerts: [testRecipeAlert], user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipe):
                        print("Recipe 3 created: \(recipe.name)")
                    case .failure(let error):
                        print("Failed to create Recipe 3: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }
    }


    private func createTestMealPlans() async {
        guard let user = mealPlannerService.fetchUser(by: "Abe@example.com") else {
            print("Failed to find user")
            return
        }

        // Meal Plan 1
        await withCheckedContinuation { continuation in
            mealPlannerService.createMealPlan(name: "Test Meal Plan 1", user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let mealPlan):
                        print("Meal Plan 1 created: \(mealPlan.name)")
                    case .failure(let error):
                        print("Failed to create Meal Plan 1: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // Meal Plan 2
        await withCheckedContinuation { continuation in
            mealPlannerService.createMealPlan(name: "Test Meal Plan 2", user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let mealPlan):
                        print("Meal Plan 2 created: \(mealPlan.name)")
                    case .failure(let error):
                        print("Failed to create Meal Plan 2: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }
    }

    private func createTestScheduledMeals() async {
        guard let user = mealPlannerService.fetchUser(by: "Abe@example.com") else {
            print("Failed to find user")
            return
        }

        guard let recipe1 = mealPlannerService.fetchRecipeNamed("Test Recipe 1", for: user),
            let recipe2 = mealPlannerService.fetchRecipeNamed("Test Recipe 2", for: user),
            let recipe3 = mealPlannerService.fetchRecipeNamed("Test Recipe 3", for: user) else {
            print("Failed to find recipes")
            return
        }

        let mealPlans = mealPlannerService.fetchMealPlans(for: user)
        guard mealPlans.count >= 2 else {
            print("Not enough meal plans found for user")
            return
        }

        let calendar = Calendar.current
        let today = Date()
        let weekOf = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let lastWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: weekOf)!

        let daysAndMeals1: [String: [String]] = ["Monday": ["Breakfast", "Lunch"], "Tuesday": ["Dinner"]]
        let daysAndMeals2: [String: [String]] = ["Wednesday": ["Lunch"], "Friday": ["Dinner"]]

        // ScheduledMeal 1
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(daysAndMeals: daysAndMeals1, recipe: recipe1, user: user, mealPlan: mealPlans[0]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 1 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 1: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 2
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(recipe: recipe2, user: user, mealPlan: mealPlans[0]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 2 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 2: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 3
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(recipe: recipe3, user: user, mealPlan: mealPlans[1]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 3 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 3: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 4
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(daysAndMeals: daysAndMeals2, recipe: recipe2, user: user, mealPlan: mealPlans[1]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 4 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 4: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 5
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(recipe: recipe3, user: user, mealPlan: mealPlans[1]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 5 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 5: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 6
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(weekOf: weekOf, recipe: recipe1, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 6 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 6: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 7
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(daysAndMeals: daysAndMeals1, weekOf: weekOf, recipe: recipe2, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 7 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 7: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 8
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(daysAndMeals: daysAndMeals2, weekOf: lastWeek, recipe: recipe1, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 8 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 8: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 9
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(daysAndMeals: daysAndMeals1, weekOf: lastWeek, recipe: recipe2, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 9 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 9: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }

        // ScheduledMeal 10
        await withCheckedContinuation { continuation in
            mealPlannerService.createScheduledMeal(weekOf: lastWeek, recipe: recipe3, user: user) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let scheduledMeal):
                        print("ScheduledMeal 10 created: \(scheduledMeal.recipe.name)")
                    case .failure(let error):
                        print("Failed to create ScheduledMeal 10: \(error.localizedDescription)")
                    }
                    continuation.resume()
                }
            }
        }
    }

    func createTestGroceries() async {
        let testGroceries = [
            "Milk", "Eggs", "Bread", "Chicken Breast", "Spinach",
            "Tomatoes", "Cheddar Cheese", "Apples", "Bananas", "Rice"
        ]

        guard let user = mealPlannerService.fetchUser(by: "Abe@example.com") else {
            print("Failed to find user")
            return
        }

        for groceryName in testGroceries {
            await withCheckedContinuation { continuation in
                mealPlannerService.createGrocery(name: groceryName, user: user) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let grocery):
                            print("Grocery created: \(grocery.name)")
                        case .failure(let error):
                            print("Failed to create grocery \(groceryName): \(error.localizedDescription)")
                        }
                        continuation.resume()
                    }
                }
            }
        }
    }

}
