//
//  SearchMealsTableViewController.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class SearchMealsTableViewController: UITableViewController {

    // MARK: - Properties
    
    // Identifiers
    let CELL_MEAL_SHOWN: String = "mealShownCell"
    let CELL_NEW_MEAL: String = "newMealCell"
    
    // Sections
    let SECTION_SHOWN_MEALS: Int = 0
    let SECTION_NEW_MEAL: Int = 1
    
    // Class properties
    var shownMeals: [Meal] = []
    
    // MARK: - TableView Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: list of meals to add
        // Section 1: option to add new meal
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Given a section, this method returns the number of rows in the section
        switch section {
            case SECTION_SHOWN_MEALS:
                // Cell for each shown meal
                return shownMeals.count
            case SECTION_NEW_MEAL:
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
        // indexPath.section == SECTION_NEW_MEAL
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NEW_MEAL, for: indexPath)
            
            if shownMeals.isEmpty {
                cell.textLabel?.text = "No matches? Tap to add a new meal."
            }
            else {
                cell.textLabel?.text = "Not what you were looking for? Tap to add a new meal."
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
    
}
