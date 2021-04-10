//
//  MealRootWebData.swift
//  recipebook
//
//  Created by Andre Pham on 11/4/21.
//

import UIKit

class MealRootWebData: NSObject, Decodable {
    
    // MARK: - Properties
        
    // Web service
    var meals: [MealWebData]?
    
    // MARK: - Coding Keys
    
    // Meals
    private enum CodingKeys: String, CodingKey {
        case meals
    }
    
}
