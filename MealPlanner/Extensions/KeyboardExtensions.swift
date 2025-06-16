import UIKit

extension UIViewController {
    public func setupKeyboardObservers(show: Selector, hide: Selector) {
        NotificationCenter.default.addObserver(self, selector: show, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hide, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    public func setupDismissKeyboardGesture(dismiss: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: dismiss)
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}