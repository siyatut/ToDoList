//
//  TaskListPresenterTests.swift
//  ToDoList
//
//  Created by Anastasia Tyutinova on 5/2/2568 BE.
//

import XCTest
@testable import ToDoList

final class TaskListPresenterTests: XCTestCase {

    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!

    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        presenter = TaskListPresenter(
            view: mockView,
            interactor: mockInteractor,
            router: mockRouter
        )
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoadFetchesTasks() {

        mockInteractor.cachedTasks = [
            Task(
                id: "1",
                title: "Test Task",
                description: "Description",
                dateCreated: "05/02/2025",
                isCompleted: false
            )
        ]

        let expectation = XCTestExpectation(description: "Tasks should be fetched and displayed")

        presenter.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            XCTAssertTrue(self.mockInteractor.isFetchCalled, "Fetch tasks should be called")
            XCTAssertEqual(self.mockView.tasks.count, 1, "View should display fetched tasks")
            XCTAssertEqual(self.mockView.tasks.first?.id, "1", "Fetched task ID should match")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testDidSelectTaskNavigatesToEditTaskScreen() {

        let task = Task(
            id: "1",
            title: "Test Task",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )
        mockInteractor.cachedTasks = [task]
        presenter.viewDidLoad()

        presenter.didSelectTask(at: 0)

        XCTAssertTrue(mockRouter.isNavigateToEditTaskCalled, "Router should navigate to Edit Task screen")
        XCTAssertEqual(mockRouter.editedTask?.id, "1", "Correct task should be passed to the router")
    }

    func testDidSelectDeleteTaskRemovesTask() {
        let task = Task(
            id: "1",
            title: "Task to Delete",
            description: "Description",
            dateCreated: "05/02/2025",
            isCompleted: false
        )
        mockInteractor.cachedTasks = [task]
        presenter.viewDidLoad()

        let expectation = XCTestExpectation(description: "Task should be deleted")
        presenter.didSelectDeleteTask(at: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

            XCTAssertTrue(
                self.mockInteractor.isDeleteCalled,
                "Delete task should be called on interactor"
            )
            XCTAssertEqual(
                self.mockInteractor.cachedTasks.count,
                0,
                "Task should be removed from interactor"
            )
            XCTAssertEqual(
                self.mockView.deletedTaskIndexPaths,
                [IndexPath(row: 0, section: 0)],
                "Task should be removed from the view"
            )

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
