import UIKit
import CoreData

protocol AddRecipeDelegate: AnyObject {
    func recipeAdded()
}

class AddRecipeViewController: UIViewController, UITextViewDelegate {
    // Declare class variables
    weak var delegate: AddRecipeDelegate?
    private var recipeTitleTextField: UITextField!
    private var instructionsTextView: UITextView!
    private var scrollView: UIScrollView!
    private var ingredientButtonContainerView: UIView!
    private var recipeTitleContainer: UIView!

    // Initialize class variables
    private var ingredients: [String] = []
    private var ingredientsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let addIngredientButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Ingredient", for: .normal)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the view
        setupView()

        // Call functions to handle keyboard and view interactions
        setupKeyboardObservers(show: #selector(keyboardWillShow), hide: #selector(keyboardWillHide))
        setupDismissKeyboardGesture(dismiss: #selector(dismissKeyboard))
    }

    func setupView() {
        let addRecipeContainer = UIView()
        addRecipeContainer.translatesAutoresizingMaskIntoConstraints = false
        addRecipeContainer.backgroundColor = .white
        view.addSubview(addRecipeContainer)

        // Create a container and label for the top label
        let topLabelContainer = UIView()
        topLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        addRecipeContainer.addSubview(topLabelContainer)

        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "Add Recipe"
        topLabel.font = UIFont.boldSystemFont(ofSize: 30)
        topLabel.textColor = .black
        topLabelContainer.addSubview(topLabel)

        // Configure Scroll View
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        addRecipeContainer.addSubview(scrollView)

        let scrollViewContent = UIView()
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollViewContent)

        // Create the recipe title container
        recipeTitleContainer = UIView()
        recipeTitleContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContent.addSubview(recipeTitleContainer)

        let recipeTitleLabel = UILabel()
        recipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleLabel.text = "Recipe:"
        recipeTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        recipeTitleLabel.sizeToFit()
        recipeTitleContainer.addSubview(recipeTitleLabel)

        recipeTitleTextField = UITextField()
        recipeTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        recipeTitleTextField.layer.cornerRadius = 10
        recipeTitleTextField.layer.masksToBounds = true
        recipeTitleTextField.font = UIFont.systemFont(ofSize: 16)
        recipeTitleTextField.backgroundColor = .appGrey
        recipeTitleTextField.textColor = .black
        recipeTitleTextField.attributedPlaceholder = NSAttributedString(string: "Recipe Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let titlePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: recipeTitleTextField.frame.height))
        recipeTitleTextField.leftView = titlePaddingView
        recipeTitleTextField.leftViewMode = .always
        recipeTitleContainer.addSubview(recipeTitleTextField)

        // Create the container for the image input
        let imageInContainer = UIView()
        imageInContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContent.addSubview(imageInContainer)

        let imageLabel = UILabel()
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.text = "Image:"
        imageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        imageLabel.textAlignment = .center
        imageLabel.textColor = .black
        imageInContainer.addSubview(imageLabel)

        let recipeImageContainer = UIView()
        recipeImageContainer.translatesAutoresizingMaskIntoConstraints = false
        recipeImageContainer.backgroundColor = .appGrey
        recipeImageContainer.layer.cornerRadius = 10
        imageInContainer.addSubview(recipeImageContainer)

        let recipeImageView = UIImageView()
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.contentMode = .scaleAspectFit
        recipeImageView.clipsToBounds = true
        recipeImageView.image = UIImage(systemName: "camera.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        recipeImageContainer.addSubview(recipeImageView)

        // Create the container for the ingredients
        let ingredientsLabel = UILabel()
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.text = "Ingredients:"
        ingredientsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        ingredientButtonContainerView = UIView()
        ingredientButtonContainerView.translatesAutoresizingMaskIntoConstraints = false

        scrollViewContent.addSubview(ingredientsContainer)
        ingredientsContainer.addArrangedSubview(ingredientsLabel)
        ingredientsContainer.addArrangedSubview(ingredientButtonContainerView)
        ingredientButtonContainerView.addSubview(addIngredientButton)

        // Add target action for the button
        addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)

        // Create the container for the instructions
        let instructionsContainer = UIView()
        instructionsContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContent.addSubview(instructionsContainer)

        let instructionsLabel = UILabel()
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.text = "Instructions:"
        instructionsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        instructionsLabel.textColor = .black
        instructionsContainer.addSubview(instructionsLabel)

        instructionsTextView = UITextView()
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextView.layer.cornerRadius = 10
        instructionsTextView.font = UIFont.systemFont(ofSize: 16)
        instructionsTextView.backgroundColor = .appGrey
        instructionsTextView.textColor = .black
        instructionsTextView.delegate = self 
        instructionsTextView.isScrollEnabled = false 
        instructionsTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        instructionsTextView.isEditable = true
        instructionsTextView.isSelectable = true
        instructionsTextView.textContainer.lineFragmentPadding = 0
        instructionsContainer.addSubview(instructionsTextView)

        // Create the view to hold the cancel/save buttons
        let buttonsContainer = UIView()
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.backgroundColor = .appLightGrey
        buttonsContainer.layer.shadowColor = UIColor.black.cgColor
        buttonsContainer.layer.shadowOpacity = 0.2
        buttonsContainer.layer.shadowOffset = CGSize(width: 0, height: -2) 
        buttonsContainer.layer.shadowRadius = 4
        buttonsContainer.layer.cornerRadius = 20
        buttonsContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] 
        addRecipeContainer.addSubview(buttonsContainer)

        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.alignment = .center
        buttonsContainer.addSubview(buttonsStackView)

        func createButton(color: UIColor, text: String) -> UIButton {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = color
            button.setTitle(text, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            button.layer.cornerRadius = 10 
            button.clipsToBounds = true 
            return button
        }

        let cancelButton = createButton(color: .appCancelRed, text: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelAddRecipe), for: .touchUpInside)
        let saveButton = createButton(color: .appGreen, text: "Save")
        saveButton.addTarget(self, action: #selector(saveAddRecipe), for: .touchUpInside)
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(saveButton)

        NSLayoutConstraint.activate([
            addRecipeContainer.topAnchor.constraint(equalTo: view.topAnchor),
            addRecipeContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addRecipeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addRecipeContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            topLabelContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLabelContainer.leadingAnchor.constraint(equalTo: addRecipeContainer.leadingAnchor),
            topLabelContainer.trailingAnchor.constraint(equalTo: addRecipeContainer.trailingAnchor),
            topLabelContainer.heightAnchor.constraint(equalToConstant: 50),

            topLabel.centerYAnchor.constraint(equalTo: topLabelContainer.centerYAnchor),
            topLabel.centerXAnchor.constraint(equalTo: topLabelContainer.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 11),
            scrollView.leadingAnchor.constraint(equalTo: addRecipeContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: addRecipeContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor),

            scrollViewContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 20),

            recipeTitleContainer.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: 10),
            recipeTitleContainer.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            recipeTitleContainer.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),
            recipeTitleContainer.heightAnchor.constraint(equalToConstant: 45),

            recipeTitleLabel.leadingAnchor.constraint(equalTo: recipeTitleContainer.leadingAnchor),
            recipeTitleLabel.centerYAnchor.constraint(equalTo: recipeTitleContainer.centerYAnchor),
            recipeTitleLabel.widthAnchor.constraint(equalToConstant: recipeTitleLabel.frame.width),
            recipeTitleLabel.heightAnchor.constraint(equalToConstant: recipeTitleLabel.frame.height),

            recipeTitleTextField.leadingAnchor.constraint(equalTo: recipeTitleLabel.trailingAnchor, constant: 10),
            recipeTitleTextField.topAnchor.constraint(equalTo: recipeTitleContainer.topAnchor),
            recipeTitleTextField.bottomAnchor.constraint(equalTo: recipeTitleContainer.bottomAnchor),
            recipeTitleTextField.trailingAnchor.constraint(equalTo: recipeTitleContainer.trailingAnchor),

            imageInContainer.topAnchor.constraint(equalTo: recipeTitleTextField.bottomAnchor, constant: 20),
            imageInContainer.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            imageInContainer.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),
            imageInContainer.heightAnchor.constraint(equalToConstant: 90),

