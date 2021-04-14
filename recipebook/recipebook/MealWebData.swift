//
//  MealWebData.swift
//  recipebook
//
//  Created by Andre Pham on 11/4/21.
//

import UIKit

class MealWebData: NSObject, Decodable {
    
    // MARK: - Properties
    
    // Web service
    var mealName: String?
    var mealInstructions: String?
    var mealIngredients = [IngredientMeasurementData]()
    
    let INGREDIENT_NAME_KEY = "strIngredient"
    let INGREDIENT_MEASURE_KEY = "strMeasure"
    
    // MARK: - Coding Keys
    
    private enum MealKeys: String, CodingKey {
        case mealName = "strMeal"
        case mealInstructions = "strInstructions"
    }
    
    // SOURCE: https://swiftsenpai.com/swift/decode-dynamic-keys-json/
    // AUTHOR: Lee Kah Seng - https://twitter.com/Lee_Kah_Seng
    // Allow for the creation of dynamic coding keys based on keys read from the webservice
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    // MARK: - Constructor
    
    required init(from decoder: Decoder) throws {
        // Assign the container that holds all of the meals retrieved from the webservice
        // (Only used for meal names and instructions)
        let mealContainer = try decoder.container(keyedBy: MealKeys.self)
        
        // Assign a container that holds all string keys retrieved from the webservice
        // (Only used for the meal ingredients)
        let infoContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // This will hold the ingredient name key as a key, and the ingredient name as a value
        // (Used to match to ingredient measurement and order later)
        var tempIngredientNames = [String: String]() // e.g. strIngredient1: Eggs
        // This will hold the ingredient measurement key as a key, and the ingredient measurement as a value
        // (Used to match to ingredient name and order later)
        var tempIngredientMeasurements = [String: String]() // e.g. strMeasure1: 100g
        
        // For every key retrieved from the webservice
        for key in infoContainer.allKeys {
            do {
                // decodedObject is the value to the key in loop, retrieved from the webservice
                let decodedObject = try infoContainer.decode(String.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)

                // If key value holds an ingredient that isn't an empty string
                if key.stringValue.contains(self.INGREDIENT_NAME_KEY) && decodedObject.count > 0 {
                    tempIngredientNames[key.stringValue] = decodedObject
                }
                // If key value holds an ingredient measurement that isn't an emptry string
                else if key.stringValue.contains(self.INGREDIENT_MEASURE_KEY) && decodedObject.count > 0 {
                    tempIngredientMeasurements[key.stringValue] = decodedObject
                }
            }
            catch {
                // null value
            }
        }
        
        // Saves ingredients with matching names and measurements to self.mealIngredients, in ascending order
        for ingredientNum in 1...tempIngredientNames.count {
            // Assign keys names to retrieve values from dictionaries
            let ingredientNameKey = self.INGREDIENT_NAME_KEY + String(ingredientNum)
            let ingredientMeasurementKey = self.INGREDIENT_MEASURE_KEY + String(ingredientNum)
            
            // Add ingredients to self.mealIngredients
            if let ingredientName = tempIngredientNames[ingredientNameKey], let ingredientMeasurement = tempIngredientMeasurements[ingredientMeasurementKey] {
                self.mealIngredients.append(IngredientMeasurementData(name: ingredientName, quantity: ingredientMeasurement))
            }
        }
        
        // Assign meal name from webservice meal container
        do {
            self.mealName = try mealContainer.decode(String.self, forKey: .mealName)
        }
        catch {
            self.mealName = ""
        }
        
        // Assign meal instructions from webservice meal container
        do {
            self.mealInstructions = try mealContainer.decode(String.self, forKey: .mealInstructions)
        }
        catch {
            self.mealInstructions = ""
        }
    }

}
