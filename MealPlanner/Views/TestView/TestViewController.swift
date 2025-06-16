import UIKit
import CoreData

class TestViewController: UIViewController {
    var testDataOutputString: String = "\n"
    let testDataOutput = UITextView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollView()
        setupButtons()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // ScrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentView constraints
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupButtons() {
        let startDayIn = UITextField()
        startDayIn.translatesAutoresizingMaskIntoConstraints = false
        startDayIn.placeholder = String(FamilyService.getFamily(in: CoreDataStack.shared.mainContext)!.startDay)
        startDayIn.borderStyle = .roundedRect
        startDayIn.backgroundColor = .systemBackground
        startDayIn.font = .systemFont(ofSize: 13)
        startDayIn.autocapitalizationType = .words
        
        // Button to return to app
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let chevronLeftImage = UIImage(systemName: "chevron.left")?.withConfiguration(config).withTintColor(.white, renderingMode: .alwaysOriginal)
        let backBtn = UIButton.create(image: chevronLeftImage, backgroundColor: .systemGray, cornerRadius: 10)
        backBtn.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        
        // Button to set the test data
        let setTestDataBtn = UIButton.create(title: "Set Test Data", fontSize: 15, fontWeight: .medium, backgroundColor: .appGreen, cornerRadius: 10)
        setTestDataBtn.addAction(UIAction {_ in
            self.testDataOutput.text = TestFunctions().setTestData()
            startDayIn.text = ""
            startDayIn.placeholder = String(FamilyService.getFamily(in: CoreDataStack.shared.mainContext)!.startDay)
        }, for: .touchUpInside)
        
        // Button to delete the test data
        let deleteTestDataBtn = UIButton.create(title: "Delete Test Data", fontSize: 15, fontWeight: .medium, backgroundColor: .appCancelRed, cornerRadius: 10)
        deleteTestDataBtn.addAction(UIAction {_ in
            self.testDataOutput.text = TestFunctions().deleteTestData()
            startDayIn.text = ""
            startDayIn.placeholder = "--"
        }, for: .touchUpInside)
        
        // Button to print the test data
        let printTestDataBtn = UIButton.create(title: "Print Test Data", fontSize: 15, fontWeight: .medium, backgroundColor: .systemBlue, cornerRadius: 10)
        printTestDataBtn.addAction(UIAction {_ in
            self.testDataOutput.text = TestFunctions().printTestData()
            print(self.testDataOutput.text!)
        }, for: .touchUpInside)
        
        // Button to set the week start day for a family
        let setStartDayBtn = UIButton.create(title: "Set", fontSize: 15, fontWeight: .medium, backgroundColor: .systemBrown, cornerRadius: 10)
        setStartDayBtn.addAction(UIAction {_ in
            let mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext
            guard let family = FamilyService.getFamily(in: mainContext) else {
                print("No family found.")
                return
            }
            family.startDay = Int16(startDayIn.text ?? "0") ?? 0
            do {
                try mainContext.save()
                startDayIn.text = ""
                startDayIn.placeholder = "\(family.startDay)"
                print("Set new family start day: \(family.startDay)")
                self.testDataOutput.text = "Set new family start day: \(family.startDay)"
            } catch{
                print("Failed to save start day: \(error)")
                self.testDataOutput.text = "Failed to save start day."
                startDayIn.text = ""
            }
        }, for: .touchUpInside)
        
        // Button to test any function
        let functionTestBtn = UIButton.create(title: "Call Function", fontSize: 15, fontWeight: .medium, backgroundColor: .systemTeal, cornerRadius: 10)
        functionTestBtn.addAction(UIAction {_ in
//            let sun = getDateOfWeekday("Sunday")
//            let mon = getDateOfWeekday("Monday")
//            let tue = getDateOfWeekday("Tuesday")
//            let wed = getDateOfWeekday("Wednesday")
//            let thu = getDateOfWeekday("Thursday")
//            let fri = getDateOfWeekday("Friday")
//            let sat = getDateOfWeekday("Saturday")
//            
//            print("Sun \(sun!)\nMon \(mon!)\nTue \(tue!)\nWed \(wed!)\nThu \(thu!)\nFri \(fri!)\nSat \(sat!)")
//            self.testDataOutput.text = "Sun \(sun!)\nMon \(mon!)\nTue \(tue!)\nWed \(wed!)\nThu \(thu!)\nFri \(fri!)\nSat \(sat!)"
            
            let start = getStartOfWeek()
            let end = getEndOfWeek()
            print("Start: \(start!)\nEnd: \(end!)")
            self.testDataOutput.text = "Start: \(start!)\nEnd: \(end!)"
        }, for: .touchUpInside)
        
        // TextView to view the data output
        testDataOutput.translatesAutoresizingMaskIntoConstraints = false
        testDataOutput.isEditable = false
        testDataOutput.isScrollEnabled = false // Important: disable scrolling so it expands
        testDataOutput.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        testDataOutput.backgroundColor = UIColor.systemGray6
        testDataOutput.textColor = UIColor.label
        testDataOutput.text = testDataOutputString
        testDataOutput.layer.cornerRadius = 8
        testDataOutput.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        // Add all views to contentView
        contentView.addSubview(backBtn)
        contentView.addSubview(setTestDataBtn)
        contentView.addSubview(deleteTestDataBtn)
        contentView.addSubview(printTestDataBtn)
        contentView.addSubview(setStartDayBtn)
        contentView.addSubview(startDayIn)
        contentView.addSubview(functionTestBtn)
        contentView.addSubview(testDataOutput)
        
        NSLayoutConstraint.activate([
            // backBtn
            backBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            backBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backBtn.heightAnchor.constraint(equalToConstant: 40),
            backBtn.widthAnchor.constraint(equalToConstant: 40),
            
            // setTestDataBtn
            setTestDataBtn.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20),
            setTestDataBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            setTestDataBtn.heightAnchor.constraint(equalToConstant: 40),
            setTestDataBtn.widthAnchor.constraint(equalToConstant: 150),
            
            // deleteTestDataBtn
            deleteTestDataBtn.topAnchor.constraint(equalTo: setTestDataBtn.bottomAnchor, constant: 10),
            deleteTestDataBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            deleteTestDataBtn.heightAnchor.constraint(equalToConstant: 40),
            deleteTestDataBtn.widthAnchor.constraint(equalToConstant: 150),
            
            // printTestDataBtn
            printTestDataBtn.topAnchor.constraint(equalTo: deleteTestDataBtn.bottomAnchor, constant: 10),
            printTestDataBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            printTestDataBtn.heightAnchor.constraint(equalToConstant: 40),
            printTestDataBtn.widthAnchor.constraint(equalToConstant: 150),
            
            // setStartDayBtn
            setStartDayBtn.topAnchor.constraint(equalTo: setTestDataBtn.topAnchor),
            setStartDayBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            setStartDayBtn.heightAnchor.constraint(equalToConstant: 40),
            setStartDayBtn.widthAnchor.constraint(equalToConstant: 60),
            
            // startDayIn
            startDayIn.topAnchor.constraint(equalTo: setTestDataBtn.topAnchor),
            startDayIn.leadingAnchor.constraint(equalTo: functionTestBtn.leadingAnchor),
            startDayIn.trailingAnchor.constraint(equalTo: setStartDayBtn.leadingAnchor, constant: -10),
            startDayIn.heightAnchor.constraint(equalToConstant: 40),
            
            // functionTestBtn
            functionTestBtn.topAnchor.constraint(equalTo: deleteTestDataBtn.bottomAnchor, constant: 10),
            functionTestBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            functionTestBtn.heightAnchor.constraint(equalToConstant: 40),
            functionTestBtn.widthAnchor.constraint(equalToConstant: 150),
            
            // testDataOutput
            testDataOutput.topAnchor.constraint(equalTo: printTestDataBtn.bottomAnchor, constant: 20),
            testDataOutput.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            testDataOutput.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            testDataOutput.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // This makes contentView size itself
        ])
    }
}

// Extension to help with text view sizing if needed
extension UITextView {
    var contentHeight: CGFloat {
        let fixedWidth = frame.size.width
        let newSize = sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height
    }
}