            imageLabel.centerYAnchor.constraint(equalTo: imageInContainer.centerYAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: imageInContainer.leadingAnchor),

            recipeImageContainer.leadingAnchor.constraint(equalTo: recipeTitleTextField.leadingAnchor),
            recipeImageContainer.topAnchor.constraint(equalTo: imageInContainer.topAnchor),
            recipeImageContainer.bottomAnchor.constraint(equalTo: imageInContainer.bottomAnchor),
            recipeImageContainer.widthAnchor.constraint(equalTo: recipeImageContainer.heightAnchor),

            recipeImageView.centerXAnchor.constraint(equalTo: recipeImageContainer.centerXAnchor),
            recipeImageView.centerYAnchor.constraint(equalTo: recipeImageContainer.centerYAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 40),
            recipeImageView.heightAnchor.constraint(equalToConstant: 40),

            ingredientsContainer.topAnchor.constraint(equalTo: imageInContainer.bottomAnchor, constant: 10),
            ingredientsContainer.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            ingredientsContainer.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),

            ingredientsLabel.topAnchor.constraint(equalTo: ingredientsContainer.topAnchor, constant: 10),
            ingredientsLabel.leadingAnchor.constraint(equalTo: ingredientsContainer.leadingAnchor),

            ingredientButtonContainerView.topAnchor.constraint(equalTo: addIngredientButton.topAnchor),
            ingredientButtonContainerView.bottomAnchor.constraint(equalTo: addIngredientButton.bottomAnchor),
            ingredientButtonContainerView.heightAnchor.constraint(equalToConstant: 34),
            addIngredientButton.leadingAnchor.constraint(equalTo: ingredientsContainer.leadingAnchor),
            addIngredientButton.widthAnchor.constraint(equalToConstant: 150),

            instructionsContainer.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 10),
            instructionsContainer.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -10),
            instructionsContainer.topAnchor.constraint(equalTo: ingredientsContainer.bottomAnchor, constant: 10),
            instructionsContainer.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -20),

            instructionsLabel.topAnchor.constraint(equalTo: instructionsContainer.topAnchor, constant: 10),
            instructionsLabel.leadingAnchor.constraint(equalTo: instructionsContainer.leadingAnchor),

            instructionsTextView.leadingAnchor.constraint(equalTo: instructionsContainer.leadingAnchor),
            instructionsTextView.trailingAnchor.constraint(equalTo: instructionsContainer.trailingAnchor),
            instructionsTextView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10),
            instructionsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 400),
            instructionsTextView.bottomAnchor.constraint(lessThanOrEqualTo: instructionsContainer.bottomAnchor, constant: -10),
            instructionsContainer.bottomAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 10),

            buttonsContainer.bottomAnchor.constraint(equalTo: addRecipeContainer.bottomAnchor),
            buttonsContainer.leadingAnchor.constraint(equalTo: addRecipeContainer.leadingAnchor),
            buttonsContainer.trailingAnchor.constraint(equalTo: addRecipeContainer.trailingAnchor),
            buttonsContainer.heightAnchor.constraint(equalToConstant: 150),

            buttonsStackView.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 15),
            buttonsStackView.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor, constant: 25),
            buttonsStackView.trailingAnchor.constraint(equalTo: buttonsContainer.trailingAnchor, constant: -25),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 43),

            cancelButton.widthAnchor.constraint(equalTo: buttonsContainer.widthAnchor, multiplier: 0.4),
            saveButton.widthAnchor.constraint(equalTo: buttonsContainer.widthAnchor, multiplier: 0.4),
            cancelButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
            saveButton.topAnchor.constraint(equalTo: buttonsStackView.topAnchor),
            saveButton.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor),
        ])

        view.layoutIfNeeded()
    }


    // #region Methods to handle keyboard and view behavior
    deinit {
        removeKeyboardObservers()
    }

    // Handle the content inset of the scrollView when the keyboard is shown
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.scrollView.contentInset.bottom = keyboardSize.size.height - 150
    }

    // Remove the edited content inset when the keyboard disappears
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    // #endregion

    func createRecipe() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        var tempIngredients: [String] = ["Ing1", "Ing2", "Ing3"]
