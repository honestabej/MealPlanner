import UIKit

class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            // Customize appearance when highlighted
            if isHighlighted {
                // Change appearance (e.g., change background color)
                self.alpha = 1.0 // Keep it the same or change as needed
            } else {
                // Reset appearance
                self.alpha = 1.0 // Keep it the same or change as needed
            }
        }
    }
} 