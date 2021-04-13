//
//  DatabaseProtocol.swift
//  recipebook
//
//  Created by Andre Pham on 9/4/21.
//

import Foundation

// Defines chat type of change has been done to the database
enum DatabaseChange {
    case add
    case remove
    case update
}

// When different data requires different handling, we define ListenerType, which
// specifies the type of data each listener has to deal with
enum ListenerType {
    case meal
    case ingredient
    case all
}

// A listener (protocol) that allows for <I DONT KNOW>
protocol DatabaseListener: AnyObject {
    // Protocol requires that listenerType is specified
    var listenerType: ListenerType {get set}
    
    func onAnyMealChange(change: DatabaseChange, meals: [Meal])
    func onAnyIngredientChange(change: DatabaseChange, ingredients: [Ingredient])
}

// A protocol defines all the behaviour that a database must have, accessable to
// all parts of the application
protocol DatabaseProtocol: AnyObject {
    
    func saveChanges()
    func saveChildToParent()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addMeal(name: String, instructions: String) -> Meal
    func deleteMeal(meal: Meal)
    
    func addIngredient(name: String, ingredientDescription: String) -> Ingredient
    func deleteIngredient(ingredient: Ingredient)
    
    func countIngredients() -> Int
    
    func addIngredientMeasurementToMeal(name: String, quantity: String, meal: Meal) -> Bool
    func removeIngredientMeasurementFromMeal(ingredientMeasurement: IngredientMeasurement, meal: Meal)
}