//
//        // Get the current user from Core Data
//        let userFetch: NSFetchRequest<User> = User.fetchRequest()
//        userFetch.fetchLimit = 1
//        guard let user = try? context.fetch(userFetch).first else {
//            print("No user found in Core Data")
//            return
//        }
//        
//        do {
////            let recipe = Recipe.create(name: "Recipe1", ingredients: tempIngredients, instructions: "instructions here", in: context, family: <#Family#>)
////            try context.save()
////            print("Recipe saved: \(recipe.name) to user: \(user.name)")
//            print("Temp")
//        } catch {
//            print("Error saving user: \(error.localizedDescription)")
//        }
    }

    // Cancel add recipe button action
    @IBAction private func cancelAddRecipe() {
        dismiss(animated: true, completion: nil)
    }

    // Save add recipe button action
    @IBAction private func saveAddRecipe() {
        // Make sure the recipe has a title
        guard let title = recipeTitleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(title: "Missing Title", message: "Please enter a recipe title.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }

        createRecipe()

        // Create a new Recipe struct and add it to the list of all recipes
//        let newRecipe = RecipeData(name: recipeTitleTextField.text ?? "", image: "", tags: [], ingredients: ingredients, instructions: instructionsTextView.text)
//        RecipeManager.shared.recipes.append(newRecipe)
        delegate?.recipeAdded()
        dismiss(animated: true, completion: nil)
    }

    // Add ingredient to recipe button action
    @IBAction private func addIngredient() {
        let ingredientView = UIView()
        ingredientView.translatesAutoresizingMaskIntoConstraints = false

        // Create a text field to enter the name of the ingredient
        let ingredientTextField = UITextField()
        ingredientTextField.translatesAutoresizingMaskIntoConstraints = false
        ingredientTextField.placeholder = "Ingredient"
        ingredientTextField.layer.cornerRadius = 10
        ingredientTextField.layer.masksToBounds = true
        ingredientTextField.font = UIFont.systemFont(ofSize: 16)
        ingredientTextField.textColor = .black
        ingredientTextField.backgroundColor = .appGrey
        let ingredientPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: ingredientTextField.frame.height))
        ingredientTextField.leftView = ingredientPadding
        ingredientTextField.leftViewMode = .always

        // Create the button and action for adding the ingredient
        let addIngredientButton = UIButton()
        addIngredientButton.translatesAutoresizingMaskIntoConstraints = false
        addIngredientButton.setImage(UIImage(systemName: "checkmark.circle.fill")? 
                .withTintColor(.appGreen, renderingMode: .alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)), for: .normal) 
        addIngredientButton.addAction(UIAction { [weak self] _ in
            if let text = ingredientTextField.text, !text.isEmpty {
                ingredientView.removeFromSuperview()
                self?.ingredientAdded(name: text)
            } else {
                ingredientView.removeFromSuperview()
                self?.ingredientsContainer.addArrangedSubview(self!.ingredientButtonContainerView)
            }
        }, for: .touchUpInside)

        // Create the button and action for cancelling adding the ingredient
        let cancelIngredientButton = UIButton()
        cancelIngredientButton.translatesAutoresizingMaskIntoConstraints = false
        cancelIngredientButton.setImage(UIImage(systemName: "x.circle.fill")?
                .withTintColor(.appCancelRed, renderingMode: .alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)), for: .normal) 
        cancelIngredientButton.addAction(UIAction { [weak self] _ in
            ingredientView.removeFromSuperview()
            self?.ingredientsContainer.addArrangedSubview(self!.ingredientButtonContainerView)
        }, for: .touchUpInside)

        // Organize views
        ingredientView.addSubview(ingredientTextField)
        ingredientView.addSubview(addIngredientButton)
        ingredientView.addSubview(cancelIngredientButton)
        ingredientButtonContainerView.removeFromSuperview()
        ingredientsContainer.addArrangedSubview(ingredientView)

        // Set constraints for the ingredient label
        NSLayoutConstraint.activate([
            ingredientView.heightAnchor.constraint(equalToConstant: 35),

            ingredientTextField.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            ingredientTextField.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            ingredientTextField.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor),
            ingredientTextField.trailingAnchor.constraint(equalTo: addIngredientButton.leadingAnchor, constant: -10),

            cancelIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            cancelIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            cancelIngredientButton.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -5),
            cancelIngredientButton.widthAnchor.constraint(equalTo: cancelIngredientButton.heightAnchor),

            addIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            addIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            addIngredientButton.trailingAnchor.constraint(equalTo: cancelIngredientButton.leadingAnchor, constant: -8),
            addIngredientButton.widthAnchor.constraint(equalTo: addIngredientButton.heightAnchor)
        ])
    }

    // Function to handle displaying/editing/removing the newly added ingredient
    private func ingredientAdded(name: String) {
        // Append the new ingredient to the class array
        ingredients.append(name)

        // Create the container view, label, edit, and remove buttons for the ingredient
        let ingredientView = UIView()
        ingredientView.translatesAutoresizingMaskIntoConstraints = false

        let ingredientLabel = UILabel()
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.text = name
        ingredientLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        ingredientLabel.textColor = .black
        let editIngredientButton = UIButton(type: .system)
        editIngredientButton.translatesAutoresizingMaskIntoConstraints = false
        editIngredientButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editIngredientButton.backgroundColor = .clear
        let removeIngredientButton = UIButton(type: .system)
        removeIngredientButton.translatesAutoresizingMaskIntoConstraints = false
        removeIngredientButton.setImage(UIImage(systemName: "trash"), for: .normal)
        removeIngredientButton.tintColor = .red
        removeIngredientButton.backgroundColor = .clear

        // Action for pressing the edit button
        editIngredientButton.addAction(UIAction { [weak self] _ in
            // Remove the label and buttons
            ingredientLabel.removeFromSuperview()
            editIngredientButton.removeFromSuperview()
            removeIngredientButton.removeFromSuperview()

            // Add the text field and buttons for editing the ingredient
            let ingredientTextField = UITextField()
            ingredientTextField.translatesAutoresizingMaskIntoConstraints = false
            ingredientTextField.placeholder = ingredientLabel.text
            ingredientTextField.layer.cornerRadius = 10
            ingredientTextField.layer.masksToBounds = true
            ingredientTextField.font = UIFont.systemFont(ofSize: 16)
            ingredientTextField.textColor = .black
            ingredientTextField.backgroundColor = .appGrey
            let ingredientPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: ingredientTextField.frame.height))
            ingredientTextField.leftView = ingredientPadding
            ingredientTextField.leftViewMode = .always

            let confirmEditButton = UIButton()
            confirmEditButton.translatesAutoresizingMaskIntoConstraints = false
            confirmEditButton.setImage(UIImage(systemName: "checkmark.circle.fill")? 
                    .withTintColor(.appGreen, renderingMode: .alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)), for: .normal) 

            let cancelEditButton = UIButton()
            cancelEditButton.translatesAutoresizingMaskIntoConstraints = false
            cancelEditButton.setImage(UIImage(systemName: "x.circle.fill")?
                    .withTintColor(.appCancelRed, renderingMode: .alwaysOriginal)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)), for: .normal) 

            ingredientView.addSubview(ingredientTextField)
            ingredientView.addSubview(confirmEditButton)
            ingredientView.addSubview(cancelEditButton)

            // Action for button to confirm ingredient edit
            confirmEditButton.addAction(UIAction { [weak self] _ in 
                // Remove the editing components
                ingredientTextField.removeFromSuperview()
                confirmEditButton.removeFromSuperview()
                cancelEditButton.removeFromSuperview()

                // Set the display label to the new value if it is not blank
                if let text = ingredientTextField.text, !text.isEmpty {
                    if let index = self?.ingredients.firstIndex(of: ingredientLabel.text ?? "") {
                        self?.ingredients[index] = ingredientTextField.text ?? ""
                    }
                    ingredientLabel.text = ingredientTextField.text
                }

                // Add the display components back 
                ingredientView.addSubview(ingredientLabel)
                ingredientView.addSubview(editIngredientButton)
                ingredientView.addSubview(removeIngredientButton)

                NSLayoutConstraint.activate([
                    ingredientLabel.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    ingredientLabel.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    ingredientLabel.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: 5),
                    ingredientLabel.trailingAnchor.constraint(equalTo: editIngredientButton.leadingAnchor, constant: -10),

                    removeIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    removeIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    removeIngredientButton.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -5),

                    editIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    editIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    editIngredientButton.trailingAnchor.constraint(equalTo: removeIngredientButton.leadingAnchor, constant: -8)
                ])

            }, for: .touchUpInside)

            // Action for button to cancel ingredient edit
            cancelEditButton.addAction(UIAction {_ in 
                // Remove the editing components
                ingredientTextField.removeFromSuperview()
                confirmEditButton.removeFromSuperview()
                cancelEditButton.removeFromSuperview()

                // Add the display components back 
                ingredientView.addSubview(ingredientLabel)
                ingredientView.addSubview(editIngredientButton)
                ingredientView.addSubview(removeIngredientButton)

                NSLayoutConstraint.activate([
                    ingredientLabel.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    ingredientLabel.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    ingredientLabel.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: 5),
                    ingredientLabel.trailingAnchor.constraint(equalTo: editIngredientButton.leadingAnchor, constant: -10),

                    removeIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    removeIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    removeIngredientButton.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -5),

                    editIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                    editIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                    editIngredientButton.trailingAnchor.constraint(equalTo: removeIngredientButton.leadingAnchor, constant: -8)
                ])

            }, for: .touchUpInside)

            NSLayoutConstraint.activate([
                ingredientTextField.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                ingredientTextField.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                ingredientTextField.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor),
                ingredientTextField.trailingAnchor.constraint(equalTo: confirmEditButton.leadingAnchor, constant: -10),

                cancelEditButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                cancelEditButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                cancelEditButton.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -5),
                cancelEditButton.widthAnchor.constraint(equalTo: cancelEditButton.heightAnchor),

                confirmEditButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
                confirmEditButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
                confirmEditButton.trailingAnchor.constraint(equalTo: cancelEditButton.leadingAnchor, constant: -8),
                confirmEditButton.widthAnchor.constraint(equalTo: confirmEditButton.heightAnchor)
            ])
        }, for: .touchUpInside)
        
        // Action for pressing the remove button
        removeIngredientButton.addAction(UIAction { [weak self] _ in
            ingredientView.removeFromSuperview()
            if let index = self?.ingredients.firstIndex(of: name) {
                self?.ingredients.remove(at: index)
            }
        }, for: .touchUpInside)

        // Organize views
        ingredientView.addSubview(ingredientLabel)
        ingredientView.addSubview(editIngredientButton)
        ingredientView.addSubview(removeIngredientButton)
        ingredientsContainer.addArrangedSubview(ingredientView)
        ingredientsContainer.addArrangedSubview(ingredientButtonContainerView)

        NSLayoutConstraint.activate([
            ingredientView.heightAnchor.constraint(equalToConstant: 35),

            ingredientLabel.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            ingredientLabel.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: ingredientView.leadingAnchor, constant: 5),
            ingredientLabel.trailingAnchor.constraint(equalTo: editIngredientButton.leadingAnchor, constant: -10),

            removeIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            removeIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            removeIngredientButton.trailingAnchor.constraint(equalTo: ingredientView.trailingAnchor, constant: -5),

            editIngredientButton.topAnchor.constraint(equalTo: ingredientView.topAnchor),
            editIngredientButton.bottomAnchor.constraint(equalTo: ingredientView.bottomAnchor),
            editIngredientButton.trailingAnchor.constraint(equalTo: removeIngredientButton.leadingAnchor, constant: -8)
        ])
    }
} 
