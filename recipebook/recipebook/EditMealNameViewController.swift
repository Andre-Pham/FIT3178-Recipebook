//
//  EditMealNameViewController.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class EditMealNameViewController: UIViewController {
    
    // MARK: - Properties
    
    // Delegates
    weak var editMealDelegate: EditMealDelegate?
    
    // Class properties
    var previousMealName: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealNameTextField: UITextField!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load name from CreateMealTableViewController
        mealNameTextField.text = self.previousMealName
    }
    
    // MARK: - Actions
    
    @IBAction func saveNameButton(_ sender: Any) {
        editMealDelegate?.updateMealName(self.mealNameTextField.text ?? "")
        navigationController?.popViewController(animated: true)
        return
    }
}
