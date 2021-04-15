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
        
        // Saves ingredients from webservice to Core Data, only if there are no ingredients saved
        if let coreDataIngredientCount = databaseController?.countIngredients() {
            if coreDataIngredientCount == 0 {
                // No ingredients are locally saved, so ingredients are loaded in
                self.requestIngredientsWebData()
            }
        }
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
        case self.SECTION_SHOWN_MEALS:
            // Cell for each shown meal
            return shownMeals.count
        case self.SECTION_MEAL_COUNT:
            // Cell that displays number of meals saved
            return 1
        default:
            return 0
        }
    }
    
    /// Creates the cells and contents of the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.SECTION_SHOWN_MEALS {
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_SHOWN, for: indexPath) as! MealTableViewCell
            let meal = self.shownMeals[indexPath.row]
            
            cell.labelMealTitle?.text = meal.name
            cell.labelMealDescription?.text = meal.instructions
            
            return cell
        }
        else {
            // indexPath.section == self.SECTION_MEAL_COUNT
            
            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MEAL_COUNT, for: indexPath)
            
            if self.shownMeals.isEmpty {
                cell.textLabel?.text = "No meals saved"
            }
            else {
                var text = "\(self.shownMeals.count) stored meal"
                if self.shownMeals.count > 1 {
                    text += "s"
                }
                cell.textLabel?.text = text
            }
            
            // Add support for dynamic typing
            cell.textLabel?.font = CustomFont.setBodyFont()
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            
            return cell
        }
    }
    
    /// Returns whether a given section can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Shown meals can be deleted
        if indexPath.section == self.SECTION_SHOWN_MEALS {
            return true
        }

        return false
    }
    
    /// Allows the deletion of saved meals via swipe gesture
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == self.SECTION_SHOWN_MEALS {
            let meal = self.shownMeals[indexPath.row]
            databaseController?.deleteMeal(meal: meal)
            databaseController?.saveChanges()
        }
    }
    
    /// Retrieves ingredients from webservice and stores them into Core Data
    func requestIngredientsWebData() {
        guard let requestURL = URL(string: "https://www.themealdb.com/api/json/v1/1/list.php?i=list") else {
            print("Invalid URL.")
            return
        }
        
        // Occurs on a new thread
        let task = URLSession.shared.dataTask(with: requestURL) {
            (data, response, error) in
            
            // If we have recieved an error message
            if let error = error {
                print(error)
                return
            }
            
            // Parse data
            do {
                let decoder = JSONDecoder()
                let ingredientRootWebData = try decoder.decode(IngredientRootWebData.self, from: data!)
                
                // Add all ingredients found from the webservice to Core Data
                if let ingredients = ingredientRootWebData.ingredients {
                    for ingredientWebData in ingredients {
                        let name = ingredientWebData.ingredientName ?? ""
                        let description = ingredientWebData.ingredientDescription ?? ""
                        let _ = self.databaseController?.addIngredient(name: name, ingredientDescription: description)
                    }
                }
                // If ALL ingredients are saved to child managed context, save it to Core Data
                self.databaseController?.saveChildToParent()
                self.databaseController?.saveChanges()
            }
            catch let err {
                print(err)
            }
        }
        
        task.resume()
    }
    
    /// Transfers the name, instructions and ingredients of the selected meal to the CreateMealTableViewController when the user travels there
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myMealsSegue" {
            // Define meal from cell being selected
            // SOURCE: https://stackoverflow.com/questions/44706806/how-do-i-use-prepare-segue-with-tableview-cell
            // AUTHOR: GetSwifty
            let meal = self.shownMeals[tableView.indexPathForSelectedRow!.row]
            
            // Define the destination ViewController to assign its properties
            let destination = segue.destination as! CreateMealTableViewController
            
            // Assign properties to the destination ViewController
            destination.mealName = meal.name ?? ""
            destination.mealInstructions = meal.instructions ?? ""
            // SOURCE: https://stackoverflow.com/questions/24422831/convert-nsset-to-swift-array
            // AUTHOR: Daniel
            for ingredient in meal.ingredients?.allObjects as! [IngredientMeasurement] {
                destination.mealIngredients.append(IngredientMeasurementData(name: ingredient.name ?? "", quantity: ingredient.quantity ?? ""))
            }
            // If savedMealToEdit is defined in CreateMealTableViewController, it will edit the meal rather than saving a new meal
            destination.savedMealToEdit = meal
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
