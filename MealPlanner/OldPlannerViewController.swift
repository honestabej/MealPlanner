import UIKit

class OldPlannerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appGreen
    }
}

// Define ViewState enum
//private enum ViewState {
//    case weekly
//    case monthly
//}
//
//// Define WeeklyViewState enum
//private enum WeeklyViewState {
//    case list
//    case schedule
//}
//
//// Define family view state
//private enum FamilyViewState {
//    case family
//    case me
//}


//class PlannerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    // #region *** CREATE UIViews ***
//
//    // Declare view containers
//    private var listViewContainer: UIView!
//    private var scheduleViewContainer: UIView!
//    private var scheduleViewScrollContainer: UIScrollView!
//    private var viewSwapContainer: UIView!
//
//    // Create the weeklyView
//    private let weeklyView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    // Create the monthlyView
//    private let monthlyView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    // Border below the list view button
//    private let listViewButtonBorder: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    // Border below the schedule view button
//    private let scheduleViewButtonBorder: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    // #endregion *** END UIViews ***
//
//    // #region *** CREATE UIButtons ***
//
//    // Button to toggle family view on and off
//    private var familyButton = UIButton()
//
//    // Button to set/edit meals in plan
//    private let setMealPlanButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Set Meal Plan", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        button.backgroundColor = .appGreen
//        button.layer.cornerRadius = 10
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    // Button to swap to the list view
//    private let listViewButton: CustomButton = {
//        let button = CustomButton()
//        button.setTitle("List View", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .clear
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    // Button to swap to the schedule view
//    private let scheduleViewButton: CustomButton = {
//        let button = CustomButton()
//        button.setTitle("Schedule View", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .clear
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    // #endregion *** END UIButtons ***
//
//    // #region *** CREATE UILabels ***
//
//    // Create the label that displays the currently selected dates
//    private let dateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 18) // Bold font for subtitle
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    // Create the "This Week" label
//    private let weekLabel: UILabel = {
//        let label = UILabel()
//        label.text = "This Week"
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 14) // Bold font for subtitle
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    // Create the No Meals Label
//    private var noMealsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No Meals Added\nto this Week"
//        label.textColor = UIColor.lightGray
//        label.font = UIFont.systemFont(ofSize: 23)
//        label.textAlignment = .center
//        label.numberOfLines = 2 // Allow the label to take up two lines
//        label.translatesAutoresizingMaskIntoConstraints = false  
//        return label
//    }()
//    // #endregion *** END UILabels ***
//
//    // #region *** CREATE UITableViews ***
//
//    // Create the table that will be used for the list view
//    private var mealsTableView: UITableView = {
//        let table = UITableView()
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.register(MealTableViewCell.self, forCellReuseIdentifier: "MealCell")
//        table.separatorStyle = .none 
//        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
//        return table
//    }()
//    // #endregion *** END UITableViews ***
//
//    // #region *** Class Variables ***
//
//    // Variables to store the height of the button borders
//    private var listViewButtonBorderHeight: NSLayoutConstraint?
//    private var scheduleViewButtonBorderHeight: NSLayoutConstraint?
//
//    // Add property to track the setDate to display (onLoad it defaults to the user-set starting weekday of the current week)
//    private var setDate: Date = PlannerViewController.getLastBeginningWeekday()
//
//    // Variable to record states
//    private var viewState: ViewState = .weekly 
//    private var weeklyViewState: WeeklyViewState = .list  
//    private var familyViewState: FamilyViewState = .family    
//
//    // Arrays to hold ScheduledMeals
//    private var mealPlanData: [ScheduledMeal] = []
//    private var mealPlanDataForCurrentWeek: [ScheduledMeal] = []
//    // #endregion *** END Class Variables ***

    // #region *** View Setup Functions ***
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .appGreen
////
////        // Set the currently displayed week (The week of today by default)
////        updateDateLabel() 
////
////        // Populate the mealListData Array
////        // populateMealPlanListForDates()
////
////        // Display Weekly View by default
////        setupWeeklyView()
////
////        // Set data source and delegate for the table view
////        mealsTableView.dataSource = self 
////        mealsTableView.delegate = self
//    }

