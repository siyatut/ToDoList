//
//  TaskListInteractorTests.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import XCTest
@testable import ToDoList

final class TaskListInteractorTests: XCTestCase {

    var interactor: TaskListInteractor!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        interactor = TaskListInteractor(storage: mockCoreDataManager)
    }

    override func tearDown() {
        interactor = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testFetchTasks() {
        let task = Task(
            id: "1",
            title: "Test Task",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )
        mockCoreDataManager.savedTasks = [task]

        let expectation = self.expectation(description: "Fetch Tasks")
        interactor.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 1, "Expected to fetch one task")
            XCTAssertEqual(tasks.first?.title, "Test Task", "Fetched task title should match")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
