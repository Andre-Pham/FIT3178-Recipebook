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
    
    // Other properties
    var shownMeals: [MealData] = []
    var retrievedMeals: [MealData] = []
    
    // MARK: - Methods

    /// Calls on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates search object
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meals"
        navigationItem.searchController = searchController
        
        // Ensure search is always visible
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func requestMealsWebData() {
        guard let requestURL = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=cake") else {
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
                let mealRootWebData = try decoder.decode(MealRootWebData.self, from: data!)
                
                if let meals = mealRootWebData.meals {
                    //self.ingredientsWebData.append(contentsOf: ingredients)
                    
                    for mealWebData in meals {
                        let mealName = mealWebData.mealName ?? ""
                        let mealInstructions = mealWebData.mealInstructions ?? ""
                        self.retrievedMeals.append(MealData(name: mealName, instructions: mealInstructions, ingredients: mealWebData.mealIngredients))
                        //let name = ingredientWebData.ingredientName ?? ""
                        //let description = ingredientWebData.ingredientDescription ?? ""
                        //let _ = self.databaseController?.addIngredient(name: name, ingredientDescription: description)
                    }
                }
            }
            catch let err {
                print(err)
            }
        }
        
        task.resume()
    }


    /// Returns how many sections the TableView has
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Section 0: list of meals to add
        // Section 1: option to add new meal
        return 2
    }

    /// Returns the number of rows in any given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_SHOWN_MEALS:
            // Cell for each shown meal
            return shownMeals.count
        case SECTION_NEW_MEAL:
            // Cell that when selected, creates a new blank meal
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
            
            cell.labelMatchingMealTitle?.text = meal.name
            cell.labelMatchingMealDescription?.text = meal.instructions
            
            return cell
        }
        else {
            // indexPath.section == SECTION_NEW_MEAL
            
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
    
    /// Returns whether a given section can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_SHOWN_MEALS {
            return true
        }

        return false
    }
    
    /// Transfers the name, instructions and ingredients of the selected meal to the CreateMealTableViewController when the user travels there
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMealSegue" {
            // Define meal from cell being selected
            // https://stackoverflow.com/questions/44706806/how-do-i-use-prepare-segue-with-tableview-cell
            let meal = self.shownMeals[tableView.indexPathForSelectedRow!.row]
            
            // Define the destination ViewController to assign its properties
            let destination = segue.destination as! CreateMealTableViewController
            
            // Assign properties to the destination ViewController
            destination.mealName = meal.name ?? ""
            destination.mealInstructions = meal.instructions ?? ""
            destination.mealIngredients = meal.ingredients ?? []
        }
    }
    
    /// DELETE OR USE LATER
    func retrieveMeals() {
        // Pass
    }
    
}

// MARK: - Protocol Extensions

extension SearchMealsTableViewController: UISearchResultsUpdating {
    
    /// Called every time a change is detected in the search bar, and filters the shown meals to match the search, refreshing the TableView cells
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        self.requestMealsWebData()
        
        if searchText.count > 0 {
            self.shownMeals = self.retrievedMeals.filter({
                // Return all meals that contain the search text
                (meal: MealData) -> Bool in return (meal.name?.lowercased().contains(searchText) ?? false)
            })
        }
        else {
            // No meals are shown if there is no search input
            shownMeals.removeAll()
        }
        
        tableView.reloadData()
    }
    
}
