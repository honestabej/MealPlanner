import CoreData
import UIKit

class TestFunctions {
    private let mainContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    public var testDataOutputStringToReturn: String

    init() {
        self.mainContext = CoreDataStack.shared.mainContext
        self.backgroundContext = CoreDataStack.shared.newBackgroundContext()
        testDataOutputStringToReturn = "Test data: \n"
    }

    // Called by the setTestDataBtn
    func setTestData() -> String {
        print("Setting test data...")
        let family = createFamilyEntity()
        createUserEntities(family: family)
        createRecipeEntities(family: family)
        let mealPlans = createMealPlanEntities(family: family)
        createTemplateMealEntites(mealPlans: mealPlans)
        createScheduldMealEntities(family: family)
        createGroceryEntities(family: family)
        
        // Finish
        do {
            try mainContext.save()
            print("Test data saved successfully.\n\n")
            return "Test data saved successfully."
        } catch {
            testDataOutputStringToReturn = "Error setting test data"
            print("Failed to save test data: \(error.localizedDescription)\n\n")
            return "Failed to save test data: \(error.localizedDescription)"
        }
    }
    
    // Called by the deleteTestDataBtn
    func deleteTestData() -> String {
        print("Deleting test data...")
        let returnString = CoreDataStack().deletePersistentStore() + "\n\n"
        return returnString
    }
    
    // Called by the printTestDataBtn
    func printTestData() -> String {
        print("Printing test data...")
        var returnString: String = ""
        
        // Family
        let family = FamilyService.getFamily(in: mainContext)
        returnString.append("Family name: \(family?.name ?? "NO FAMILY FOUND") starts: \(family?.startDay ?? 0)\n")
        
        // Users
        returnString.append("  USERS: \n")
        let users = family?.usersArray
        for user in users ?? [] {
            returnString.append("    \(user.name)\n")
        }
        
        // Recipes
        returnString.append("  RECIPES: \n")
        let recipes = family?.recipesArray
        for recipe in recipes ?? [] {
            returnString.append("    \(recipe.name)\n")
        }
        
        // Meal Plans
        returnString.append("  MEAL PLANS: \n")
        let mealPlans = family?.mealPlansArray
        for mealPlan in mealPlans ?? [] {
            returnString.append("    \(mealPlan.name)\n")
            
            // Template Meals
            returnString.append("      TEMPLATE MEALS: \n")
            let templateMeals = mealPlan.templateMealsArray
            for templateMeal in templateMeals {
                returnString.append("        \(templateMeal.day) \(templateMeal.meal), \(templateMeal.recipe.name)\n")
            }
        }
        
        // Scheduled Meals
        returnString.append(("  SCHEDULED MEALS: \n"))
        let scheduledMeals = family?.scheduledMealsArray
        for scheduledMeal in scheduledMeals ?? [] {
            returnString.append("    \(scheduledMeal.recipe.name): \(formatDateToDayMonth(scheduledMeal.date)), \(scheduledMeal.meal)\n")
        }
        
        // Groceries
        returnString.append(("  GROCERIES: \n"))
        let groceries = family?.groceriesArray
        for grocery in groceries ?? [] {
            returnString.append("    \(grocery.name)\n")
        }
        
        return returnString
    }
    
    /* Functions used for creating the various entities used for the test data */
    
    func createFamilyEntity() -> Family {
        print("  -> Creating family...")
        let family = FamilyService.create(in: mainContext)
        family.name = "Johnson Family"
        return family
    }
    
    func createUserEntities(family: Family) {
        print("  -> Creating users...")
        let user1 = UserService.create(family: family, in: mainContext)
        user1.name = "Abe"
        user1.email = "honestabej@hotmail.com"
        user1.password = "password"
        let user2 = UserService.create(family: family, in: mainContext)
        user2.name = "Shae"
        user2.email = "shaequit@gmail.com"
        user2.password = "password"
        _ = UserService.createManagedUser(family: family, name: "Drew", color: "#008000", in: mainContext)
    }
    
