//
//  CoreDataController.swift
//  recipebook
//
//  Created by Andre Pham on 9/4/21.
//

import UIKit
import CoreData

class CoreDataController: NSObject {
    
    // MARK: - Properties
    
    // FetchedResultsControllers
    var allMealsFetchedResultsController: NSFetchedResultsController<Meal>?
    var allIngredientsFetchedResultsController: NSFetchedResultsController<Ingredient>?
    
    // Other properties
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    var childManagedContext: NSManagedObjectContext
    
    // MARK: - Constructor
    
    override init() {
        // Define persistent container
        persistentContainer = NSPersistentContainer(name: "RecipebookDataModel")
        persistentContainer.loadPersistentStores() {
            (description, error) in if let error = error {
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        
        // Initiate Child Managed Context
        self.childManagedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childManagedContext.parent = self.persistentContainer.viewContext
        
        super.init()
    }
    
    /// Retrieves all meal entities stored within Core Data persistent memory
    func fetchAllMeals() -> [Meal] {
        if allMealsFetchedResultsController == nil {
            // Instantiate fetch request
            let request: NSFetchRequest<Meal> = Meal.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allMealsFetchedResultsController = NSFetchedResultsController<Meal>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allMealsFetchedResultsController?.delegate = self
            
            // Perform fetch request
            do {
                try allMealsFetchedResultsController?.performFetch()
            }
            catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        if let meals = allMealsFetchedResultsController?.fetchedObjects {
            return meals
        }
        
        return [Meal]() // Empty
    }

    /// Retrieves all ingredient entities stored within Core Data persistent memory
    func fetchAllIngredients() -> [Ingredient] {
        if allIngredientsFetchedResultsController == nil {
            // Instantiate fetch request
            let request: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            // Initialise Fetched Results Controller
            allIngredientsFetchedResultsController = NSFetchedResultsController<Ingredient>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            // Set this class to be the results delegate
            allIngredientsFetchedResultsController?.delegate = self
            
            // Perform fetch request
            do {
                try allIngredientsFetchedResultsController?.performFetch()
            }
            catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        if let ingredients = allIngredientsFetchedResultsController?.fetchedObjects {
            return ingredients
        }
        
        return [Ingredient]() // Empty
    }
    
}

extension CoreDataController: DatabaseProtocol {
    
    /// Checks if there are changes to be saved inside of the view context and then saves, if necessary
    func saveChanges() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            }
            catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    /// Saves the child context, hence pushing the changes to the parent context
    func saveChildToParent() {
        do {
            // Saving child managed context pushes it to Core Data
            try self.childManagedContext.save()
        }
        catch {
            fatalError("Failed to save child managed context to Core Data with error: \(error)")
        }
    }
    
    /// Creates a new listener that either fetches all meals or ingredients
    func addListener(listener: DatabaseListener) {
        // Adds the new database listener to the list of listeners
        listeners.addDelegate(listener)
        
        // Provides the listener with the initial immediate results depending on the type
        if listener.listenerType == .meal || listener.listenerType == .all {
            listener.onAnyMealChange(change: .update, meals: fetchAllMeals())
        }
        if listener.listenerType == .ingredient || listener.listenerType == .all {
            listener.onAnyIngredientChange(change: .update, ingredients: fetchAllIngredients())
        }
    }
    
    /// Removes a specific listener
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    /// Adds a Meal instance to Core Data
    func addMeal(name: String, instructions: String) -> Meal {
        // Create Meal entity
        let meal = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: persistentContainer.viewContext) as! Meal
        
        // Assign attributes to Meal entity
        meal.name = name
        meal.instructions = instructions
        
        // Meal is returned in case it has to be used after its added to Core Data
        return meal
    }
    
    /// Removes a Meal instance from Core Data
    func deleteMeal(meal: Meal) {
        persistentContainer.viewContext.delete(meal)
    }
    
    /// Adds an Ingredient instance to the child context
    func addIngredient(name: String, ingredientDescription: String) -> Ingredient {
        // Creates an Ingredient entity in child context
        let ingredient = NSEntityDescription.insertNewObject(forEntityName: "Ingredient", into: self.childManagedContext) as! Ingredient
        
        // Assign attributes to Meal entity
        ingredient.name = name
        ingredient.ingredientDescription = ingredientDescription
        
        // Ingredient is returned in case it has to be used after being added to the child context
        return ingredient
    }
    
    /// Removes an Ingredient instance from Core Data
    func deleteIngredient(ingredient: Ingredient) {
        persistentContainer.viewContext.delete(ingredient)
    }
    
    /// Returns the number of Ingredient instances saved in Core Data
    func countIngredients() -> Int {
        return fetchAllIngredients().count
    }
    
    /// Adds an IngredientMeasurement instance to a saved Meal instance in Core Data
    func addIngredientMeasurementToMeal(name: String, quantity: String, meal: Meal) {
        // Create Meal entity
        let ingredientMeasurement = NSEntityDescription.insertNewObject(forEntityName: "IngredientMeasurement", into: persistentContainer.viewContext) as! IngredientMeasurement
        
        // Assign attributes to Meal entity
        ingredientMeasurement.name = name
        ingredientMeasurement.quantity = quantity
        
        // Add to Meal entity
        meal.addToIngredients(ingredientMeasurement)
    }
    
    /// Removes an IngredientMeasurement instance from a saved Meal in Core Data
    func removeIngredientMeasurementFromMeal(ingredientMeasurement: IngredientMeasurement, meal: Meal) {
        meal.removeFromIngredients(ingredientMeasurement)
    }
    
    /// Modifies the properties of a Meal instance already saved to Core Data
    func editSavedMeal(meal: Meal, newName: String, newInstructions: String) {
        meal.name = newName
        meal.instructions = newInstructions
    }
    
}

extension CoreDataController: NSFetchedResultsControllerDelegate {
    
    /// Called whenever the FetchedResultsController detects a change to the result of its fetch
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allMealsFetchedResultsController {
            listeners.invoke() {
                listener in if listener.listenerType == .meal || listener.listenerType == .all {
                    listener.onAnyMealChange(change: .update, meals: fetchAllMeals())
                }
            }
        }
        else if controller == allIngredientsFetchedResultsController {
            listeners.invoke {
                (listener) in if listener.listenerType == .ingredient || listener.listenerType == .all {
                    listener.onAnyIngredientChange(change: .update, ingredients: fetchAllIngredients())
                }
            }
        }
    }
    
}
