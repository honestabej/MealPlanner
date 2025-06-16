import UIKit
import CoreData

class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        // Temporary button to take you to CoreData testing view
        let testBtn = UIButton.create(title: "To test view", fontSize: 11, fontWeight: .medium, backgroundColor: .systemBlue)
        testBtn.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            let testViewVC = TestViewController()
            testViewVC.modalPresentationStyle = .fullScreen
            testViewVC.modalTransitionStyle = .coverVertical
            present(testViewVC, animated: true, completion: nil)
        }, for: .touchUpInside)
        view.addSubview(testBtn)
        
        NSLayoutConstraint.activate([
            testBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            testBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
        ])
    }
}
