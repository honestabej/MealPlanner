import CoreData
import Foundation

class FamilyService {
    // Create a new Family entity
    static func create(in context: NSManagedObjectContext) -> Family {
        let family = Family(context: context)
        family.fid = UUID()
        family.name = nil
        family.startDay = 1
        return family
    }
    
    // Delete a Family entity
    static func delete(family: Family, in context: NSManagedObjectContext) {
        context.delete(family)
    }
    
    // Manage User relationships
    static func addUser(family: Family, user: User) {
        var currentUsers = family.users as? Set<User> ?? []
        currentUsers.insert(user)
        family.users = NSSet(set: currentUsers)
    }
    
    static func removeUser(family: Family, user: User) {
        var currentUsers = family.users as? Set<User> ?? []
        currentUsers.remove(user)
        family.users = NSSet(set: currentUsers)
    }
    
    // Get function
    static func getFamily(in context: NSManagedObjectContext) -> Family? {
        let fetchRequest: NSFetchRequest<Family> = Family.fetchRequest()
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Failed to fetch family: \(error.localizedDescription)")
            return nil
        }
    }
}
