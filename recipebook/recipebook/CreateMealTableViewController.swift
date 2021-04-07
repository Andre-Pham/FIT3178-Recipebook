//
//  CreateMealTableViewController.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class CreateMealTableViewController: UITableViewController {

    // MARK: - Properties
    
    // Identifiers
    let CELL_MEAL_NAME: String = "mealNameCell"
    let CELL_MEAL_INSTRUCTIONS: String = "mealInstructionsCell"
    let CELL_MEAL_INGREDIENT: String = "mealIngredientCell"
    let CELL_ADD_INGREDIENT: String = "addIngredientCell"
    
    // Sections
    let SECTION_MEAL_NAME: Int = 0
    let SECTION_MEAL_INSTRUCTIONS: Int = 1
    let SECTION_MEAL_INGREDIENTS: Int = 2
    let SECTION_ADD_INGREDIENT: Int = 3
    
    // Class properties
    var mealName: String = ""
    var mealInstructions: String = ""
    var mealIngredients: [IngredientMeasurement] = []
    
    // MARK: - TableView Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.mealName.count != 0 {
            self.title = self.mealName
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: meal name
        // Section 1: meal instructions
        // Section 2: meal ingredients
        // Section 3: option to add ingredient
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Given a section, this method returns the number of rows in the section
        switch section {
            case SECTION_MEAL_NAME:
                return 1
            case SECTION_MEAL_INSTRUCTIONS:
                return 1
            case SECTION_MEAL_INGREDIENTS:
                // Cell for each ingredient
                if mealIngredients.count == 0 {
                    return 1
                }
                return self.mealIngredients.count
            case SECTION_ADD_INGREDIENT:
                return 1
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_MEAL_NAME {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_NAME, for: indexPath)
            
            if self.mealName.count == 0 {
                cell.textLabel?.text = "Tap to enter meal name."
                cell.textLabel?.textColor = UIColor(named: "defaultCellContent")
            }
            else {
                cell.textLabel?.text = self.mealName
            }
            
            return cell
        }
        else if indexPath.section == SECTION_MEAL_INSTRUCTIONS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_INSTRUCTIONS, for: indexPath)
            
            if self.mealInstructions.count == 0 {
                cell.textLabel?.text = "Tap to enter meal instructions."
                cell.textLabel?.textColor = UIColor(named: "defaultCellContent")
            }
            else {
                cell.textLabel?.text = self.mealInstructions
            }
            
            return cell
        }
        else if indexPath.section == SECTION_MEAL_INGREDIENTS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_INGREDIENT, for: indexPath)
            
            if self.mealIngredients.count == 0 {
                cell.textLabel?.text = "No ingredients!"
                cell.textLabel?.textColor = UIColor(named: "defaultCellContent")
                cell.detailTextLabel?.text = ""
            }
            else {
                let ingredient = mealIngredients[indexPath.row]
                
                cell.textLabel?.text = ingredient.name
                cell.detailTextLabel?.text = ingredient.quantity
            }
            
            return cell
        }
        // indexPath.section == SECTION_ADD_INGREDIENT
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ADD_INGREDIENT, for: indexPath)
            
            cell.textLabel?.text = "Add Ingredient"
            cell.textLabel?.textColor = UIColor(named: "defaultCellContent")
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_MEAL_INGREDIENTS {
            return true
        }

        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_MEAL_INGREDIENTS {
            tableView.performBatchUpdates(
                {
                    // Remove meal from shownMeals
                    self.mealIngredients.remove(at: indexPath.row)
                    // Delete the Row from the Table View
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    // Update the Info Section
                    self.tableView.reloadSections([SECTION_MEAL_INGREDIENTS], with: .automatic)
                },
                completion: nil
            )
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case SECTION_MEAL_NAME:
                return "MEAL NAME"
            case SECTION_MEAL_INSTRUCTIONS:
                return "INSTRUCTIONS"
            case SECTION_MEAL_INGREDIENTS:
                return "INGREDIENTS"
            case SECTION_ADD_INGREDIENT:
                return nil
            default:
                return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMealName" {
            // Assign the destination ViewController class to a variable to pass
            // information to its properties
            let destination = segue.destination as! EditMealNameViewController
            
            // Assign the class instance that holds information to a property
            // within the destination ViewController class
            destination.previousMealName = self.mealName
        }
        else if segue.identifier == "editMealInstructions" {
            // Assign the destination ViewController class to a variable to pass
            // information to its properties
            let destination = segue.destination as! EditMealInstructionsViewController
            
            // Assign the class instance that holds information to a property
            // within the destination ViewController class
            destination.previousMealInstructions = self.mealInstructions
        }
    }
    
    // MARK: - Actions
    
    @IBAction func saveMeal(_ sender: Any) {
        // Validation
        var errorMessages = [String]()
        if self.mealName.count == 0 {
            errorMessages.append("has a name")
        }
        if self.mealInstructions.count == 0 {
            errorMessages.append("has one or more instructions")
        }
        if self.mealIngredients.count == 0 {
            errorMessages.append("has one or more ingredients")
        }
        if errorMessages.count > 0 {
            var errorMessage: String
            if errorMessages.count > 1 {
                let firstErrors = errorMessages[0...(errorMessages.count-2)].joined(separator: ", ")
                errorMessage = "Please ensure the meal \(firstErrors) and \(errorMessages[errorMessages.count-1])."
            }
            else {
                errorMessage = "Please ensure the meal \(errorMessages[0])."
            }
            Popup.displayPopup(title: "Invalid Meal", message: errorMessage, viewController: self)
        }
        
        navigationController?.popToRootViewController(animated: true)
        return
    }
}
