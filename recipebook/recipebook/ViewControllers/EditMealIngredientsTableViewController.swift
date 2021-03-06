//
//  EditIngredientsTableViewController.swift
//  recipebook
//
//  Created by Andre Pham on 8/4/21.
//

import UIKit

class EditMealIngredientsTableViewController: UITableViewController {

    // MARK: - Properties
    
    // Identifiers
    let CELL_INGREDIENT: String = "ingredientCell"
    
    // Sections
    let SECTION_INGREDIENTS: Int = 0
    
    // Core Data
    var listenerType = ListenerType.ingredient
    weak var databaseController: DatabaseProtocol?
    
    // Delegates
    weak var editMealDelegate: EditMealDelegate?
    
    // Web data
    //var ingredientsWebData = [IngredientWebData]()
    
    // Other properties
    var ingredients: [Ingredient] = []
    
    // MARK: - Methods

    /// Calls on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets property databaseController to reference to the databaseController from AppDelegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    /// Calls before the view appears on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Adds the class to the database listeners
        // (to recieve updates from the database)
        databaseController?.addListener(listener: self)
    }
    
    /// Calls before the view disappears on screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Removes the class from the database listeners
        // (to not recieve updates from the database)
        databaseController?.removeListener(listener: self)
    }

    /// Returns number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: ingredients
        return 1
    }

    /// Returns number of cells in any given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // self.SECTION_INGREDIENTS
        return self.ingredients.count
    }
    
    /// Creates the cells and contents of the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath.section == self.SECTION_INGREDIENTS
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INGREDIENT, for: indexPath)
        let ingredient = self.ingredients[indexPath.row]
        
        cell.textLabel?.text = ingredient.name
        
        // Remove accessory buttons from ingredients without a description
        if ingredient.ingredientDescription == "" {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        // Add accessory buttons to ingredients with a description
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        }
        
        return cell
    }
    
    /// Returns whether a given section can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// If an ingredient accessory button is tapped, transfers the ingredient to the ViewController and then nagivates the user to that ViewController
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // SOURCE: https://stackoverflow.com/questions/30773529/open-new-view-controller-by-clicking-cell-in-table-view-swift-ios
        // AUTHOR: Eendje
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "ingredientDescription") as! IngredientDescriptionViewController
        
        // Assign properteis of destination
        destination.ingredient = self.ingredients[indexPath.row]
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    /// When the user selects an ingredient cell, prompt a measurement entry
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Selecting an ingredient cell prompts a popup input for the user. Triggered actions are handled by the popup.
        if let ingredientName = self.ingredients[indexPath.row].name {
            self.displayAddMeasurementPopup(ingredientName: ingredientName)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Popup that prompts the user for a measurement popup, if a valid entry is input, updates meal ingredients via delegate and returns user back to previous ViewController
    func displayAddMeasurementPopup(ingredientName: String){
        // SOURCE: https://medium.com/swift-india/uialertcontroller-in-swift-22f3c5b1dd68
        // AUTHOR: Balaji Malliswamy - https://medium.com/@blahji
        
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
                    
                    // Create new ingredient to update Create Meal page with
                    let newIngredient = IngredientMeasurementData(name: ingredientName, quantity: trimmedTextInput)
                    
                    // Call delegate to update Create Meal page
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

// MARK: - DatabaseListener Extension

extension EditMealIngredientsTableViewController: DatabaseListener {
    
    /// Required for protocol
    func onAnyMealChange(change: DatabaseChange, meals: [Meal]) {
        // Pass
    }
    
    /// If ingredients are added or changed in Core Data, update the TableView and ingredients property
    func onAnyIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        self.ingredients = ingredients
        tableView.reloadData()
    }
    
}
