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
    
    // Class properties
    var previousMealInstructions: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealInstructionsTextField: UITextView!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load name from CreateMealTableViewController
        mealInstructionsTextField.text = self.previousMealInstructions
    }
    
    // MARK: - Actions
    
    @IBAction func saveInstructionsButton(_ sender: Any) {
        editMealDelegate?.updateMealInstructions(self.mealInstructionsTextField.text ?? "")
        navigationController?.popViewController(animated: true)
        return
    }
}
