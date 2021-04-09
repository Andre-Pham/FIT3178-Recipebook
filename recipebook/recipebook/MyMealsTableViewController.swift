//
//  MyMealsTableViewController.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class MyMealsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    // Identifiers
    let CELL_MEAL_SHOWN: String = "mealShownCell"
    let CELL_MEAL_COUNT: String = "mealCountCell"
    
    // Sections
    let SECTION_SHOWN_MEALS: Int = 0
    let SECTION_MEAL_COUNT: Int = 1
    
    // Core Data
    var listenerType = ListenerType.meal
    weak var databaseController: DatabaseProtocol?
    
    // Other properties
    var shownMeals: [Meal] = []
    
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

    /// Returns how many sections the TableView has
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: list of saved meals
        // Section 1: number of meals saved
        return 2
    }

    /// Returns the number of rows in any given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_SHOWN_MEALS:
            // Cell for each shown meal
            return shownMeals.count
        case SECTION_MEAL_COUNT:
            // Cell that displays number of meals saved
            return 1
        default:
            return 0
        }
    }
    
    /// Creates the cells and contents of the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SHOWN_MEALS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_SHOWN, for: indexPath) as! MealTableViewCell
            let meal = shownMeals[indexPath.row]
            
            cell.labelMealTitle?.text = meal.name
            cell.labelMealDescription?.text = meal.instructions
            
            return cell
        }
        else {
            // indexPath.section == SECTION_MEAL_COUNT
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_COUNT, for: indexPath)
            
            if shownMeals.isEmpty {
                cell.textLabel?.text = "No meals saved"
            }
            else {
                var text = "\(shownMeals.count) stored meal"
                if shownMeals.count > 1 {
                    text += "s"
                }
                cell.textLabel?.text = text
            }
            
            return cell
        }
    }
    
    /// Returns whether a given section can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_SHOWN_MEALS {
            return true
        }

        return false
    }
    
    /// Allows the deletion of saved meals via swipe gesture
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SHOWN_MEALS {
            let meal = self.shownMeals[indexPath.row]
            databaseController?.deleteMeal(meal: meal)
        }
    }
    
}

// MARK: - DatabaseListener Extension

extension MyMealsTableViewController: DatabaseListener {
    
    /// Updates shown meals whenever any meal in Core Data is changed/modified
    func onAnyMealChange(change: DatabaseChange, meals: [Meal]) {
        self.shownMeals = meals
        tableView.reloadData()
    }
    
    /// Required to conform to protocol
    func onAnyIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        // Pass
    }
    
}