    func createRecipeEntities(family: Family) {
        print("  -> Creating recipes...")
        
        // Recipe 1 - Crockpot Chicken
        let recipe1alert1 = RecipeAlertData(
            alertID: UUID(),
            title: "Defrost Chicken",
            message: "Defrost chicken for crockpot chicken",
            hoursBeforeStart: 12.0,
            isEnabled: true
        )
        let recipe1alert2 = RecipeAlertData(
            alertID: UUID(),
            title: "Prep Crockpot",
            message: "Prep ingredients and start crockpot",
            hoursBeforeStart: 4.0,
            isEnabled: true
        )
        _ = RecipeService.create(
            name: "Crockpot Chicken",
            ingredients: ["Chicken Breasts", "Salsa", "Red Bell Pepper", "Lime Chips"],
            instructions: "1. Cut up red bell pepper into slices\n2. Put the chicken, salsa, and pepper slices into the crockpot\n3. Let cook for 4 hours and enjoy",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: ["Crockpot", "Easy", "Chicken", "Abe only"],
            alerts: [recipe1alert1, recipe1alert2],
            family: family, in: mainContext
        )
        
        // Recipe 2 - Grilled Chicken
        let recipe2alert1 = RecipeAlertData(
            alertID: UUID(),
            title: "Defrost Chicken",
            message: "Defrost chicken for grilled chicken",
            hoursBeforeStart: 12.0,
            isEnabled: true
        )
        _ = RecipeService.create(
            name: "Grilled Chicken",
            ingredients: ["Chicken Breasts", "Mesquite Seasoning", "Instant Mashed Potatoes", "Milk", "Butter", "Salt"],
            instructions: "1. Grill Chicken\n2. Follow instant mashed potatoes box",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: ["Easy", "Chicken", "Drew Approved"],
            alerts: [recipe2alert1],
            family: family, in: mainContext
        )
        
        // Recipe 3 - Red Baron
        _ = RecipeService.create(
            name: "Red Baron Pizza",
            ingredients: ["Red Baron Pizza"],
            instructions: "1. Preheat Oven to 400\n2. Cook the pizza for 14 minutes",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: ["Easy", "Frozen"],
            alerts: [],
            family: family, in: mainContext
        )
        
        // Recipe 4 - Chicken Alfredo
        let recipe4alert1 = RecipeAlertData(
            alertID: UUID(),
            title: "Defrost Chicken",
            message: "Defrost chicken for chicken alfredo",
            hoursBeforeStart: 12.0,
            isEnabled: true
        )
        _ = RecipeService.create(
            name: "Chicken Alfredo",
            ingredients: ["Chicken Breast", "Mini Penne", "2 Jars Alfredo Sauce", "Salt", "Pepper"],
            instructions: "1. Season chicken with salt and pepper and grill\n2. Boil mini penne pasta\n3. Slice up chicken and combine the chicken and sauce with the pasta",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: ["Pasta", "Easy", "Drew Approved", "Whole Family", "Chicken"],
            alerts: [recipe4alert1],
            family: family, in: mainContext
        )
        
        // Recipe 5 - Protein Shake
        _ = RecipeService.create(
            name: "Protein Shake",
            ingredients: ["Protein Powder", "Yogurt", "Frozen Strawberries"],
            instructions: "",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: [],
            alerts: [],
            family: family, in: mainContext
        )
        
        // Recipe 6 - Eggs and Bacon
        _ = RecipeService.create(
            name: "Eggs and Bacon",
            ingredients: ["Eggs", "Bacon"],
            instructions: "",
            image: UIImage(named: "RecipeDefault")?.pngData(),
            tags: [],
            alerts: [],
            family: family, in: mainContext
        )
    }
    
    func createMealPlanEntities(family: Family) -> [MealPlan] {
        print("  -> Creating meal plans...")
        let mealPlan1 = MealPlanService.create(name: "Plan1", family: family, in: mainContext)
        let mealPlan2 = MealPlanService.create(name: "Plan2", family: family, in: mainContext)
        let mealPlan3 = MealPlanService.create(name: "Plan3", family: family, in: mainContext)
        return [mealPlan1, mealPlan2, mealPlan3]
    }
    
