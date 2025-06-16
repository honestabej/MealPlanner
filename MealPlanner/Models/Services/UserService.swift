import CoreData
import Foundation

class UserService {
    // Create a new User with default values
    static func create(family: Family, in context: NSManagedObjectContext) -> User {
        func randomHexColor() -> String {
            let red = Int.random(in: 0...255)
            let green = Int.random(in: 0...255)
            let blue = Int.random(in: 0...255)
            return String(format: "#%02X%02X%02X", red, green, blue)
        }

        let user = User(context: context)
        user.uid = UUID()
        user.name = "New User"
        user.email = nil
        user.password = nil
        user.type = "Member"
        user.color = randomHexColor()
        user.admin = true
        user.family = family
        return user
    }
    
    // Create a managed User
    static func createManagedUser(family: Family, name: String, color: String, in context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.uid = UUID()
        user.name = name
        user.email = nil
        user.password = nil
        user.type = "Managed"
        user.color = color
        user.admin = false
        user.family = family
        return user
    }
    
    // Delete user function
    static func deleteUser(user: User, in context: NSManagedObjectContext) throws {
        context.delete(user)
        try context.save()
    }
    
    // Get functions
    static func getByName(name: String, in context: NSManagedObjectContext) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch user by name \(name): \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getByEmail(email: String, in context: NSManagedObjectContext) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch user by email \(email): \(error.localizedDescription)")
            return nil
        }
    }
}
