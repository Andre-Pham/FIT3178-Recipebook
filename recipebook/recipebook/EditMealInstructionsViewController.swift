//
//  EditMealInstructionsViewController.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class EditMealInstructionsViewController: UIViewController {
    
    // MARK: - Properties
    
    // Delegates
    weak var editMealDelegate: EditMealDelegate?
    
    // Other properties
    var previousMealInstructions: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealInstructionsTextField: UITextView!
    
    // MARK: - Methods
    
    /// Calls on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load name from CreateMealTableViewController
        mealInstructionsTextField.text = self.previousMealInstructions
        
        // Format text field
        self.mealInstructionsTextField.layer.cornerRadius = 10
        self.mealInstructionsTextField.textContainerInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)
    }
    
    // MARK: - Actions
    
    /// Saves the entered meal instructions by calling the delegate method
    @IBAction func saveBarButtonItemPressed(_ sender: Any) {
        editMealDelegate?.updateMealInstructions(self.mealInstructionsTextField.text ?? "")
        navigationController?.popViewController(animated: true)
        return
    }
    
}
