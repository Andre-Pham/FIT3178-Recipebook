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
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    /// Calls before the view appears on screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Adds the class to the database listeners
        // (to recieve updates from the database)
        databaseController?.addListener(listener: self)
        
        if self.ingredients.count == 0 {
            self.requestIngredientsWebData()
        }
        
        // Testing
        // Ensures that ingredients are only ever loaded once to Core Data
        /*
        if self.ingredients.count == 0 {
            let _ = databaseController?.addIngredient(name: "ingredient1", ingredientDescription: "tasty")
            let _ = databaseController?.addIngredient(name: "ingredient2", ingredientDescription: "yuck")
        }
        */
        // End testing
    }
    
    func requestIngredientsWebData() {
        guard let requestURL = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list") else {
            print("Invalid URL.")
            return
        }
        
        // Parse data
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            
            // Occurs on a new thread
            
            // If we have recieved an error message
            if let error = error {
                print(error)
                return
            }
            
            // Parse data
            do {
                let decoder = JSONDecoder()
                let ingredientRootWebData = try decoder.decode(IngredientRootWebData.self, from: data!)
                
                if let ingredients = ingredientRootWebData.ingredients {
                    //self.ingredientsWebData.append(contentsOf: ingredients)
                    
                    for ingredientWebData in ingredients {
                        let name = ingredientWebData.ingredientName ?? ""
                        let description = ingredientWebData.ingredientDescription ?? ""
                        let _ = self.databaseController?.addIngredient(name: name, ingredientDescription: description)
                    }
                }
            }
            catch let err {
                print(err)
            }
        }
        
        task.resume()
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
        // SECTION_INGREDIENTS
        return self.ingredients.count
    }
    
    /// Creates the cells and contents of the TableView
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
    
    /// Returns whether a given section can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /// If an ingredient accessory button is tapped, transfers the ingredient to the ViewController and then nagivates the user to that ViewController
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // https://stackoverflow.com/questions/30773529/open-new-view-controller-by-clicking-cell-in-table-view-swift-ios
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "ingredientDescription") as! IngredientDescriptionViewController
        
        destination.ingredient = self.ingredients[indexPath.row]
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    /// When the user selects an ingredient cell, prompt a measurement entry
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ingredientName = ingredients[indexPath.row].name {
            self.displayAddMeasurementPopup(ingredientName: ingredientName)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Popup that prompts the user for a measurement popup, if a valid entry is input, updates meal ingredients via delegate and returns user back to previous ViewController
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
                    
                    let newIngredient = IngredientMeasurementData(name: ingredientName, quantity: trimmedTextInput)
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
