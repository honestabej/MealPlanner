import CoreData
import Foundation

@objc(FamilySettings)
public class FamilySettings: NSManagedObject {
    // Create a new Family Settings
    static func create(user: User, in context: NSManagedObjectContext) {
        let familySettings = FamilySettings(context: context)
        familySettings.startDay = 1 // Default to 1, which is Sunday
        familySettings.user = user
    }
}

enum FamilySettingsValidationError: LocalizedError {

}

// Core Data Properties
extension FamilySettings {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FamilySettings> {
        return NSFetchRequest<FamilySettings>(entityName: "FamilySettings")
    }
    
    @NSManaged public var startDay: Int16
    @NSManaged public var user: User
} 