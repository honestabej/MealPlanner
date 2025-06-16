import UIKit

public enum CheckedState {
    case unchecked
    case checked
}

class MealTableViewCell: UITableViewCell {
    
    // Create a label to display the meal name
    let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold) // Set font size and weight
        label.textColor = .black // Set text color
        label.numberOfLines = 1 // Allow for 1 line
        return label
    }()

    // Create a label to display the schedule
    let scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14) // Set font size
        label.textColor = .lightGray // Set text color
        label.numberOfLines = 1 // Allow for 1 line
        label.text = "Test"
        return label
    }()
    
    // Create a container for the meal name and schedule labels
    let mealInfoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Create a container for the checkbox
    let checkBoxContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10 // Set the border radius
        view.layer.masksToBounds = true // Ensure the corners are clipped
        view.layer.borderColor = UIColor.appYellow.cgColor // Set the border color to appYellow
        view.layer.borderWidth = 2 // Set the border width
        return view
    }()

    // Handle the state of the checkbox
    var checkedState: CheckedState = .unchecked 

    // Create the checkbox button
    let checkBoxButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear // Make the button background clear
        return button
    }()

    // Closure to handle checkbox toggle
    var onCheckboxToggle: ((CheckedState) -> Void)?

    // Create a container for the people view
    let peopleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    // Create a container view for styling
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the container view to the cell
        contentView.addSubview(containerView)
        containerView.addSubview(checkBoxContainer)
        containerView.addSubview(mealInfoContainer) // Add the meal info container
        containerView.addSubview(peopleView)
        checkBoxContainer.addSubview(checkBoxButton)
        
        // Add the meal name and schedule labels to the meal info container
        mealInfoContainer.addSubview(mealNameLabel)
        mealInfoContainer.addSubview(scheduleLabel)

        // Add target action for the checkbox button
        checkBoxButton.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)

        NSLayoutConstraint.activate([
            // Constraints for the container view
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Set up constraints for the checkbox view
            checkBoxContainer.widthAnchor.constraint(equalToConstant: 27), // Set width
            checkBoxContainer.heightAnchor.constraint(equalToConstant: 27), // Set height
            checkBoxContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor), // Position it on the left
            checkBoxContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor), // Center vertically

            // Constraints for the checkbox button
            checkBoxButton.leadingAnchor.constraint(equalTo: checkBoxContainer.leadingAnchor),
            checkBoxButton.trailingAnchor.constraint(equalTo: checkBoxContainer.trailingAnchor),
            checkBoxButton.topAnchor.constraint(equalTo: checkBoxContainer.topAnchor),
            checkBoxButton.bottomAnchor.constraint(equalTo: checkBoxContainer.bottomAnchor),

            // Set up constraints for the meal info container
            mealInfoContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor), // Center vertically
            mealInfoContainer.leadingAnchor.constraint(equalTo: checkBoxContainer.trailingAnchor, constant: 10), // Position it to the right of the checkbox
            mealInfoContainer.trailingAnchor.constraint(equalTo: peopleView.leadingAnchor, constant: -10), // Position it to the left of the people view

            // Set up constraints for the meal name label
            mealNameLabel.topAnchor.constraint(equalTo: mealInfoContainer.topAnchor),
            mealNameLabel.leadingAnchor.constraint(equalTo: mealInfoContainer.leadingAnchor),
            mealNameLabel.trailingAnchor.constraint(equalTo: mealInfoContainer.trailingAnchor),

            // Set up constraints for the schedule label
            scheduleLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 2), // Space between labels
            scheduleLabel.leadingAnchor.constraint(equalTo: mealInfoContainer.leadingAnchor),
            scheduleLabel.trailingAnchor.constraint(equalTo: mealInfoContainer.trailingAnchor),
            scheduleLabel.bottomAnchor.constraint(equalTo: mealInfoContainer.bottomAnchor), // Align with the bottom of the container

            // Set up constraints for people view
            peopleView.widthAnchor.constraint(equalToConstant: 50), // Set width
            peopleView.heightAnchor.constraint(equalToConstant: 50), // Set height
            peopleView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            peopleView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func toggleCheckbox() {
        // Toggle the checked state
        checkedState = (checkedState == .unchecked) ? .checked : .unchecked
        
        // Update the button appearance based on the checked state
        UIView.animate(withDuration: 0.3, animations: {
            if self.checkedState == .checked {
                self.checkBoxButton.setImage(UIImage(systemName: "checkmark")?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(weight: .bold)), for: .normal) // Set checked image
                self.checkBoxContainer.backgroundColor = .appYellow
            } else {
                self.checkBoxButton.setImage(nil, for: .normal) // Set image to nothing
                self.checkBoxContainer.backgroundColor = .clear
            }
        })
        
        // Call the closure to notify the controller
        onCheckboxToggle?(self.checkedState) // Pass the current checked state
    }
} 