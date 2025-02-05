//
//  CoreDataManagerTests.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import XCTest
import CoreData

@testable import ToDoList

final class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    var inMemoryContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        inMemoryContainer = {
            let container = NSPersistentContainer(name: "TaskModel")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Failed to set up in-memory store: \(error)")
                }
            }
            return container
        }()
        coreDataManager = CoreDataManager()
        coreDataManager.persistentContainer = inMemoryContainer
    }

    override func tearDown() {
        coreDataManager = nil
        inMemoryContainer = nil
        super.tearDown()
    }

    func testSaveTask() {
        let task = Task(
            id: "1",
            title: "Test Task",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )

        let expectation = self.expectation(description: "Save Task")
        coreDataManager.saveTask(task) { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks = try inMemoryContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.title, "Test Task")
        } catch {
            XCTFail("Failed to fetch tasks: \(error)")
        }
    }

    func testFetchTasks() {
        let context = inMemoryContainer.viewContext
        let entity = TaskEntity(context: context)
        entity.id = "1"
        entity.title = "Test Task"
        entity.descriptionText = "Description"
        entity.dateCreated = "05/02/2025"
        entity.isCompleted = false

        do {
            try context.save()
        } catch {
            XCTFail("Failed to save initial data: \(error)")
        }

        let expectation = self.expectation(description: "Fetch Tasks")
        coreDataManager.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.title, "Test Task")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDeleteTask() {
        let task = Task(
            id: "1",
            title: "Test Task",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )

        let saveExpectation = self.expectation(description: "Save Task")
        coreDataManager.saveTask(task) { success in
            XCTAssertTrue(success)
            saveExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        let deleteExpectation = self.expectation(description: "Delete Task")
        coreDataManager.deleteTask(task) { success in
            XCTAssertTrue(success)
            deleteExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do {
            let tasks = try inMemoryContainer.viewContext.fetch(fetchRequest)
            XCTAssertEqual(tasks.count, 0)
        } catch {
            XCTFail("Failed to fetch tasks after deletion: \(error)")
        }
    }
}
