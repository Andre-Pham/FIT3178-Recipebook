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
    
    var indicator = UIActivityIndicatorView()
    
    // Other properties
    // REMOVE RETRIEVED MEALS
    var shownMeals: [MealData] = []
    var retrievedMeals: [MealData] = []
    
    // MARK: - Methods

    /// Calls on page load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creates search object
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Meals"
        navigationItem.searchController = searchController
        
        // Ensure search is always visible
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    func requestMealsWebData(searchText: String) {
        
        // https://www.themealdb.com/api/json/v1/1/search.php?s=cake
        var requestURLComponents = URLComponents()
        requestURLComponents.scheme = "https"
        requestURLComponents.host = "www.themealdb.com"
        requestURLComponents.path = "/api/json/v1/1/search.php"
        requestURLComponents.queryItems = [
            URLQueryItem(
                name: "s",
                value: searchText
            )
        ]
        
        guard let requestURL = requestURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        /*
        guard let requestURL = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=cake") else {
            print("Invalid URL.")
            return
        }
        */
        
        // Parse data
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            
            // Occurs on a new thread
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
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
                        self.shownMeals.append(MealData(name: mealName, instructions: mealInstructions, ingredients: mealWebData.mealIngredients))
                        //print(mealName)
                        //let name = ingredientWebData.ingredientName ?? ""
                        //let description = ingredientWebData.ingredientDescription ?? ""
                        //let _ = self.databaseController?.addIngredient(name: name, ingredientDescription: description)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    if self.shownMeals.count == 0 {
                        Popup.displayPopup(title: "No Results", message: "No results matched \"\(searchText)\".", viewController: self)
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
            return self.shownMeals.count
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
            let meal = self.shownMeals[indexPath.row]
            
            cell.labelMatchingMealTitle?.text = meal.name
            cell.labelMatchingMealDescription?.text = meal.instructions
            
            return cell
        }
        else {
            // indexPath.section == SECTION_NEW_MEAL
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_NEW_MEAL, for: indexPath)
            
            cell.textLabel?.text = "Tap to create a new meal."
            
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
    
}

// MARK: - Protocol Extensions

extension SearchMealsTableViewController: UISearchBarDelegate {
    
    /*
    /// Called every time a change is detected in the search bar, and filters the shown meals to match the search, refreshing the TableView cells
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        self.shownMeals = []
        self.requestMealsWebData(searchText: searchText)
        
        if searchText.count > 0 {
            //self.shownMeals.removeAll()
        }
        else {
            // No meals are shown if there is no search input
            self.shownMeals.removeAll()
        }
        
        tableView.reloadData()
    }
     */
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            shownMeals.removeAll()
            tableView.reloadData()
            
            // Stops all existing tasks to avoid background download
            // Causes: [NSURLSession sharedSession] may not be invalidated
            URLSession.shared.invalidateAndCancel()
            
            // If there is search text, feedback is provided
            indicator.startAnimating()
            self.requestMealsWebData(searchText: searchText)
        }
    }
    
}
