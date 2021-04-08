//
//  EditIngredientsTableViewController.swift
//  recipebook
//
//  Created by Andre Pham on 8/4/21.
//

import UIKit

class EditIngredientsTableViewController: UITableViewController {

    // MARK: - Properties
    
    // Identifiers
    let CELL_INGREDIENT: String = "ingredientCell"
    
    // Sections
    let SECTION_INGREDIENTS: Int = 0
    
    // Delegates
    weak var editMealDelegate: EditMealDelegate?
    
    // Class properties
    var ingredients: [Ingredient] = []
    
    // MARK: - TableView Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Testing
        var ingredient1 = Ingredient(name: "ingredient1", ingredientDescription: "tasty")
        var ingredient2 = Ingredient(name: "ingredient2", ingredientDescription: "")
        var ingredient3 = Ingredient(name: "ingredient3", ingredientDescription: "gross")
        var ingredient4 = Ingredient(name: "ingredient4", ingredientDescription: "")
        self.ingredients.append(ingredient1)
        self.ingredients.append(ingredient2)
        self.ingredients.append(ingredient3)
        self.ingredients.append(ingredient4)
        // End testing
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: ingredients
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Given a section, this method returns the number of rows in the section
        return self.ingredients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath.section == SECTION_INGREDIENTS
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        let ingredient = self.ingredients[indexPath.row]
        cell.textLabel?.text = ingredient.name
        if ingredient.ingredientDescription == "" {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        // https://stackoverflow.com/questions/30773529/open-new-view-controller-by-clicking-cell-in-table-view-swift-ios
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "ingredientDescription") as! IngredientDescriptionViewController
        destination.ingredient = self.ingredients[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When the user selects a row within the Table View
        
        if let ingredientName = ingredients[indexPath.row].name {
            self.displayAddMeasurementPopup(ingredientName: ingredientName)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func displayAddMeasurementPopup(ingredientName: String){
        // Define alert
        let alertController = UIAlertController(
            title: "Add measurement",
            message: "Enter measurement for \(ingredientName)",
            preferredStyle: .alert
        )
        // Add "done" button
        alertController.addAction(
            UIAlertAction(title: "Done", style: .default) { (_) in
                if let textField = alertController.textFields?.first, let textInput = textField.text {
                    // After the user selects "done"
                    let trimmedTextInput = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Validation
                    if trimmedTextInput == "" {
                        Popup.displayPopup(title: "Empty Measurement", message: "You must enter a measurement for \(ingredientName)", viewController: self)
                        return
                    }
                    
                    let newIngredient = IngredientMeasurement(name: ingredientName, quantity: trimmedTextInput)
                    self.editMealDelegate?.updateMealIngredients(newIngredient)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        )
        // Add "cancel" button
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        )
        // Add text field
        alertController.addTextField {
            (textField) in textField.placeholder = "Measurement"
        }
        // Display popup
        self.present(alertController, animated: true, completion: nil)
    }
}
