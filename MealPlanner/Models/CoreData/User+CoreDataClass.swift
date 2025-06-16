import CoreData
import Foundation

@objc(User)
public class User: NSManagedObject {
    // Relationship accessors
    var scheduledMealsArray: [ScheduledMeal] {
        let set = scheduledMeals as? Set<ScheduledMeal> ?? []
        return set.sorted { ($0.date) < ($1.date) }
    }
    
    var templateMealsArray: [TemplateMeal] {
        let set = templateMeals as? Set<TemplateMeal> ?? []
        return set.sorted { ($0.day) < ($1.day) }
    }
    
    // Data validation
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
            throw UserValidationError.emptyName
        }
        
        if let email = email {
            if !email.contains("@") || !email.contains(".") {
                throw UserValidationError.invalidEmail
            }
        }
        
        if let password = password {
            if password.count < 8 {
                throw UserValidationError.passwordTooShort
            }
        }
    }
}

enum UserValidationError: LocalizedError {
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
            return "Password must be at least 8 characters long"
        }
    }
}

// Core Data Properties
extension User {
    // Default fetch function
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    // Declare attributes
    @NSManaged public var uid: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var type: String
    @NSManaged public var color: String
    @NSManaged public var admin: Bool
    
    // Declare relationships
    @NSManaged public var family: Family
    @NSManaged public var scheduledMeals: NSSet?
    @NSManaged public var templateMeals: NSSet?
}
