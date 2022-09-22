//
//  Configuration+CoreDataProperties.swift
//  TestApp
//
//  Created by Kate on 20.09.2022.
//
//

import Foundation
import CoreData


extension Configuration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Configuration> {
        return NSFetchRequest<Configuration>(entityName: "Configuration")
    }

    @NSManaged public var isTimerWasShown: Bool

}

extension Configuration : Identifiable {

}
