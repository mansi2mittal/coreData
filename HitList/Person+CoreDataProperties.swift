//
//  Person+CoreDataProperties.swift
//  HitList
//
//  Created by Appinventiv on 24/02/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person");
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var mobile: String?
    @NSManaged public var age: String?
    @NSManaged public var gender: String?

}
