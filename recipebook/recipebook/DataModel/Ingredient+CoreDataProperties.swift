//
//  Ingredient+CoreDataProperties.swift
//  recipebook
//
//  Created by Andre Pham on 9/4/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var ingredientDescription: String?

}

extension Ingredient : Identifiable {

}
