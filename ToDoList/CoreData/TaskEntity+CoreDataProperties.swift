//
//  TaskEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 2/2/2568 BE.
//
//

import Foundation
import CoreData

extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var dateCreated: String?
    @NSManaged public var isCompleted: Bool

}

extension TaskEntity: Identifiable {}