//    // The UI for the Weekly View
//    private func setupWeeklyView() {
//        // Clear any existing subviews
//        weeklyView.subviews.forEach { $0.removeFromSuperview() }
//        
//        // Add it to the view
//        view.addSubview(weeklyView)
//
//        /* Top Container UI */
//        // Setup top area container
//        let topContainer = UIView()
//        topContainer.isUserInteractionEnabled = true
//        topContainer.translatesAutoresizingMaskIntoConstraints = false
//        topContainer.backgroundColor = .clear
//
//        // Add it to the weeklyView
//        weeklyView.addSubview(topContainer)
//
//        // Create a container for the month button and label
//        let monthButtonContainer = UIView()
//        monthButtonContainer.translatesAutoresizingMaskIntoConstraints = false
//        monthButtonContainer.backgroundColor = .clear
//        
//        // Create the month button
//        let monthButton = UIButton()
//        monthButton.setImage(UIImage(systemName: "calendar.circle")?
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
//        monthButton.translatesAutoresizingMaskIntoConstraints = false
//        monthButton.addTarget(self, action: #selector(monthWeekButtonTapped), for: .touchUpInside)
//        
//        // Create the month label
//        let monthLabel = UILabel()
//        monthLabel.text = "Month"
//        monthLabel.textColor = .white
//        monthLabel.font = UIFont.systemFont(ofSize: 12)
//        monthLabel.textAlignment = .center
//        monthLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add button and label to container
//        monthButtonContainer.addSubview(monthButton)
//        monthButtonContainer.addSubview(monthLabel)
//        
//        // Add container to topContainer
//        topContainer.addSubview(monthButtonContainer)
//
//        // Setup the Week Navigation Conatainer
//        let weekNavContainer = UIView()
//        weekNavContainer.isUserInteractionEnabled = true
//        weekNavContainer.translatesAutoresizingMaskIntoConstraints = false
//        weekNavContainer.backgroundColor = .clear
//
//        // Add the weekNavContainer to the topContainer
//        topContainer.addSubview(weekNavContainer)
//
//        // Styling for week navigation buttons
//        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
//        
//        // Create the left arrow button
//        let leftArrowButton = UIButton(type: .system)
//        leftArrowButton.isUserInteractionEnabled = true // Explicitly enable interaction
//        let chevronLeftImage = UIImage(systemName: "chevron.left")?
//            .withConfiguration(config)
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//        leftArrowButton.setImage(chevronLeftImage, for: .normal)
//        leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
//        leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
//
//        // Create the right arrow button
//        let rightArrowButton = UIButton(type: .system)
//        rightArrowButton.isUserInteractionEnabled = true // Explicitly enable interaction
//        let chevronRightImage = UIImage(systemName: "chevron.right")?
//            .withConfiguration(config)
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//        rightArrowButton.setImage(chevronRightImage, for: .normal)
//        rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
//        rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Setup the Week Label Container
//        let weekLabelContainer = UIView()
//        weekLabelContainer.isUserInteractionEnabled = true
//        weekLabelContainer.translatesAutoresizingMaskIntoConstraints = false
//        weekLabelContainer.backgroundColor = .clear
//
//        // Add the date and week labels to the container
//        weekLabelContainer.addSubview(dateLabel)
//        weekLabelContainer.addSubview(weekLabel)
//
//        // Add the left and right arrow buttons to the container
//        weekNavContainer.addSubview(leftArrowButton)
//        weekNavContainer.addSubview(weekLabelContainer)
//        weekNavContainer.addSubview(rightArrowButton)      
//
//        // Create a container for the family button and label
//        let familyButtonContainer = UIView()
//        familyButtonContainer.translatesAutoresizingMaskIntoConstraints = false
//        familyButtonContainer.backgroundColor = .clear 
//
//        // Create the family button
//        familyButton = UIButton()
//        familyButton.setImage(UIImage(systemName: "person.3.fill")?
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
//        familyButton.translatesAutoresizingMaskIntoConstraints = false
//        familyButton.addTarget(self, action: #selector(familyButtonTapped), for: .touchUpInside)
//        
//        // Create the family label
//        let familyLabel = UILabel()
//        familyLabel.text = "Family"
//        familyLabel.textColor = .white
//        familyLabel.font = UIFont.systemFont(ofSize: 12)
//        familyLabel.textAlignment = .center
//        familyLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add button and label to container
//        familyButtonContainer.addSubview(familyButton)
//        familyButtonContainer.addSubview(familyLabel)
//        topContainer.addSubview(familyButtonContainer)
//        /* End of Top Container UI */
//        
//        /* Begin viewSwapper UI */
//        // Setup the viewSwapper container
//        viewSwapContainer = UIView() // Initialize the viewSwapContainer
//        viewSwapContainer.isUserInteractionEnabled = true
//        viewSwapContainer.translatesAutoresizingMaskIntoConstraints = false
//        viewSwapContainer.backgroundColor = .clear
//        weeklyView.addSubview(viewSwapContainer)
//
//        // Add the swap buttons to the view
//        viewSwapContainer.addSubview(listViewButton)
//        listViewButton.addSubview(listViewButtonBorder)
//        viewSwapContainer.addSubview(scheduleViewButton)
//        scheduleViewButton.addSubview(scheduleViewButtonBorder)
//
//        // Add the constraints for the bottom borders
//        listViewButtonBorderHeight = listViewButtonBorder.heightAnchor.constraint(equalToConstant: 3.0)
//        scheduleViewButtonBorderHeight = scheduleViewButtonBorder.heightAnchor.constraint(equalToConstant: 1.5)
//
//        // Add actions to the swap buttons
//        listViewButton.addTarget(self, action: #selector(listViewButtonTapped), for: .touchUpInside)
//        scheduleViewButton.addTarget(self, action: #selector(scheduleViewButtonTapped), for: .touchUpInside)
//        /* End viewSwapper UI */        
//
//        // Add subviews
//        setupListView()
//        weeklyView.addSubview(setMealPlanButton)
//        
//        // Add button action
//        setMealPlanButton.addTarget(self, action: #selector(setMealPlanTapped), for: .touchUpInside)
//
//        // Setup constraints
//        NSLayoutConstraint.activate([
//            // weeklyView contstraints, to take up whole screen
//            weeklyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),   
//            weeklyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            weeklyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            weeklyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            // Top container constraints
//            topContainer.leadingAnchor.constraint(equalTo: weeklyView.leadingAnchor),
//            topContainer.trailingAnchor.constraint(equalTo: weeklyView.trailingAnchor),
//            topContainer.topAnchor.constraint(equalTo: weeklyView.safeAreaLayoutGuide.topAnchor),
//            topContainer.heightAnchor.constraint(equalToConstant: 50),
//            
//            // Month button container constraints
//            monthButtonContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 16),
//            monthButtonContainer.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
//            monthButtonContainer.widthAnchor.constraint(equalToConstant: 44),
//            monthButtonContainer.heightAnchor.constraint(equalToConstant: 60),
//
//            // Month button constraints within container
//            monthButton.topAnchor.constraint(equalTo: monthButtonContainer.topAnchor, constant: 5),
//            monthButton.centerXAnchor.constraint(equalTo: monthButtonContainer.centerXAnchor),
//            monthButton.widthAnchor.constraint(equalToConstant: 44),
//            monthButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Month label constraints
//            monthLabel.topAnchor.constraint(equalTo: monthButton.bottomAnchor, constant: -5),
//            monthLabel.centerXAnchor.constraint(equalTo: monthButtonContainer.centerXAnchor),
//            
//            // WeekNav container constraints
//            weekNavContainer.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
//            weekNavContainer.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
//            weekNavContainer.widthAnchor.constraint(equalToConstant: 200),
//            weekNavContainer.heightAnchor.constraint(equalToConstant: 44),
//
//            // Label container positioning
//            weekLabelContainer.centerXAnchor.constraint(equalTo: weekNavContainer.centerXAnchor),
//            weekLabelContainer.centerYAnchor.constraint(equalTo: weekNavContainer.centerYAnchor),
//            weekLabelContainer.widthAnchor.constraint(equalToConstant: 120),
//            weekLabelContainer.heightAnchor.constraint(equalToConstant: 44),
//
//            // Date label positioning within label container
//            dateLabel.centerXAnchor.constraint(equalTo: weekLabelContainer.centerXAnchor),
//            dateLabel.topAnchor.constraint(equalTo: weekLabelContainer.topAnchor, constant: 4),
//
//            // Week label positioning within label container
//            weekLabel.centerXAnchor.constraint(equalTo: weekLabelContainer.centerXAnchor),
//            weekLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
//
//            // Arrow buttons positioning
//            leftArrowButton.centerYAnchor.constraint(equalTo: weekNavContainer.centerYAnchor),
//            leftArrowButton.trailingAnchor.constraint(equalTo: weekLabelContainer.leadingAnchor, constant: -8),
//            rightArrowButton.centerYAnchor.constraint(equalTo: weekNavContainer.centerYAnchor),
//            rightArrowButton.leadingAnchor.constraint(equalTo: weekLabelContainer.trailingAnchor, constant: 8),
//
//            // Family button container constraints
//            familyButtonContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -16),
//            familyButtonContainer.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
//            familyButtonContainer.widthAnchor.constraint(equalToConstant: 44),
//            familyButtonContainer.heightAnchor.constraint(equalToConstant: 60),
//
//            // Family button constraints within container
//            familyButton.topAnchor.constraint(equalTo: familyButtonContainer.topAnchor, constant: 5),
//            familyButton.centerXAnchor.constraint(equalTo: familyButtonContainer.centerXAnchor),
//            familyButton.widthAnchor.constraint(equalToConstant: 57),
//            familyButton.heightAnchor.constraint(equalToConstant: 44),
//
//            // Family label constraints
//            familyLabel.topAnchor.constraint(equalTo: familyButton.bottomAnchor, constant: -5),
//            familyLabel.centerXAnchor.constraint(equalTo: familyButtonContainer.centerXAnchor),
//
//            // View Swap Container constraints
//            viewSwapContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10),
//            viewSwapContainer.leadingAnchor.constraint(equalTo: weeklyView.leadingAnchor, constant: 16),
//            viewSwapContainer.trailingAnchor.constraint(equalTo: weeklyView.trailingAnchor, constant: -16),
//            viewSwapContainer.heightAnchor.constraint(equalToConstant: 40), 
//
//            // ListView button constraints
//            listViewButton.leadingAnchor.constraint(equalTo: viewSwapContainer.leadingAnchor),
//            listViewButton.centerYAnchor.constraint(equalTo: viewSwapContainer.centerYAnchor),
//            listViewButton.widthAnchor.constraint(equalTo: viewSwapContainer.widthAnchor, multiplier: 0.5),
//            listViewButton.heightAnchor.constraint(equalToConstant: 44),
//
//            // Default constraints for the border below the ListView button
//            listViewButtonBorder.leadingAnchor.constraint(equalTo: listViewButton.leadingAnchor, constant: 20),
//            listViewButtonBorder.trailingAnchor.constraint(equalTo: listViewButton.trailingAnchor, constant: -20),
//            listViewButtonBorder.bottomAnchor.constraint(equalTo: listViewButton.bottomAnchor),
//            listViewButtonBorderHeight!, 
//
//            // ScheduleView button constraints
//            scheduleViewButton.leadingAnchor.constraint(equalTo: listViewButton.trailingAnchor),
//            scheduleViewButton.centerYAnchor.constraint(equalTo: viewSwapContainer.centerYAnchor),
//            scheduleViewButton.widthAnchor.constraint(equalTo: viewSwapContainer.widthAnchor, multiplier: 0.5),
//            scheduleViewButton.heightAnchor.constraint(equalToConstant: 44),
//
//            // Default constraints for the border below the ScheduleView button
//            scheduleViewButtonBorder.leadingAnchor.constraint(equalTo: scheduleViewButton.leadingAnchor, constant: 20),
//            scheduleViewButtonBorder.trailingAnchor.constraint(equalTo: scheduleViewButton.trailingAnchor, constant: -20),
//            scheduleViewButtonBorder.bottomAnchor.constraint(equalTo: scheduleViewButton.bottomAnchor),
//            scheduleViewButtonBorderHeight!,
//            
//            // Set Meal Plan button constraints
//            setMealPlanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            setMealPlanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            setMealPlanButton.heightAnchor.constraint(equalToConstant: 45),
//            setMealPlanButton.widthAnchor.constraint(equalToConstant: 250)
//        ])
//
//        // Bring the set meal plan button to front
//        weeklyView.bringSubviewToFront(setMealPlanButton)
//    }
//
//    // The UI for the Monthly View
//    private func setupMonthlyView() {
//        // Clear any existing subviews
//        monthlyView.subviews.forEach { $0.removeFromSuperview() }
//        
//        // Add the monthlyView to the view
//        view.addSubview(monthlyView)
//
//        // Create a container for the week button and label
//        let weekButtonContainer = UIView()
//        weekButtonContainer.translatesAutoresizingMaskIntoConstraints = false
//        weekButtonContainer.backgroundColor = .clear
//
//        // Create the week button
//        let weekButton = UIButton()
//        weekButton.setImage(UIImage(systemName: "calendar.circle.fill")?
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
//        weekButton.translatesAutoresizingMaskIntoConstraints = false
//        weekButton.addTarget(self, action: #selector(monthWeekButtonTapped), for: .touchUpInside)
//        
//        // Create the week label
//        let weekLabel = UILabel()
//        weekLabel.text = "Week"
//        weekLabel.textColor = .white
//        weekLabel.font = UIFont.systemFont(ofSize: 10)
//        weekLabel.textAlignment = .center
//        weekLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add button and label to container
//        weekButtonContainer.addSubview(weekButton)
//        weekButtonContainer.addSubview(weekLabel)
//        
//        // Add container to monthlyView
//        monthlyView.addSubview(weekButtonContainer)
//        
//        // Setup constraints
//        NSLayoutConstraint.activate([
//            // Set up monthlyView to take up whole screen   
//            monthlyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            monthlyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            monthlyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            monthlyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            // Week button container constraints
//            weekButtonContainer.topAnchor.constraint(equalTo: monthlyView.safeAreaLayoutGuide.topAnchor),
//            weekButtonContainer.trailingAnchor.constraint(equalTo: monthlyView.trailingAnchor, constant: -16), // Changed from leadingAnchor to trailingAnchor
//            weekButtonContainer.widthAnchor.constraint(equalToConstant: 44),
//            weekButtonContainer.heightAnchor.constraint(equalToConstant: 52),
//
//            // Week button constraints within container
//            weekButton.topAnchor.constraint(equalTo: weekButtonContainer.topAnchor),
//            weekButton.centerXAnchor.constraint(equalTo: weekButtonContainer.centerXAnchor),
//            weekButton.widthAnchor.constraint(equalToConstant: 44),
//            weekButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            // Week label constraints
//            weekLabel.topAnchor.constraint(equalTo: weekButton.bottomAnchor, constant: -5),
//            weekLabel.centerXAnchor.constraint(equalTo: weekButtonContainer.centerXAnchor)
//        ])
//    }   
//
//    // The UI for the List View
//    private func setupListView() {
//        // Initialize the listViewContainer
//        listViewContainer = UIView()
//        listViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        listViewContainer.backgroundColor = .white
//        listViewContainer.layer.cornerRadius = 20 // Add rounded corners
//        listViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Round only the top corners
//
//        // Add the container to the weeklyView
//        weeklyView.addSubview(listViewContainer)
//
//        // Check if meals have been added for this week
//        refreshMealListTable()
//
//        // Make sure the set meal plan button is still visible
//        weeklyView.bringSubviewToFront(setMealPlanButton)
//
//        NSLayoutConstraint.activate([
//            // Constraints for List View container
//            listViewContainer.topAnchor.constraint(equalTo: viewSwapContainer.bottomAnchor, constant: 10),
//            listViewContainer.leadingAnchor.constraint(equalTo: weeklyView.leadingAnchor),
//            listViewContainer.trailingAnchor.constraint(equalTo: weeklyView.trailingAnchor),
//            listViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
//    }
//
//    // The UI for the Schedule View
//    private func setupScheduleView() {
//        // Initialize the scheduleViewContainer
//        scheduleViewContainer = UIView()
//        scheduleViewContainer.translatesAutoresizingMaskIntoConstraints = false
//        scheduleViewContainer.backgroundColor = .white
//        scheduleViewContainer.layer.cornerRadius = 20
//        scheduleViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        
//        // Add the container to the weeklyView
//        weeklyView.addSubview(scheduleViewContainer)
//        
//        // Create a scroll view
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.isUserInteractionEnabled = true
//        scrollView.showsVerticalScrollIndicator = true 
//        scrollView.bounces = true
//        scrollView.alwaysBounceVertical = true 
//        scheduleViewContainer.addSubview(scrollView)
//        
//        // Create a scroll view content container
//        let contentView = UIView()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
//        
//        NSLayoutConstraint.activate([
//            // Constraints for scheduleViewContainer
//            scheduleViewContainer.topAnchor.constraint(equalTo: viewSwapContainer.bottomAnchor, constant: 10),
//            scheduleViewContainer.leadingAnchor.constraint(equalTo: weeklyView.leadingAnchor),
//            scheduleViewContainer.trailingAnchor.constraint(equalTo: weeklyView.trailingAnchor),
//            scheduleViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            // Constraints for the scroll view
//            scrollView.topAnchor.constraint(equalTo: scheduleViewContainer.topAnchor, constant: 10),
//            scrollView.leadingAnchor.constraint(equalTo: scheduleViewContainer.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: scheduleViewContainer.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: scheduleViewContainer.bottomAnchor),
//            
//            // Constraints for the content view
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//        ])
//
//        let weekDaysOrder = getOrderedDays()
//
//        // Create a temporary view to hold the position of last view
//        var tempView = UIView()
//        contentView.addSubview(tempView)
//        NSLayoutConstraint.activate([
//            tempView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
//        ])
//
//        // Add days to contentView
//        for i in 0..<7 { 
//            // Define date format
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "EEE"
//
//            // Determine the current day
//            var isToday = false
//            if weekLabel.text! == "This Week" && weekDaysOrder[i] == dateFormatter.string(from: Date()) {
//                isToday = true
//            }
//
//            let dayView = createDayView(day: weekDaysOrder[i], weekDayNum: i, isToday: isToday)
//            dayView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(dayView)
//
//            // Add extra constraint to the last day to the bottom ofthe content view
//            if i < 6 {
//                NSLayoutConstraint.activate([
//                    dayView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 10),
//                    dayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//                    dayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//                    dayView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
//                ])
//                tempView = dayView
//            } else {
//                NSLayoutConstraint.activate([
//                    dayView.topAnchor.constraint(equalTo: tempView.bottomAnchor, constant: 10),
//                    dayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//                    dayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//                    dayView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
//
//                    // Constrain this last day to the bottom of the contentView to define its height, along with some extra scroll space for the meal button,
//                    // then constraint the bottom of the contentView and scrollView together so it defines the scrollable area height
//                    dayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90),
//                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
//                ])
//                tempView = dayView
//            }
//        }
//        
//        // Make sure the set meal plan button is still visible
//        weeklyView.bringSubviewToFront(setMealPlanButton)
//    }
//    // #endregion *** END View Setup Functions ***
//
//    // #region *** UITableView Setup Functions ***
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return mealPlanDataForCurrentWeek.count // Return the number of filtered meals
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTableViewCell
//        let ScheduledMeal = mealPlanDataForCurrentWeek[indexPath.row] // Use filtered data
//        
//        // Set the meal name
//        cell.mealNameLabel.text = ScheduledMeal.name
//        cell.scheduleLabel.text = ScheduledMeal.schedule.keys.joined(separator: ", ")
//        
//        // Set the checkbox state from the model
//        cell.checkedState = ScheduledMeal.isChecked ? .checked : .unchecked
//        
//        // Update the button appearance based on the checked state
//        if cell.checkedState == .checked {
//            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(weight: .bold)), for: .normal)
//            cell.checkBoxContainer.backgroundColor = .appYellow
//        } else {
//            cell.checkBoxButton.setImage(nil, for: .normal)
//            cell.checkBoxContainer.backgroundColor = .clear
//        }
//        
//        // Set the checkbox toggle closure
//        cell.onCheckboxToggle = { [weak self] checkedState in
//            guard let self = self else { return }
//            
//            // Update the model with the new checked state
//            self.mealPlanDataForCurrentWeek[indexPath.row].isChecked = (checkedState == .checked)
//
//            // Find the corresponding item in the mealPlanData array and update it's status as well
//            if let index = self.mealPlanData.firstIndex(where: { $0.name == self.mealPlanDataForCurrentWeek[indexPath.row].name && $0.schedule == self.mealPlanDataForCurrentWeek[indexPath.row].schedule }) {
//                self.mealPlanData[index].isChecked = (checkedState == .checked)
//            }
//            
//            if checkedState == .checked {
//                // Store the item to move (with its updated checked state)
//                let itemToMove = self.mealPlanDataForCurrentWeek[indexPath.row]
//                
//                // Calculate the destination index path (last position)
//                let destinationIndexPath = IndexPath(row: self.mealPlanDataForCurrentWeek.count - 1, section: indexPath.section)
//                
//                // Update data source
//                self.mealPlanDataForCurrentWeek.remove(at: indexPath.row)
//                self.mealPlanDataForCurrentWeek.append(itemToMove)
//                
//                // Perform the move with animation
//                tableView.performBatchUpdates({
//                    tableView.moveRow(at: indexPath, to: destinationIndexPath)
//                }, completion: { _ in
//                    // After the animation completes, reload the table to ensure everything is in sync
//                    tableView.reloadData()
//                })
//            } else {
//                // Find the correct index to insert the unchecked item
//                let itemToMove = self.mealPlanDataForCurrentWeek[indexPath.row]
//                self.mealPlanDataForCurrentWeek.remove(at: indexPath.row)
//                self.mealPlanDataForCurrentWeek.append(itemToMove) // Temporarily append to the end
//                
//                // Order the mealPlanData to find the correct position
//                self.orderMealPlanData()
//                
//                // Find the new index of the item
//                if let newIndex = self.mealPlanDataForCurrentWeek.firstIndex(where: { $0.name == itemToMove.name }) {
//                    // Perform the move with animation
//                    tableView.performBatchUpdates({
//                        tableView.moveRow(at: IndexPath(row: self.mealPlanDataForCurrentWeek.count - 1, section: indexPath.section), to: IndexPath(row: newIndex, section: indexPath.section))
//                    }, completion: { _ in
//                        // After the animation completes, reload the table to ensure everything is in sync
//                        tableView.reloadData()
//                    })
//                }
//            }
//        }
//        
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//    // #endregion *** END UITableView Setup Functions ***
//
//    // #region *** UIButton Press Functions ***
//    @objc private func monthWeekButtonTapped() {
//        if viewState == .weekly {
//            // Setup monthly view before animation
//            setupMonthlyView()
//            monthlyView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
//            view.addSubview(monthlyView)
//            
//            // Animate both views
//            UIView.animate(withDuration: 0.5, animations: {
//                self.weeklyView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
//                self.monthlyView.transform = .identity
//            }) { _ in
//                self.weeklyView.removeFromSuperview()
//                self.weeklyView.transform = .identity // Reset transform for next use
//                self.viewState = .monthly // Update the view state
//            }
//        } else {
//            // Setup weekly view before animation
//            setupWeeklyView()
//            weeklyView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
//            view.addSubview(weeklyView)
//            
//            // Animate both views
//            UIView.animate(withDuration: 0.5, animations: {
//                self.monthlyView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
//                self.weeklyView.transform = .identity
//            }) { _ in
//                self.monthlyView.removeFromSuperview()
//                self.monthlyView.transform = .identity // Reset transform for next use
//                self.viewState = .weekly // Update the view state
//            }
//        }
//    }
//
//    @objc private func familyButtonTapped() {
//        if familyViewState == .family {
//            familyButton.setImage(UIImage(systemName: "person.3")?
//                .withTintColor(.white, renderingMode: .alwaysOriginal)
//                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal) 
//            familyViewState = .me
//        } else {
//            familyButton.setImage(UIImage(systemName: "person.3.fill")?
//                .withTintColor(.white, renderingMode: .alwaysOriginal)
//                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal) 
//            familyViewState = .family
//        }
//
//    }
//    
//    @objc private func setMealPlanTapped() {
//        populateMealPlanListForDates()
//    }
//    
//    @objc private func leftArrowTapped() {
//        // Get the date of today of last week
//        let calendar = Calendar.current
//        setDate = calendar.date(byAdding: .day, value: -7, to: setDate)!
//
//        // Update the labels based on the new date
//        updateDateLabel()
//        updateWeekLabel()
//
//        // Update the ScheduledMeals array to hold the ScheduledMeals from the newly displayed week
//        let currentDateRange = dateLabel.text ?? ""
//        mealPlanDataForCurrentWeek = mealPlanData.filter { $0.dateRange == currentDateRange }
//
//        // Reorder the meal items for the newly displayed week
//        orderMealPlanData()
//        
//        if weeklyViewState == .list {
//            // Reload the table with the new ScheduledMeals
//            refreshMealListTable()
//        } else {
//            // Reload the scheduleView 
//            scheduleViewContainer.removeFromSuperview()
//            setupScheduleView()
//        }
//    }
//    
//    @objc private func rightArrowTapped() {
//        // Get the date of today next week
//        let calendar = Calendar.current
//        setDate = calendar.date(byAdding: .day, value: 7, to: setDate)!
//
//        // Update the labels based on the new date
//        updateDateLabel()
//        updateWeekLabel()
//
//        // Update the ScheduledMeals array to only hold the ScheduledMeals from the newly displayed week
//        let currentDateRange = dateLabel.text ?? ""
//        mealPlanDataForCurrentWeek = mealPlanData.filter { $0.dateRange == currentDateRange }
//
//        // Reorder the meal items for thenewly displayed week
//        orderMealPlanData()
//
//        if weeklyViewState == .list {
//            // Reload the table with the new ScheduledMeals
//            refreshMealListTable()
//        } else {
//            // Reload the scheduleView 
//            scheduleViewContainer.removeFromSuperview()
//            setupScheduleView()
//        }
//    }
//
//    @objc private func listViewButtonTapped() {
//        weeklyViewState = .list
//        swapListScheduleView()
//    }
//
//    @objc private func scheduleViewButtonTapped() {
//        weeklyViewState = .schedule
//        swapListScheduleView()
//    }
//    // #endregion *** END UIButton Press Functions ***
//
//    // #region *** Other Functions ***
//
//    // Get the most recently occurred starting day based on the current date
//    private static func getLastBeginningWeekday(from date: Date = Date()) -> Date {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.weekday], from: date)
//        
//        // Calculate the weekday index based on the startingWeekDay
//        let startingDayIndex = Int(startingWeekDay.rawValue)
//        let currentDayIndex = components.weekday ?? 1
//        
//        // Calculate the difference in days to get to the last occurrence of the starting day
//        let daysToSubtract = (currentDayIndex - startingDayIndex + 7) % 7
//        return calendar.date(byAdding: .day, value: -daysToSubtract, to: date) ?? date
//    }
//
//    // Function that updates the date label
//    private func updateDateLabel() {
//        // Format the date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd"
//        
//        // Get the last day by adding 6 days
//        let calendar = Calendar.current
//        let endWeek = calendar.date(byAdding: .day, value: 6, to: setDate)!
//        
//        let startWeekString = dateFormatter.string(from: setDate)
//        let endWeekString = dateFormatter.string(from: endWeek)
//        
//        dateLabel.text = "\(startWeekString) - \(endWeekString)"
//    }
//
//    // Function that updates the week label
//    private func updateWeekLabel() {
//        // Get the current date
//        let currentDate: Date = PlannerViewController.getLastBeginningWeekday()
//
//        // Determine how many weeks between the current date and the setDate
//        let calendar = Calendar.current
//        let daysBetween = calendar.dateComponents([.day], from: currentDate, to: setDate).day ?? 0
//        let weeksBetween = Int(round(Double(daysBetween) / 7.0))
//        
//        // Update the week label text based on the difference
//        switch weeksBetween {
//            case 0:
//                weekLabel.text = "This Week"
//            case 1:
//                weekLabel.text = "Next Week"
//            case -1:
//                weekLabel.text = "Last Week"
//            case ..<0:
//                weekLabel.text = "\(abs(weeksBetween)) Weeks Ago"
//            default:
//                weekLabel.text = "In \(weeksBetween) Weeks"
//        }
//    }
//
//    // Function that will get the meal plan data and populate the table
//    private func populateMealPlanListForDates() {        
//        // Handle set meal plan button action
//        mealPlanData = [
//            ScheduledMealStruct(name: "Spaghetti Bolognese", schedule: ["Mon": ["Lunch", "Dinner"], "Tue": ["Breakfast"], "Fri": ["Lunch"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Chicken Caesar Salad", schedule: ["Wed": ["Lunch"], "Sun": ["Dinner"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Crockpot Chicken", schedule: ["Unscheduled": []], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Vegetable Stir Fry", schedule: ["Thu": ["Breakfast"], "Sat": ["Lunch"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Beef Tacos", schedule: ["Unscheduled": []], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Grilled Salmon with Asparagus and more stuff", schedule: ["Mon": ["Dinner"], "Thu": ["Lunch"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Vegetable Stir Fry", schedule: ["Tue": ["Lunch", "Breakfast"], "Fri": ["Dinner"], "Sun": ["Lunch"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Beef Tacos", schedule: ["Sat": ["Lunch"]], dateRange: dateLabel.text!), 
//            ScheduledMealStruct(name: "Grilled Salmon with Asparagus and more stuff", schedule: ["Sun": ["Dinner"]], dateRange: dateLabel.text!),
//            ScheduledMealStruct(name: "Vegetable Stir Fry", schedule: ["Mon": ["Lunch"], "Sat": ["Dinner"]], dateRange: "03/02 - 03/08"),
//            ScheduledMealStruct(name: "Beef Tacos", schedule: ["Thu": ["Lunch"]], dateRange: "03/02 - 03/08"),
//            ScheduledMealStruct(name: "Grilled Salmon with Asparagus and more stuff", schedule: ["Fri": ["Dinner"]], dateRange: "03/02 - 03/08")
//        ]
//
//        // Separate out the ScheduledMeals for the current week
//        let currentDateRange = dateLabel.text ?? ""
//        mealPlanDataForCurrentWeek = mealPlanData.filter { $0.dateRange == currentDateRange }
//               
//        // Refresh the meal view to display the updated data
//        orderMealPlanData()
//        refreshMealListTable()
//    }
//
//    // Function to return an order array of the days of the week based on the user settings
//    private func getOrderedDays() -> [String] {
//        // Define default weekdays array
//        let fullWeekDaysOrder = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//        
//        // Get the index of the starting day
//        let startingIndex = startingWeekDay.rawValue - 1 // Adjust for zero-based index
//        
//        // Create the ordered weekDaysOrder based on the starting day
////        return Array(fullWeekDaysOrder[startingIndex...]) + Array(fullWeekDaysOrder[0..<startingIndex])
//        return ["Temp"]
//    }
//
//    // Function to reorganize the mealPlanData based on its schedule
//    private func orderMealPlanData() {
//        
//        // Create the ordered weekDaysOrder based on the starting day
//        let weekDaysOrder = getOrderedDays()
//        
//        // Separate checked and unchecked items
//        let checkedItems = mealPlanDataForCurrentWeek.filter { $0.isChecked }
//        let uncheckedItems = mealPlanDataForCurrentWeek.filter { !$0.isChecked }
//        
//        // Sort only the unchecked items
//        let sortedUncheckedItems = uncheckedItems.sorted { (meal1, meal2) -> Bool in
//            // Check for "Unscheduled"
//            if meal1.schedule.keys.contains("Unscheduled") { return false }
//            if meal2.schedule.keys.contains("Unscheduled") { return true }
//            
//            // Get the days from the schedule dictionary
//            let days1 = Array(meal1.schedule.keys)
//            let days2 = Array(meal2.schedule.keys)
//            
//            // Compare days one by one
//            for (day1, day2) in zip(days1, days2) {
//                guard let index1 = weekDaysOrder.firstIndex(of: day1),
//                      let index2 = weekDaysOrder.firstIndex(of: day2) else {
//                    continue
//                }
//                if index1 != index2 {
//                    return index1 < index2 // Sort by the first differing day
//                }
//            }
//            
//            // If all compared days are the same, sort by the number of scheduled meals (more meals come later)
//            return days1.count < days2.count
//        }
//        
//        // Combine the checked items with the sorted unchecked items
//        mealPlanDataForCurrentWeek = sortedUncheckedItems + checkedItems
//    }
//    
//    // Create a label or the table view for the list view depeding on if Meals have been set
//    private func refreshMealListTable() {
//        // Check if meals have been added for this week
//        if mealPlanDataForCurrentWeek.isEmpty {
//            // Remove the table view if it exists
//            if listViewContainer.subviews.contains(mealsTableView) {
//                mealsTableView.removeFromSuperview()
//            }
//            
//            // Add the label to the list view container
//            listViewContainer.addSubview(noMealsLabel)
//            
//            // Set constraints for the no meals label
//            NSLayoutConstraint.activate([
//                noMealsLabel.centerYAnchor.constraint(equalTo: listViewContainer.centerYAnchor),
//                noMealsLabel.centerXAnchor.constraint(equalTo: listViewContainer.centerXAnchor)
//            ])
//        } else {
//            // Remove the no meal label if it exists
//            if listViewContainer.subviews.contains(noMealsLabel) {
//                noMealsLabel.removeFromSuperview()
//            }
//            
//            // Add the table view to the list view container
//            listViewContainer.addSubview(mealsTableView)
//
//            // Set constraints for the list view table
//            NSLayoutConstraint.activate([
//                mealsTableView.topAnchor.constraint(equalTo: listViewContainer.topAnchor, constant: 20),
//                mealsTableView.leadingAnchor.constraint(equalTo: listViewContainer.leadingAnchor),
//                mealsTableView.trailingAnchor.constraint(equalTo: listViewContainer.trailingAnchor),
//                mealsTableView.bottomAnchor.constraint(equalTo: listViewContainer.bottomAnchor)
//            ])
//            
//            mealsTableView.reloadData() // Reload the table view to display the meals
//        }
//
//        // Make sure the set meal plan button is still visible
//        weeklyView.bringSubviewToFront(setMealPlanButton)
//    }
//
//    // Setup and swap between the list and schedule views
//    private func swapListScheduleView() {
//        // Create new constraints based on current state
//        if weeklyViewState == .list {
//            // Deactivate the current border constraints
//            self.listViewButtonBorderHeight?.isActive = false
//            self.scheduleViewButtonBorderHeight?.isActive = false
//            // Set the constraints for the swapview buttons
//            self.listViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//            self.listViewButtonBorderHeight = self.listViewButtonBorder.heightAnchor.constraint(equalToConstant: 3.0)
//            self.scheduleViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            self.scheduleViewButtonBorderHeight = self.scheduleViewButtonBorder.heightAnchor.constraint(equalToConstant: 1.5)
//            // Reactivate the border constraints
//            self.listViewButtonBorderHeight?.isActive = true
//            self.scheduleViewButtonBorderHeight?.isActive = true
//            
//            // Call setupListView to display the list view
//            self.setupListView()
//            scheduleViewContainer.removeFromSuperview()
//            weeklyView.addSubview(listViewContainer)
//        } else {     
//            // Deactivate the current border constraints
//            self.listViewButtonBorderHeight?.isActive = false
//            self.scheduleViewButtonBorderHeight?.isActive = false
//            // Set the constraints for the swapview buttons
//            self.scheduleViewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//            self.scheduleViewButtonBorderHeight = self.scheduleViewButtonBorder.heightAnchor.constraint(equalToConstant: 3.0)
//            self.listViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            self.listViewButtonBorderHeight = self.listViewButtonBorder.heightAnchor.constraint(equalToConstant: 1.5)
//            // Reactivate the border constraints
//            self.listViewButtonBorderHeight?.isActive = true
//            self.scheduleViewButtonBorderHeight?.isActive = true
//            
//            // Call setupScheduleView to display the schedule view
//            self.setupScheduleView()
//            listViewContainer.removeFromSuperview()
//            weeklyView.addSubview(scheduleViewContainer)
//        }
//
//        // Make sure the set meal plan button is still visible
//        weeklyView.bringSubviewToFront(setMealPlanButton)
//    }
//
//    private func createDayView(day: String, weekDayNum: Int, isToday: Bool) -> UIView {
//        // Container for the entire day view that will be returned
//        let dayViewContainer = UIView()
//        dayViewContainer.translatesAutoresizingMaskIntoConstraints = false
//
//        // Create a container to hold the date of the day
//        let dateContainer = UIView()
//        dateContainer.translatesAutoresizingMaskIntoConstraints = false
//        dateContainer.backgroundColor = isToday ? .appGreen : .appLightGrey
//        dateContainer.layer.cornerRadius = 21.5
//        dateContainer.layer.masksToBounds = false 
//        dateContainer.layer.shadowColor = UIColor.black.cgColor
//        dateContainer.layer.shadowOpacity = 0.2
//        dateContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
//        dateContainer.layer.shadowRadius = 4
//        dayViewContainer.addSubview(dateContainer)
//        
//        // Take the date of the first day of the week, and add weekDayNum to it to get the date of the day of this view
//        let dateNum = Calendar.current.component(.day, from: Calendar.current.date(byAdding: .day, value: weekDayNum, to: setDate) ?? Date())
//
//        // Create the label to display the date number
//        let dateNumLabel = UILabel()
//        dateNumLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateNumLabel.text = String(dateNum)
//        dateNumLabel.textColor = isToday ? .white : .appGreen
//        dateNumLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        dateContainer.addSubview(dateNumLabel)
//
//        // Create the label to display the day of the week
//        let weekDaylabel = UILabel()
//        weekDaylabel.translatesAutoresizingMaskIntoConstraints = false
//        weekDaylabel.text = day
//        weekDaylabel.textColor = isToday ? .white : .appGreen
//        weekDaylabel.font = UIFont.systemFont(ofSize: 10)
//        dateContainer.addSubview(weekDaylabel)
//
//        // Create the container to hold all of the meals
//        let mealsContainer = UIView()
//        mealsContainer.translatesAutoresizingMaskIntoConstraints = false
//        mealsContainer.backgroundColor = .appLightGrey
//        mealsContainer.layer.cornerRadius = 11
//        mealsContainer.layer.masksToBounds = false
//        mealsContainer.layer.shadowColor = UIColor.black.cgColor
//        mealsContainer.layer.shadowOpacity = 0.2
//        mealsContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
//        mealsContainer.layer.shadowRadius = 4
//        dayViewContainer.addSubview(mealsContainer)
//
//        // Create a container to hold the meal Labels
//        let mealLabelsContainer = UIStackView()
//        mealLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
//        mealLabelsContainer.axis = .horizontal
//        mealLabelsContainer.distribution = .fillEqually 
//        mealLabelsContainer.backgroundColor = .appGrey
//        mealLabelsContainer.layer.cornerRadius = 8
//        mealLabelsContainer.layoutMargins = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6) 
//        mealLabelsContainer.isLayoutMarginsRelativeArrangement = true 
//        mealsContainer.addSubview(mealLabelsContainer)
//
//        // Function to create the mealLabels
//        func createMealLabel(mealName: String) -> UILabel {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = mealName
//            label.textColor = .darkGray
//            label.font = UIFont.systemFont(ofSize: 12)
//            return label
//        }
//
//        // Create the labels for each meal
//        let breakfastLabel = createMealLabel(mealName: "Breakfast")
//        let lunchLabel = createMealLabel(mealName: "Lunch")
//        let dinnerLabel = createMealLabel(mealName: "Dinner")
//
//        // Add labels to the container
//        mealLabelsContainer.addArrangedSubview(breakfastLabel)
//        mealLabelsContainer.addArrangedSubview(lunchLabel)
//        mealLabelsContainer.addArrangedSubview(dinnerLabel)
//
//        // Function to create the meal containers
//        func createMealContainer () -> UIStackView{
//            let container = UIStackView()
//            container.translatesAutoresizingMaskIntoConstraints = false
//            container.axis = .vertical
//            container.distribution = .fill 
//            container.spacing = 2
//            return container
//        }
//
//        // Create the tbdMealContainers fo each meal of the day
//        let breakfastContainer = createMealContainer()
//        let lunchContainer = createMealContainer()
//        let dinnerContainer = createMealContainer()
//
//        // Add the tbdMealContainers to the mealContainer
//        mealsContainer.addSubview(breakfastContainer)
//        mealsContainer.addSubview(lunchContainer)
//        mealsContainer.addSubview(dinnerContainer)
//
//        // Get the meals scheduled for the current day of this week
//        let scheduledMeals = mealPlanDataForCurrentWeek.filter { $0.schedule.keys.contains(day) }
//
//        // Function to create the view for displaying a meal
//        func createMealLabelView(mealName: String) -> UIView {
//            let mealLabelViewContainer = UIView()
//            mealLabelViewContainer.translatesAutoresizingMaskIntoConstraints = false
//
//            let leftBorder = UIView()
//            leftBorder.translatesAutoresizingMaskIntoConstraints = false
//            leftBorder.backgroundColor = .appYellow
//            mealLabelViewContainer.addSubview(leftBorder)
//
//            let mealLabel = UILabel()
//            mealLabel.translatesAutoresizingMaskIntoConstraints = false
//            mealLabel.text = mealName
//            mealLabel.numberOfLines = 0 
//            mealLabel.lineBreakMode = .byWordWrapping
//            mealLabel.font = UIFont.systemFont(ofSize: 11) 
//            mealLabelViewContainer.addSubview(mealLabel)
//
//            NSLayoutConstraint.activate([
//                leftBorder.leadingAnchor.constraint(equalTo: mealLabelViewContainer.leadingAnchor),
//                leftBorder.topAnchor.constraint(equalTo: mealLabelViewContainer.topAnchor),
//                leftBorder.bottomAnchor.constraint(equalTo: mealLabelViewContainer.bottomAnchor),
//                leftBorder.widthAnchor.constraint(equalToConstant: 4),
//                
//                mealLabel.leadingAnchor.constraint(equalTo: leftBorder.trailingAnchor, constant: 3),
//                mealLabel.topAnchor.constraint(equalTo: mealLabelViewContainer.topAnchor),
//                mealLabel.bottomAnchor.constraint(equalTo: mealLabelViewContainer.bottomAnchor),
//                mealLabel.trailingAnchor.constraint(equalTo: mealLabelViewContainer.trailingAnchor, constant: -4)
//            ])
//            return mealLabelViewContainer
//        }
//
//        // Loop through all of the meals scheduled for the current day
//        for meal in scheduledMeals {
//            // Check if the meal is scheduled for the current day and store the scheduled times in mealSchedule
//            if let mealSchedule = meal.schedule[day] {
//                // For each time that this meal is scheduled for, insert it to the proper view
//                for time in mealSchedule {
//                    let mealLabelContainer = createMealLabelView(mealName: meal.name)
//
//                    if time == "Breakfast" {
//                        breakfastContainer.addArrangedSubview(mealLabelContainer)
//                    } else if time == "Lunch" {
//                        lunchContainer.addArrangedSubview(mealLabelContainer)
//                    } else if time == "Dinner" {
//                        dinnerContainer.addArrangedSubview(mealLabelContainer)
//                    }
//                }
//            }
//        }
//
//        NSLayoutConstraint.activate([
//            // NOTE: dayViewContainer constraints are set in the place that calls this function
//
//            // Constraints for the dateContainer and the labels inside of it
//            dateContainer.topAnchor.constraint(equalTo: dayViewContainer.topAnchor), 
//            dateContainer.leadingAnchor.constraint(equalTo: dayViewContainer.leadingAnchor), 
//            dateContainer.heightAnchor.constraint(equalToConstant: 43),
//            dateContainer.widthAnchor.constraint(equalToConstant: 43),
//            dateNumLabel.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 4), 
//            dateNumLabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
//            weekDaylabel.topAnchor.constraint(equalTo: dateNumLabel.bottomAnchor),
//            weekDaylabel.centerXAnchor.constraint(equalTo: dateContainer.centerXAnchor),
//
//            // Contraints for the mealsContainer
//            mealsContainer.topAnchor.constraint(equalTo: dayViewContainer.topAnchor),
//            mealsContainer.leadingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: 5),
//            mealsContainer.trailingAnchor.constraint(equalTo: dayViewContainer.trailingAnchor),
//            mealsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 80), // Same min height as dayViewContainer
//
//            // Constraints for the mealLabelsContainer and the vertically centering the labels inside
//            mealLabelsContainer.topAnchor.constraint(equalTo: mealsContainer.topAnchor, constant: 5),
//            mealLabelsContainer.leadingAnchor.constraint(equalTo: mealsContainer.leadingAnchor, constant: 5),
//            mealLabelsContainer.trailingAnchor.constraint(equalTo: mealsContainer.trailingAnchor, constant: -5),
//            mealLabelsContainer.heightAnchor.constraint(equalToConstant: 20),
//            breakfastLabel.centerYAnchor.constraint(equalTo: mealLabelsContainer.centerYAnchor),
//            lunchLabel.centerYAnchor.constraint(equalTo: mealLabelsContainer.centerYAnchor),
//            dinnerLabel.centerYAnchor.constraint(equalTo: mealLabelsContainer.centerYAnchor),
//
//            // Constraints for each of the meal containers
//            breakfastContainer.topAnchor.constraint(equalTo: mealLabelsContainer.bottomAnchor, constant: 5),
//            breakfastContainer.leadingAnchor.constraint(equalTo: breakfastLabel.leadingAnchor),
//            breakfastContainer.trailingAnchor.constraint(equalTo: breakfastLabel.trailingAnchor, constant: -2),
//            lunchContainer.topAnchor.constraint(equalTo: mealLabelsContainer.bottomAnchor, constant: 5),
//            lunchContainer.leadingAnchor.constraint(equalTo: lunchLabel.leadingAnchor),
//            lunchContainer.trailingAnchor.constraint(equalTo: lunchLabel.trailingAnchor, constant: -2),
//            dinnerContainer.topAnchor.constraint(equalTo: mealLabelsContainer.bottomAnchor, constant: 5),
//            dinnerContainer.leadingAnchor.constraint(equalTo: dinnerLabel.leadingAnchor),
//            dinnerContainer.trailingAnchor.constraint(equalTo: dinnerLabel.trailingAnchor),
//
//            // These constraints make mealsContainer adjust to fit its tallest subview
//            mealsContainer.bottomAnchor.constraint(greaterThanOrEqualTo: breakfastContainer.bottomAnchor, constant: 8),
//            mealsContainer.bottomAnchor.constraint(greaterThanOrEqualTo: lunchContainer.bottomAnchor, constant: 8),
//            mealsContainer.bottomAnchor.constraint(greaterThanOrEqualTo: dinnerContainer.bottomAnchor, constant: 8),
//            
//            // Make dayViewContainer's height match mealsContainer's height
//            dayViewContainer.bottomAnchor.constraint(equalTo: mealsContainer.bottomAnchor)
//        ])
//        
//        return dayViewContainer
//    }
//    
//    // #endregion *** END Other Functions ***
//} 
