import Foundation

public final class RecipeAlertData: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool { true }

    let alertID: UUID
    var title: String
    var message: String
    var hoursBeforeStart: Double
    var isEnabled: Bool

    init(alertID: UUID, title: String, message: String, hoursBeforeStart: Double, isEnabled: Bool) {
        self.alertID = alertID
        self.title = title
        self.message = message
        self.hoursBeforeStart = hoursBeforeStart
        self.isEnabled = isEnabled
    }

    required convenience public init?(coder: NSCoder) {
        guard let alertID = coder.decodeObject(of: NSUUID.self, forKey: "alertID") as UUID?,
              let title = coder.decodeObject(of: NSString.self, forKey: "title") as String?,
              let message = coder.decodeObject(of: NSString.self, forKey: "message") as String?
        else {
            return nil
        }

        let hoursBeforeStart = coder.decodeDouble(forKey: "hoursBeforeStart")
        let isEnabled = coder.decodeBool(forKey: "isEnabled")

        self.init(alertID: alertID, title: title, message: message, hoursBeforeStart: hoursBeforeStart, isEnabled: isEnabled)
    }

    public func encode(with coder: NSCoder) {
        coder.encode(alertID, forKey: "alertID")
        coder.encode(title, forKey: "title")
        coder.encode(message, forKey: "message")
        coder.encode(hoursBeforeStart, forKey: "hoursBeforeStart")
        coder.encode(isEnabled, forKey: "isEnabled")
    }
}
