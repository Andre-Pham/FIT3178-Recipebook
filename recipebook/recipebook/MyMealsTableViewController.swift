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
    
    // Class properties
    var shownMeals: [Meal] = []
    
    // MARK: - TableView Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets property databaseController to reference to the databaseController
        // from AppDelegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Testing
        /*
        let ingredient1 = IngredientMeasurement(name: "ingedient1", quantity: "lots")
        let ingredient2 = IngredientMeasurement(name: "ingedient2", quantity: "little")
        
        let meal1 = Meal(name: "beans", instructions: "pat the bean", ingredients: [ingredient1])
        let meal2 = Meal(name: "Curry", instructions: "You can make curry with meat, seafood, legumes or vegetables. While curry recipes can vary drastically, most are simmered in a heavily spiced sauce and served with a side of rice. Curries are wonderfully adaptable, and once you have your base sauce you can easily cater the dish to your tastes.The real secret to curry success is using fresh spices. Please throw away that jar of curry powder you’ve had in the spice cabinet for ages! (Yes, spices do expire.) If it’s older than two years, it’s probably lost its luster.", ingredients: [ingredient1, ingredient2])
        
        self.shownMeals.append(meal1)
        self.shownMeals.append(meal2)
        */
        // End testing
    }
    
    // Calls before the view appears on screen
    override func viewWillAppear(_ animated: Bool) {
        // Adds the class to the database listeners
        // (to recieve updates from the database)
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    // Calls before the view disappears on screen
    override func viewWillDisappear(_ animated: Bool) {
        // Removes the class from the database listeners
        // (to not recieve updates from the database)
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: list of saved meals
        // Section 1: number of meals saved
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Given a section, this method returns the number of rows in the section
        switch section {
            case SECTION_SHOWN_MEALS:
                // Cell for each shown meal
                return shownMeals.count
            case SECTION_MEAL_COUNT:
                return 1
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_SHOWN_MEALS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_SHOWN, for: indexPath) as! MealTableViewCell
            
            let meal = shownMeals[indexPath.row]
            
            cell.labelMealTitle?.text = meal.name
            cell.labelMealDescription?.text = meal.instructions
            
            return cell
        }
        // indexPath.section == SECTION_MEAL_COUNT
        else {
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_SHOWN_MEALS {
            return true
        }

        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_SHOWN_MEALS {
            tableView.performBatchUpdates(
                {
                    // Remove meal from shownMeals
                    self.shownMeals.remove(at: indexPath.row)
                    // Delete the Row from the Table View
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    // Update the Info Section
                    self.tableView.reloadSections([SECTION_SHOWN_MEALS, SECTION_MEAL_COUNT], with: .automatic)
                },
                completion: nil
            )
        }
    }
}

extension MyMealsTableViewController: DatabaseListener {
    
    func onAnyMealChange(change: DatabaseChange, meals: [Meal]) {
        self.shownMeals = meals
        tableView.reloadData()
    }
    
    func onAnyIngredientChange(change: DatabaseChange, ingredients: [Ingredient]) {
        // pass
    }

}
