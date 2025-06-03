import UIKit

class RecipeTableViewCell: UITableViewCell {
    // Create the container for the image
    let imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()

    // Create the label for the recip name
    let recipeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold) // Set font size and weight
        label.textColor = .black // Set text color
        label.numberOfLines = 1 // Allow for 1 line
        label.text = "Test"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imageContainer)
        contentView.addSubview(recipeName)

        NSLayoutConstraint.activate([
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageContainer.widthAnchor.constraint(equalToConstant: 66), 
            imageContainer.heightAnchor.constraint(equalToConstant: 66),

            recipeName.leadingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: 15),
            recipeName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) 
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}