    func createTemplateMealEntites(mealPlans: [MealPlan]) {
        print ("  -> Creating template meals...")
        
        // Get necessary recipes
        let crockpotChicken = RecipeService.getByName(name: "Crockpot Chicken", in: mainContext)
        let grilledChicken = RecipeService.getByName(name: "Grilled Chicken", in: mainContext)
        let redBaronPizza = RecipeService.getByName(name: "Red Baron Pizza", in: mainContext)
        let chickenAlfredo = RecipeService.getByName(name: "Chicken Alfredo", in: mainContext)
        let proteinShake = RecipeService.getByName(name: "Protein Shake", in: mainContext)
        let eggsAndBacon = RecipeService.getByName(name: "Eggs and Bacon", in: mainContext)
        
        // Get necessary users
        let abe = UserService.getByName(name: "Abe", in: mainContext)
        let shae = UserService.getByName(name: "Shae", in: mainContext)
        let drew = UserService.getByName(name: "Drew", in: mainContext)
        
        // For meal plan 1
        let tm1mp1 = TemplateMealService.create(day: "Sun", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm1mp1, user: abe!);
        let tm2mp1 = TemplateMealService.create(day: "Mon", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm2mp1, user: abe!);
        let tm3mp1 = TemplateMealService.create(day: "Tue", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm3mp1, user: abe!);
        let tm4mp1 = TemplateMealService.create(day: "Wed", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm4mp1, user: abe!);
        let tm5mp1 = TemplateMealService.create(day: "Thu", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm5mp1, user: abe!);
        let tm6mp1 = TemplateMealService.create(day: "Fri", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm6mp1, user: abe!);
        let tm7mp1 = TemplateMealService.create(day: "Sat", meal: "Breakfast", mealPlan: mealPlans[0], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm7mp1, user: abe!);
        let tm8mp1 = TemplateMealService.create(day: "Mon", meal: "Lunch", mealPlan: mealPlans[0], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm8mp1, user: abe!);
        let tm9mp1 = TemplateMealService.create(day: "Tue", meal: "Dinner", mealPlan: mealPlans[0], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm9mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm9mp1, user: drew!);
        let tm10mp1 = TemplateMealService.create(day: "Mon", meal: "Dinner", mealPlan: mealPlans[0], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm10mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm10mp1, user: shae!); TemplateMealService.addUser(templateMeal: tm10mp1, user: drew!);
        let tm11mp1 = TemplateMealService.create(day: "Thu", meal: "Lunch", mealPlan: mealPlans[0], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm11mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm11mp1, user: drew!);
        let tm12mp1 = TemplateMealService.create(day: "Fri", meal: "Dinner", mealPlan: mealPlans[0], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm12mp1, user: abe!);
        let tm13mp1 = TemplateMealService.create(day: "Thu", meal: "Dinner", mealPlan: mealPlans[0], recipe: redBaronPizza!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm13mp1, user: abe!);
        let tm14mp1 = TemplateMealService.create(day: "Tue", meal: "Lunch", mealPlan: mealPlans[0], recipe: chickenAlfredo!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm14mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm14mp1, user: shae!); TemplateMealService.addUser(templateMeal: tm14mp1, user: drew!);
        let tm15mp1 = TemplateMealService.create(day: "Wed", meal: "Lunch", mealPlan: mealPlans[0], recipe: chickenAlfredo!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm15mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm15mp1, user: shae!);
        let tm16mp1 = TemplateMealService.create(day: "Wed", meal: "Dinner", mealPlan: mealPlans[0], recipe: chickenAlfredo!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm16mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm16mp1, user: shae!);
        
        // For meal plan 2
        let tm17mp1 = TemplateMealService.create(day: "Sun", meal: "Breakfast", mealPlan: mealPlans[1], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm17mp1, user: abe!);
        let tm18mp1 = TemplateMealService.create(day: "Tue", meal: "Breakfast", mealPlan: mealPlans[1], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm18mp1, user: abe!);
        let tm19mp1 = TemplateMealService.create(day: "Sat", meal: "Breakfast", mealPlan: mealPlans[1], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm19mp1, user: abe!);
        let tm20mp1 = TemplateMealService.create(day: "Mon", meal: "Snack", mealPlan: mealPlans[1], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm20mp1, user: abe!);
        let tm21mp1 = TemplateMealService.create(day: "Wed", meal: "Snack", mealPlan: mealPlans[1], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm21mp1, user: abe!);
        let tm22mp1 = TemplateMealService.create(day: "Thu", meal: "Snack", mealPlan: mealPlans[1], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm22mp1, user: abe!);
        let tm23mp1 = TemplateMealService.create(day: "Fri", meal: "Snack", mealPlan: mealPlans[1], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm23mp1, user: abe!);
        let tm24mp1 = TemplateMealService.create(day: "Tue", meal: "Lunch", mealPlan: mealPlans[1], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm24mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm1mp1, user: drew!);
        let tm25mp1 = TemplateMealService.create(day: "Tue", meal: "Dinner", mealPlan: mealPlans[1], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm25mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm1mp1, user: drew!);
        let tm26mp1 = TemplateMealService.create(day: "Sat", meal: "Lunch", mealPlan: mealPlans[1], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm26mp1, user: abe!);
        let tm27mp1 = TemplateMealService.create(day: "Wed", meal: "Lunch", mealPlan: mealPlans[1], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm27mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm1mp1, user: drew!);
        let tm28mp1 = TemplateMealService.create(day: "Fri", meal: "Dinner", mealPlan: mealPlans[1], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm28mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm1mp1, user: shae!);
        let tm29mp1 = TemplateMealService.create(day: "Unscheduled", meal: "Unscheduled", mealPlan: mealPlans[1], recipe: redBaronPizza!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm29mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm1mp1, user: drew!);
        _ = TemplateMealService.create(day: "Wed", meal: "Dinner", mealPlan: mealPlans[1], recipe: chickenAlfredo!, in: mainContext)
        // Not assigned to User
        _ = TemplateMealService.create(day: "Wed", meal: "Dinner", mealPlan: mealPlans[1], recipe: chickenAlfredo!, in: mainContext)
        // Not assigned to User
        
        // For meal plan 3
        let tm32mp1 = TemplateMealService.create(day: "Tue", meal: "Breakfast", mealPlan: mealPlans[2], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm32mp1, user: abe!);
        let tm33mp1 = TemplateMealService.create(day: "Thu", meal: "Breakfast", mealPlan: mealPlans[2], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm33mp1, user: abe!);
        let tm34mp1 = TemplateMealService.create(day: "Thu", meal: "Dinner", mealPlan: mealPlans[2], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm34mp1, user: abe!);
        let tm35mp1 = TemplateMealService.create(day: "Sat", meal: "Breakfast", mealPlan: mealPlans[2], recipe: eggsAndBacon!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm35mp1, user: abe!);
        let tm36mp1 = TemplateMealService.create(day: "Mon", meal: "Snack", mealPlan: mealPlans[2], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm36mp1, user: abe!);
        let tm37mp1 = TemplateMealService.create(day: "Wed", meal: "Snack", mealPlan: mealPlans[2], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm37mp1, user: abe!);
        let tm38mp1 = TemplateMealService.create(day: "Fri", meal: "Snack", mealPlan: mealPlans[2], recipe: proteinShake!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm38mp1, user: abe!);
        let tm39mp1 = TemplateMealService.create(day: "Tue", meal: "Dinner", mealPlan: mealPlans[2], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm39mp1, user: abe!);
        let tm40mp1 = TemplateMealService.create(day: "Wed", meal: "Lunch", mealPlan: mealPlans[2], recipe: crockpotChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm40mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm40mp1, user: drew!);
        let tm41mp1 = TemplateMealService.create(day: "Sun", meal: "Lunch", mealPlan: mealPlans[2], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm41mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm41mp1, user: shae!); TemplateMealService.addUser(templateMeal: tm41mp1, user: drew!);
        let tm42mp1 = TemplateMealService.create(day: "Thu", meal: "Lunch", mealPlan: mealPlans[2], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm42mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm42mp1, user: shae!);
        let tm43mp1 = TemplateMealService.create(day: "Fri", meal: "Dinner", mealPlan: mealPlans[2], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm43mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm43mp1, user: shae!);
        let tm44mp1 = TemplateMealService.create(day: "Sat", meal: "Lunch", mealPlan: mealPlans[2], recipe: grilledChicken!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm44mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm44mp1, user: drew!);
        let tm45mp1 = TemplateMealService.create(day: "Wed", meal: "Dinner", mealPlan: mealPlans[2], recipe: redBaronPizza!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm45mp1, user: abe!);
        let tm46mp1 = TemplateMealService.create(day: "Mon", meal: "Dinner", mealPlan: mealPlans[2], recipe: chickenAlfredo!, in: mainContext)
        TemplateMealService.addUser(templateMeal: tm46mp1, user: abe!); TemplateMealService.addUser(templateMeal: tm46mp1, user: shae!); TemplateMealService.addUser(templateMeal: tm46mp1, user: drew!);
        _ = TemplateMealService.create(day: "Tue", meal: "Lunch", mealPlan: mealPlans[2], recipe: chickenAlfredo!, in: mainContext)
        // Not assigned to User
    }
    
