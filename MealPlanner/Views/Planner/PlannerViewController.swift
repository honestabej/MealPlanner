import UIKit

class PlannerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGreen
        print("App loaded with globalFamily: \(globalFamily?.name)\n\n" ?? "No Family Found")
    }
}
