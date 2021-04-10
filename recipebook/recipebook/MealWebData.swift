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
    
    var mealIngredientNames = [String]()
    var mealIngredientMeasurements = [String]()
    
    let INGREDIENT_NAME_KEY = "strIngredient"
    let INGREDIENT_MEASURE_KEY = "strMeasure"
    
    // MARK: - Coding Keys
    
    /*
    private enum RootKeys: String, CodingKey {
        // This is the name of the root that stores the subsequent values
        case ingredients = "meals"
    }
    */
    
    
    private enum MealKeys: String, CodingKey {
        // Where our case matches our property names, we don't need to specify a value
        case mealName = "strMeal"
        case mealInstructions = "strInstructions"
        //case mealIngredientName = "strIngredient"
        //case mealIngredientMeasurement = "strMeasure"
    }
    
    // https://swiftsenpai.com/swift/decode-dynamic-keys-json/
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
        // Get the root container first
        //let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the ingredient containers
        //let ingredientContainer = try rootContainer.nestedContainer(keyedBy: IngredientKeys.self, forKey: .ingredients)
        
        let mealContainer = try decoder.container(keyedBy: MealKeys.self)
        
        // Get authors as an array then compact
        //print(mealContainer.joined(separator: ", "))
        
        // https://swiftsenpai.com/swift/decode-dynamic-keys-json/
        let infoContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempIngredientNames = [String: String]() // e.g. strIngredient1: Eggs
        var tempIngredientMeasurements = [String: String]() // e.g. strMeasure1: 100g
        
        for key in infoContainer.allKeys {
            do {
                let decodedObject = try infoContainer.decode(String.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
                //print(key.stringValue)
                //print(decodedObject)
                if key.stringValue.contains(self.INGREDIENT_NAME_KEY) && decodedObject.count > 0 {
                    //print(key.stringValue)
                    //print(decodedObject)
                    tempIngredientNames[key.stringValue] = decodedObject
                }
                else if key.stringValue.contains(self.INGREDIENT_MEASURE_KEY) && decodedObject.count > 0 {
                    tempIngredientMeasurements[key.stringValue] = decodedObject
                }
            }
            catch {
                // null value
            }
            
        }
        
        for ingredientNum in 1...tempIngredientNames.count {
            let ingredientNameKey = self.INGREDIENT_NAME_KEY + String(ingredientNum)
            let ingredientMeasurementKey = self.INGREDIENT_MEASURE_KEY + String(ingredientNum)
            
            self.mealIngredientNames.append(tempIngredientNames[ingredientNameKey]!)
            self.mealIngredientMeasurements.append(tempIngredientMeasurements[ingredientMeasurementKey]!)
        }
        
        for i in 0...self.mealIngredientNames.count-1 {
            print(self.mealIngredientNames[i] + ": " + self.mealIngredientMeasurements[i])
        }
        print("-----")
        
        
        /*
        if let ingredientsArray = try? rootContainer.decode([String].self, forKey: .ingredients) {
            self.allIngredients = ingredientsArray
        }
        else {
            self.allIngredients = []
        }
        */
        
        do {
            self.mealName = try mealContainer.decode(String.self, forKey: .mealName)
        }
        catch {
            self.mealName = ""
        }
        
        do {
            self.mealInstructions = try mealContainer.decode(String.self, forKey: .mealInstructions)
        }
        catch {
            self.mealInstructions = ""
        }
        
        
    }

}
