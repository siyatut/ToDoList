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
        interactor = TaskListInteractor(networkManager: MockNetworkManager())
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

        interactor.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks.first?.title, "Test Task")
        }
    }
}
