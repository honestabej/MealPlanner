import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddRecipeDelegate {
    // Initialize class variables
    var myRecipes: [Recipe] = []
    private let addRecipeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Recipe", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .appGreen
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }() 
    private var recipesTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RecipeTableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        table.separatorStyle = .none 
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate the recipes array for the table
        myRecipes = globalFamily?.recipesArray ?? []

        // Set up the view
        view.backgroundColor = .appGreen
        setupRecipesMainView()

        // Set table delegate and datasource
        recipesTableView.dataSource = self 
        recipesTableView.delegate = self
    }

    func setupRecipesMainView() {
        let mainLabel = UILabel()
        mainLabel.text = "Recipes"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 25)
        mainLabel.textColor = .white
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)

        let recipesListContainer = UIView()
        recipesListContainer.backgroundColor = .white
        recipesListContainer.translatesAutoresizingMaskIntoConstraints = false
        recipesListContainer.layer.cornerRadius = 20 // Add rounded corners
        recipesListContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Round only the top corners
        view.addSubview(recipesListContainer)

        recipesListContainer.addSubview(recipesTableView)
        
        view.addSubview(addRecipeButton)
        addRecipeButton.addTarget(self, action: #selector(addRecipe), for: .touchUpInside)

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            recipesListContainer.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            recipesListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recipesListContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recipesListContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            recipesTableView.leadingAnchor.constraint(equalTo: recipesListContainer.leadingAnchor),
            recipesTableView.trailingAnchor.constraint(equalTo: recipesListContainer.trailingAnchor),
            recipesTableView.topAnchor.constraint(equalTo: recipesListContainer.topAnchor, constant: 15),
            recipesTableView.bottomAnchor.constraint(equalTo: recipesListContainer.bottomAnchor),

            addRecipeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addRecipeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addRecipeButton.heightAnchor.constraint(equalToConstant: 45),
            addRecipeButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    
    // #region UITableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        let recipe = myRecipes[indexPath.row]
        cell.recipeName.text = recipe.name
        // TODO Add image
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    // #endregion

    // Transition to the AddRecipeViewController
    @IBAction private func addRecipe() {
        let addRecipeVC = AddRecipeViewController()
        addRecipeVC.delegate = self
        addRecipeVC.modalPresentationStyle = .fullScreen
        addRecipeVC.modalTransitionStyle = .coverVertical
        present(addRecipeVC, animated: true, completion: nil)
    }

    // Add the new recipe from the addRecipe view to the RecipeManager and then reload the table with new data
    func recipeAdded() {
        myRecipes = globalFamily?.recipesArray ?? []
        recipesTableView.reloadData()
    }
} 
