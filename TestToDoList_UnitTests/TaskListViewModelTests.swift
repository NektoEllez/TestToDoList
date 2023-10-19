//
//  TestToDoList_UnitTests.swift
//  TestToDoList_UnitTests
//
//  Created by Иван Марин on 19.10.2023.
//

import XCTest
import CoreData
@testable import TestToDoList

class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModel!
    var inMemoryPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        inMemoryPersistentContainer = NSPersistentContainer(name: "TaskEntity")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryPersistentContainer.persistentStoreDescriptions = [description]
        inMemoryPersistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        viewModel = TaskListViewModel(viewContext: inMemoryPersistentContainer.viewContext)
    }

    override func tearDown() {
        viewModel = nil
        inMemoryPersistentContainer = nil
        super.tearDown()
    }

    func testAddTask() {
        viewModel.addTask(name: "Test Task")
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.name, "Test Task")
    }

    func testRemoveTask() {
        viewModel.addTask(name: "Test Task")
        XCTAssertEqual(viewModel.tasks.count, 1)
        viewModel.removeTask(at: 0)
        XCTAssertEqual(viewModel.tasks.count, 0)
    }

    func testRemoveTasks() {
        viewModel.addTask(name: "Task 1")
        viewModel.addTask(name: "Task 2")
        XCTAssertEqual(viewModel.tasks.count, 2)
        viewModel.removeTasks(at: IndexSet([0]))
        XCTAssertEqual(viewModel.tasks.count, 1)
    }
}

