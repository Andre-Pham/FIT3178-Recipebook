//
//  EditMealNameViewController.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class EditMealNameViewController: UIViewController {
    
    // MARK: - Properties
    
    var previousMealName: String?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealNameTextField: UITextField!
    
    // MARK: - ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func saveNameButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        return
    }
}
