//
//  EditMealInstructionsViewController.swift
//  recipebook
//
//  Created by Andre Pham on 8/4/21.
//

import UIKit

class IngredientDescriptionViewController: UIViewController {
    
    // MARK: - Properties
    
    var ingredient: Ingredient?
    
    // MARK: - Outlets
    
    @IBOutlet weak var ingredientDescriptionLabel: UILabel!
    
    // MARK: - Methods

    /// Calls on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Displays to user the ingredient name and description
        self.title = self.ingredient?.name
        self.ingredientDescriptionLabel.text = self.ingredient?.ingredientDescription
    }
}
