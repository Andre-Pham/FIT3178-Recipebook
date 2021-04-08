//
//  IngredientDescriptionViewController.swift
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
    
    // MARK: - ViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.ingredient?.name
        self.ingredientDescriptionLabel.text = self.ingredient?.ingredientDescription
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
