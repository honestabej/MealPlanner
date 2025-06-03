import Foundation

// Enum to represent the days of the week
enum WeekStartDay: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

// Global variable to store the starting day of the week
var startingWeekDay: WeekStartDay = .sunday // Default to Sunday 

struct ScheduledMealStruct {
    let name: String                            
    let schedule: [String: [String]]                        
    var isChecked: Bool = false                 
    var dateRange: String
}

struct RecipeData {
    let name: String
    let image: String
    let tags: [String]
    let ingredients: [String]
    let instructions: String
}

class RecipeManager {
    static let shared = RecipeManager()
    private init() {} // Prevents creating multiple instances
    
    var recipes: [RecipeData] = []
}