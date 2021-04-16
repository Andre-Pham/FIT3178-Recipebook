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
    
    // Indicator
    var indicator = UIActivityIndicatorView()
    
    // Other properties
    var shownMeals: [MealData] = []
    var showNewMealButton = false
    
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
        self.indicator.style = UIActivityIndicatorView.Style.large
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.indicator)
        
        // Centres the loading indicator view
        NSLayoutConstraint.activate([
            self.indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    /// Retrieves information about meals from a webservice, and appends them to self.shownMeals
    func requestMealsWebData(searchText: String) {
        // https://www.themealdb.com/api/json/v1/1/search.php?s=cake
        
        // Form URL from different components
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
        
        // Ensure URL is valid
        guard let requestURL = requestURLComponents.url else {
            print("Invalid URL.")
            return
        }
        
        // Occurs on a new thread
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            
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
                
                // Add meals retrieved to self.shownMeals
                if let meals = mealRootWebData.meals {
                    for mealWebData in meals {
                        let mealName = mealWebData.mealName ?? ""
                        let mealInstructions = mealWebData.mealInstructions ?? ""
                        self.shownMeals.append(MealData(name: mealName, instructions: mealInstructions, ingredients: mealWebData.mealIngredients))
                    }
                }
                DispatchQueue.main.async {
                    // Notify user if no results were found
                    if self.shownMeals.count == 0 {
                        Popup.displayPopup(title: "No Results", message: "No results matched \"\(searchText)\".", viewController: self)
                    }
                    
                    // Show button to create new empty meal
                    self.showNewMealButton = true
                    
                    // Shows new empty meal button, and any recipes found
                    self.tableView.reloadData()
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
            // Cell only shows up after a search
            if self.showNewMealButton {
                return 1
            }
            return 0
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
        // Meals shown can be deleted
        if indexPath.section == SECTION_SHOWN_MEALS {
            return true
        }

        return false
    }
    
    /// Transfers the name, instructions and ingredients of the selected meal to the CreateMealTableViewController when the user travels there
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMealSegue" {
            // Define meal from cell being selected
            // SOURCE: https://stackoverflow.com/questions/44706806/how-do-i-use-prepare-segue-with-tableview-cell
            // AUTHOR: GetSwifty
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
    
    /// Calls when the user clicks "search" on the keyboard
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            // Clear previously searched meals
            shownMeals.removeAll()
            tableView.reloadData()
            
            // Stops all existing tasks to avoid background download
            URLSession.shared.invalidateAndCancel()
            
            // Feedback is provided, and data is requested
            indicator.startAnimating()
            self.requestMealsWebData(searchText: searchText)
        }
    }
    
}
