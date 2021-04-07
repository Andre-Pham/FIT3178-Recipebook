//
//  EditMealInstructionsViewController.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class EditMealInstructionsViewController: UIViewController {
    
    // MARK: - Properties
    
    var previousMealInstructions: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealInstructionsTextField: UITextView!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func saveInstructionsButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        return
    }
}
