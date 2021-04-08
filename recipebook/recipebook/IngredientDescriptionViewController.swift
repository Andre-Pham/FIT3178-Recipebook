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
}
