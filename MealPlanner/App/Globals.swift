import Foundation
import CoreData

let globalFamily = FamilyService.getFamily(in: CoreDataStack.shared.mainContext)

func getDateOfWeekday(_ weekdayName: String) -> Date? {
    let calendar = Calendar.current
    let today = Date()

    // Convert weekday name to weekday number (1 = Sunday, 7 = Saturday)
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "EEEE"

    guard let targetWeekdayIndex = formatter.weekdaySymbols.firstIndex(where: { $0.lowercased() == weekdayName.lowercased() }) else {
        print("Invalid weekday name")
        return nil
    }
    let targetWeekday = targetWeekdayIndex + 1 // Calendar weekday is 1-based

    // Get today's weekday
    let todayWeekday = calendar.component(.weekday, from: today)
    
    // Get the starting weekday of the family (safely unwrap)
    let familyStartWeekday = globalFamily?.startDay ?? 1

    // Calculate how many days to subtract to get to the start of the week
    let distanceToWeekStart = (7 + todayWeekday - Int(familyStartWeekday)) % 7
    guard let startOfWeek = calendar.date(byAdding: .day, value: -distanceToWeekStart, to: today) else {
        return nil
    }

    // Offset from start of week to target day
    let offsetToTarget = (7 + targetWeekday - Int(familyStartWeekday)) % 7
    return calendar.date(byAdding: .day, value: offsetToTarget, to: startOfWeek)
}

func formatDateToDayMonth(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd"
    return formatter.string(from: date)
}

func getStartOfWeek(from referenceDate: Date = Date()) -> Date? {
    let calendar = Calendar.current
    let currentWeekday = calendar.component(.weekday, from: referenceDate)

    let startDayInt = Int(globalFamily?.startDay ?? 1) // Assuming startDay is Int16 (1 = Sunday, 7 = Saturday)
    guard startDayInt >= 1 && startDayInt <= 7 else {
        print("❌ Invalid family.startDay: \(globalFamily?.startDay ?? 24)")
        return nil
    }

    let distanceToStart = (7 + currentWeekday - startDayInt) % 7
    return calendar.date(byAdding: .day, value: -distanceToStart, to: referenceDate)
}

func getEndOfWeek(from referenceDate: Date = Date()) -> Date? {
    guard let startOfWeek = getStartOfWeek(from: referenceDate) else {
        return nil
    }

    return Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)
}
