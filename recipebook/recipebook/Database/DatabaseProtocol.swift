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

// Specifies the type of data each listener has to deal with
enum ListenerType {
    case meal
    case ingredient
    case all
}

// Protocol for listeners for when the database changes
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    func onAnyMealChange(change: DatabaseChange, meals: [Meal])
    func onAnyIngredientChange(change: DatabaseChange, ingredients: [Ingredient])
}

// Protocol for all functions for interacting with the database
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
    
    func addIngredientMeasurementToMeal(name: String, quantity: String, meal: Meal)
    func removeIngredientMeasurementFromMeal(ingredientMeasurement: IngredientMeasurement, meal: Meal)
    
    func editSavedMeal(meal: Meal, newName: String, newInstructions: String)
}
