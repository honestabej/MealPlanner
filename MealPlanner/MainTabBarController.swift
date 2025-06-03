import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBar()
        self.delegate = self
    }
    
    private func customizeTabBar() {
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        
        // Set colors for unselected state
        appearance.stackedLayoutAppearance.normal.iconColor = .gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        
        // Set colors for selected state
        appearance.stackedLayoutAppearance.selected.iconColor = .appGreen
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.appGreen
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    // Setup the view controllers for the tab bar
    private func setupViewControllers() {
        let plannerVC = PlannerViewController()
        plannerVC.tabBarItem = UITabBarItem(title: "Planner", image: UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate), tag: 0)
        
        let myPlansVC = MyPlansViewController()
        myPlansVC.tabBarItem = UITabBarItem(title: "My Plans", image: UIImage(systemName: "fork.knife")?.withRenderingMode(.alwaysTemplate), tag: 1)
        
        let myRecipesVC = RecipesViewController()
        myRecipesVC.tabBarItem = UITabBarItem(title: "Recipes", image: UIImage(systemName: "book")?.withRenderingMode(.alwaysTemplate), tag: 2)
        
        let shoppingVC = ShoppingViewController()
        shoppingVC.tabBarItem = UITabBarItem(title: "Shopping", image: UIImage(systemName: "cart")?.withRenderingMode(.alwaysTemplate), tag: 3)
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate), tag: 4)
        
        viewControllers = [plannerVC, myPlansVC, myRecipesVC, shoppingVC, profileVC]
    }

    // Implement delegate method to handle tab switching without animation
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView,
                            to: toView,
                            duration: 0,
                            options: [.transitionCrossDissolve],
                            completion: nil)
        }
        
        return true
    }
} 