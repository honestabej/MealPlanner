import UIKit

extension UIButton {
    static func create(title: String? = nil, fontSize: CGFloat = 14, fontWeight: UIFont.Weight = .regular, textColor: UIColor? = .white, image: UIImage? = nil, backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        if let title = title {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
            button.setTitleColor(textColor, for: .normal)
        }

        if let image = image {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        if let backgroundColor = backgroundColor {
            button.backgroundColor = backgroundColor
        }
        
        if let cornerRadius = cornerRadius {
            button.layer.cornerRadius = cornerRadius
            button.clipsToBounds = true
        }

        return button
    }
}
