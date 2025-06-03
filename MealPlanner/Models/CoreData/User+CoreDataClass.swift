import CoreData
import Foundation

@objc(User)
public class User: NSManagedObject {

    // Create a new User
    static func create(name: String, email: String, password: String, in context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.name = name
        user.email = email
        user.password = password
        user.uuid = UUID().uuidString
        return user
    }

    // Update a User
    static func update(user: User, name: String? = nil, email: String? = nil, password: String? = nil, in context: NSManagedObjectContext) {
        user.name = name ?? user.name
        user.email = email ?? user.email
        user.password = password ?? user.password
    }

    // Validation functions for creating and inserting
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

    // Helper methods
    // TODO: Add helper methods for User
}

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

// Core Data Properties
extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var password: String
    @NSManaged public var uuid: String
    @NSManaged public var recipes: NSSet?
    @NSManaged public var mealPlans: NSSet?
    @NSManaged public var scheduledMeals: NSSet?
}
