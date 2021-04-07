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
    var retrievedMeals: [Meal] = []
    
    // MARK: - TableView Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveMeals()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meals"
        navigationItem.searchController = searchController
        
        // Ensure search is always visible
        navigationItem.hidesSearchBarWhenScrolling = false
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
            
            cell.labelMatchingMealTitle?.text = meal.name
            cell.labelMatchingMealDescription?.text = meal.instructions
            
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
    
    // MARK: - Class Methods
    
    func retrieveMeals() {
        // Testing
        let meal1 = Meal(name: "beans", instructions: "pat the bean")
        let meal2 = Meal(name: "Curry", instructions: "You can make curry with meat, seafood, legumes or vegetables. While curry recipes can vary drastically, most are simmered in a heavily spiced sauce and served with a side of rice. Curries are wonderfully adaptable, and once you have your base sauce you can easily cater the dish to your tastes.The real secret to curry success is using fresh spices. Please throw away that jar of curry powder you’ve had in the spice cabinet for ages! (Yes, spices do expire.) If it’s older than two years, it’s probably lost its luster.")
        
        self.retrievedMeals.append(meal1)
        self.retrievedMeals.append(meal2)
        // End testing
    }
}

// MARK: - Protocol Extensions

extension SearchMealsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Called every time a change is detected in the search bar
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        // If user has searched anything
        if searchText.count > 0 {
            self.shownMeals = self.retrievedMeals.filter(
                {
                    (meal: Meal) -> Bool in return (meal.name?.lowercased().contains(searchText) ?? false)
                }
            )
        }
        else {
            shownMeals.removeAll()
        }
        
        tableView.reloadData()
    }
}
