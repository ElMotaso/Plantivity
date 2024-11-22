//
//  Session+CoreDataProperties.swift
//  Plantivity
//
//  Created by Bania on 23.06.22.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var day: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var time: Int32
    @NSManaged public var project: Project?

}

extension Session : Identifiable {

}
