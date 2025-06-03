import UIKit
import WebKit

class ShoppingViewController: UIViewController {
    
    // Declare the button as a property
    let openWebsiteButton = UIButton(type: .system)
    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shopping"
        
        // Configure the button
        openWebsiteButton.setTitle("Visit Safeway", for: .normal)
        openWebsiteButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        openWebsiteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openWebsiteButton)

        // Set up constraints
        NSLayoutConstraint.activate([
            openWebsiteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openWebsiteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        

        // Configure and add the web view
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.isHidden = true // Initially hide the web view

        // Set up web view constraints
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let bottomButton = UIButton(type: .system)
        bottomButton.setTitle("Close", for: .normal)
        bottomButton.addTarget(self, action: #selector(testRedirect), for: .touchUpInside)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomButton) // Change webView to view

        // Set up constraints for the button
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10), // Use safeAreaLayoutGuide
            bottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func openWebsite() {
        if let url = URL(string: "https://www.safeway.com") {
            let request = URLRequest(url: url)
            webView.load(request)
            webView.isHidden = false // Show the web view when loading the website
        }
    }

    @objc func testRedirect() {
        if let url = URL(string: "https://www.safeway.com/shop/search-results.html?q=Goldfish") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}