//
//  Project+CoreDataProperties.swift
//  Plantivity
//
//  Created by Bania on 23.06.22.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var end: Date?
    @NSManaged public var icon: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var isFertilized: Bool
    @NSManaged public var lastTierUpdate: Date?
    @NSManaged public var level: Int16
    @NSManaged public var name: String?
    @NSManaged public var plant: Int16
    @NSManaged public var start: Date?
    @NSManaged public var state: Int16
    @NSManaged public var tier: Int16
    @NSManaged public var time: Int64
    @NSManaged public var parent: Project?
    @NSManaged public var session: NSSet?
    @NSManaged public var subprojects: NSSet?

}

// MARK: Generated accessors for session
extension Project {

    @objc(addSessionObject:)
    @NSManaged public func addToSession(_ value: Session)

    @objc(removeSessionObject:)
    @NSManaged public func removeFromSession(_ value: Session)

    @objc(addSession:)
    @NSManaged public func addToSession(_ values: NSSet)

    @objc(removeSession:)
    @NSManaged public func removeFromSession(_ values: NSSet)

}

// MARK: Generated accessors for subprojects
extension Project {

    @objc(addSubprojectsObject:)
    @NSManaged public func addToSubprojects(_ value: Project)

    @objc(removeSubprojectsObject:)
    @NSManaged public func removeFromSubprojects(_ value: Project)

    @objc(addSubprojects:)
    @NSManaged public func addToSubprojects(_ values: NSSet)

    @objc(removeSubprojects:)
    @NSManaged public func removeFromSubprojects(_ values: NSSet)

}


extension Project : Identifiable {
    public var subprojectsArray: [Project]? {
        guard let set = subprojects as? Set<Project> else {
            return nil
        }
        if(set.count == 0) {
            return nil
        }
        
        return Array(set.sorted{
            ($0.start ?? .distantPast) > ($1.start ?? .distantPast)
        })
    }
    
    public var sessionsArray: [Session]? {
        guard let set = session as? Set<Session> else {
            return nil
        }
        if(set.count == 0) {
            return nil
        }
        
        return Array(set.sorted{
            ($0.day ?? .distantPast) > ($1.day ?? .distantPast)
        })
    }
}
