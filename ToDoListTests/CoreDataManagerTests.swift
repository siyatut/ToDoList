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

    var coreDataManager: CoreDataManagerProtocol!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        coreDataManager = mockCoreDataManager
    }

    override func tearDown() {
        coreDataManager = nil
        mockCoreDataManager = nil
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
            XCTAssertTrue(success, "Task should be saved successfully")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        guard let mockManager = coreDataManager as? MockCoreDataManager else {
            XCTFail("coreDataManager is not a MockCoreDataManager")
            return
        }

        XCTAssertEqual(mockManager.savedTasks.count, 1, "There should be one saved task")
        XCTAssertEqual(mockManager.savedTasks.first?.title, "Test Task", "Task title should match")
    }

    func testFetchTasks() {
        let task = Task(
            id: "1",
            title: "Test Task",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )

        guard let mockManager = coreDataManager as? MockCoreDataManager else {
            XCTFail("coreDataManager is not a MockCoreDataManager")
            return
        }
        mockManager.savedTasks = [task]

        let expectation = self.expectation(description: "Fetch Tasks")
        coreDataManager.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 1, "Expected to fetch one task")
            XCTAssertEqual(tasks.first?.title, "Test Task", "Fetched task title should match")
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

        mockCoreDataManager.savedTasks = [task]

        let deleteExpectation = self.expectation(description: "Delete Task")
        coreDataManager.deleteTask(task) { success in
            XCTAssertTrue(success, "Task should be deleted successfully")
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertTrue(mockCoreDataManager.savedTasks.isEmpty, "Saved tasks should be empty after deletion")
    }
}