    func createScheduldMealEntities(family: Family) {
        print ("  -> Creating scheduled meals...")
        
        // Get necessary recipes
        let crockpotChicken = RecipeService.getByName(name: "Crockpot Chicken", in: mainContext)
        let grilledChicken = RecipeService.getByName(name: "Grilled Chicken", in: mainContext)
        let redBaronPizza = RecipeService.getByName(name: "Red Baron Pizza", in: mainContext)
        let chickenAlfredo = RecipeService.getByName(name: "Chicken Alfredo", in: mainContext)
        let proteinShake = RecipeService.getByName(name: "Protein Shake", in: mainContext)
        let eggsAndBacon = RecipeService.getByName(name: "Eggs and Bacon", in: mainContext)
        
        // Get necessary users
        let abe = UserService.getByName(name: "Abe", in: mainContext)
        let shae = UserService.getByName(name: "Shae", in: mainContext)
        let drew = UserService.getByName(name: "Drew", in: mainContext)
        
        // Crockpot chicken
        let crockpotChicken1 = ScheduledMealService.create(date: getDateOfWeekday("Monday")!, meal: "Lunch", family: family, recipe: crockpotChicken!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: crockpotChicken1, user: abe!)
        let crockpotChicken2 = ScheduledMealService.create(date: getDateOfWeekday("Tuesday")!, meal: "Dinner", family: family, recipe: crockpotChicken!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: crockpotChicken2, user: abe!)
        
        // Grilled chicken
        let grilledChicken1 = ScheduledMealService.create(date: getDateOfWeekday("Monday")!, meal: "Dinner", family: family, recipe: grilledChicken!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: grilledChicken1, user: abe!); ScheduledMealService.addUser(scheduledMeal: grilledChicken1, user: shae!); ScheduledMealService.addUser(scheduledMeal: grilledChicken1, user: drew!)
        let grilledChicken2 = ScheduledMealService.create(date: getDateOfWeekday("Thursday")!, meal: "Lunch", family: family, recipe: grilledChicken!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: grilledChicken2, user: abe!); ScheduledMealService.addUser(scheduledMeal: grilledChicken2, user: drew!)
        let grilledChicken3 = ScheduledMealService.create(date: getDateOfWeekday("Friday")!, meal: "Dinner", family: family, recipe: grilledChicken!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: grilledChicken3, user: abe!); ScheduledMealService.addUser(scheduledMeal: grilledChicken3, user: shae!);
        
        // Red baron pizza
        let redBaronPizza1 = ScheduledMealService.create(date: getStartOfWeek()!, meal: "Unscheduled", family: family, recipe: redBaronPizza!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: redBaronPizza1, user: abe!);
        
        // Chicken alfredo
        let chickenAlfredo1 = ScheduledMealService.create(date: getDateOfWeekday("Tuesday")!, meal: "Lunch", family: family, recipe: chickenAlfredo!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: chickenAlfredo1, user: abe!); ScheduledMealService.addUser(scheduledMeal: chickenAlfredo1, user: shae!);
        _ = ScheduledMealService.create(date: getDateOfWeekday("Wednesday")!, meal: "Snack", family: family, recipe: chickenAlfredo!, in: mainContext)
        // Not linked to user
        let chickenAlfredo3 = ScheduledMealService.create(date: getDateOfWeekday("Wednesday")!, meal: "Dinner", family: family, recipe: chickenAlfredo!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: chickenAlfredo3, user: abe!); ScheduledMealService.addUser(scheduledMeal: chickenAlfredo3, user: shae!); ScheduledMealService.addUser(scheduledMeal: chickenAlfredo3, user: drew!);
        
        // Protein shake
        let proteinShake1 = ScheduledMealService.create(date: getStartOfWeek()!, meal: "Unscheduled", family: family, recipe: proteinShake!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: proteinShake1, user: abe!)
        
        // Eggs and bacon
        let eggsAndBacon1 = ScheduledMealService.create(date: getDateOfWeekday("Sunday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon1, user: abe!);
        let eggsAndBacon2 = ScheduledMealService.create(date: getDateOfWeekday("Monday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon2, user: abe!);
        let eggsAndBacon3 = ScheduledMealService.create(date: getDateOfWeekday("Tuesday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon3, user: abe!);
        let eggsAndBacon4 = ScheduledMealService.create(date: getDateOfWeekday("Wednesday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon4, user: abe!);
        let eggsAndBacon5 = ScheduledMealService.create(date: getDateOfWeekday("Thursday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon5, user: abe!);
        let eggsAndBacon6 = ScheduledMealService.create(date: getDateOfWeekday("Friday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon6, user: abe!);
        let eggsAndBacon7 = ScheduledMealService.create(date: getDateOfWeekday("Saturday")!, meal: "Breakfast", family: family, recipe: eggsAndBacon!, in: mainContext)
        ScheduledMealService.addUser(scheduledMeal: eggsAndBacon7, user: abe!);
    }
    
    func createGroceryEntities(family: Family) {
        print ("  -> Creating groceries...")
        
        // Get necessary recipes
        let crockpotChicken = RecipeService.getByName(name: "Crockpot Chicken", in: mainContext)
        let grilledChicken = RecipeService.getByName(name: "Grilled Chicken", in: mainContext)
        let redBaronPizza = RecipeService.getByName(name: "Red Baron Pizza", in: mainContext)
        let chickenAlfredo = RecipeService.getByName(name: "Chicken Alfredo", in: mainContext)
        let proteinShake = RecipeService.getByName(name: "Protein Shake", in: mainContext)
        let eggsAndBacon = RecipeService.getByName(name: "Eggs and Bacon", in: mainContext)
        
        // Create groceries
        _ = GroceryService.create(name: "Chicken breasts", family: family, recipes: [crockpotChicken!, grilledChicken!, chickenAlfredo!], in: mainContext)
        _ = GroceryService.create(name: "Salsa", family: family, recipes: [crockpotChicken!], in: mainContext)
        _ = GroceryService.create(name: "Red bell pepper", family: family, recipes: [crockpotChicken!], in: mainContext)
        _ = GroceryService.create(name: "Milk", family: family, recipes: [grilledChicken!], in: mainContext)
        _ = GroceryService.create(name: "Butter", family: family, recipes: [grilledChicken!], in: mainContext)
        _ = GroceryService.create(name: "Salt", family: family, recipes: [chickenAlfredo!], in: mainContext)
        _ = GroceryService.create(name: "Pepper", family: family, recipes: [chickenAlfredo!], in: mainContext)
        _ = GroceryService.create(name: "Cheeze-Its", family: family, recipes: [], in: mainContext)
        _ = GroceryService.create(name: "Candy", family: family, recipes: [], in: mainContext)
        _ = GroceryService.create(name: "Protein powder", family: family, recipes: [proteinShake!], in: mainContext)
        _ = GroceryService.create(name: "Yogurt", family: family, recipes: [proteinShake!], in: mainContext)
        _ = GroceryService.create(name: "Bacon", family: family, recipes: [eggsAndBacon!], in: mainContext)
        _ = GroceryService.create(name: "Lime chips", family: family, recipes: [crockpotChicken!], in: mainContext)
        _ = GroceryService.create(name: "Mesquite seasoning", family: family, recipes: [grilledChicken!], in: mainContext)
        _ = GroceryService.create(name: "Instant mashed potatoes", family: family, recipes: [grilledChicken!], in: mainContext)
        _ = GroceryService.create(name: "Red Baron pizza", family: family, recipes: [redBaronPizza!], in: mainContext)
        _ = GroceryService.create(name: "Mini penne", family: family, recipes: [chickenAlfredo!], in: mainContext)
        _ = GroceryService.create(name: "2 Jars Alfredo sauce", family: family, recipes: [chickenAlfredo!], in: mainContext)
        _ = GroceryService.create(name: "Diapers", family: family, recipes: [], in: mainContext)
        _ = GroceryService.create(name: "Frozen strawberries", family: family, recipes: [proteinShake!], in: mainContext)
        _ = GroceryService.create(name: "Eggs", family: family, recipes: [eggsAndBacon!], in: mainContext)
    }
}
