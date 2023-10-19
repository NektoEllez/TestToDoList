//
//  TestToDoList_UI_Tests.swift
//  TestToDoList_UI_Tests
//
//  Created by Иван Марин on 19.10.2023.
//

import XCTest
import TestToDoList

// This class contains UI tests for the TestToDoList app.
final class TestToDoList_UI_Tests: XCTestCase {
    
    // This struct holds the constants used within the tests.
    private struct TestConstants {
        static let checkmarkIcon = "checkmark.circle.fill"
        static let circleIcon = "circle"
        static let addTaskTitle = "New Task"
    }
    
    // This method is called before each test method in the class is run.
    // It's a good place to put setup code.
    override func setUpWithError() throws {
        continueAfterFailure = false  // Stop running the test immediately upon failure.
    }
    
    // This method is called after each test method in the class has been run.
    // It's a good place to put teardown code.
    override func tearDownWithError() throws {
    }
    
    // This test verifies that a task can be added successfully.
    func testAddTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the add task button.
        app.buttons["AddButtonIdentifier"].tap()
        
        // Add a small delay to allow for animations and UI updates.
        sleep(2)
        
        // Verify that the task has been added.
        XCTAssertTrue(
            app.textFields[TestConstants.addTaskTitle].exists,
            "\(TestConstants.addTaskTitle) field should exist"
        )
    }
    
    // This test verifies that a task can be deleted successfully.
    func testDeleteTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Use otherElements instead of cells.
        let taskCell = app.otherElements.matching(identifier: "TaskCellIdentifier").firstMatch
        
        // Swipe left on the task cell to reveal the delete button.
        taskCell.swipeLeft()
        
        // Now find and tap the delete button.
        let deleteButton = app.buttons.matching(identifier: "DeleteButtonIdentifier").firstMatch
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5))
        deleteButton.tap()
        
        // Verify that the task has been deleted.
        XCTAssertFalse(app.staticTexts["New Task"].exists)
    }
    
    // This test verifies that a task can be edited successfully.
    func testEditTask() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Tap the add task button.
        app.buttons["AddButtonIdentifier"].tap()
        
        // Add a small delay to allow for animations and UI updates.
        sleep(2)
        
        // Try to access the text field directly, without using waiting.
        let taskField = app.textFields.firstMatch
        XCTAssertTrue(taskField.exists, "\(TestConstants.addTaskTitle) field should exist")
        
        // Edit the task.
        taskField.tap()
        taskField.typeText(" Edited")
        
        // Verify that the task has been edited.
        XCTAssertEqual(taskField.value as? String, "New Task Edited", "Task field should have updated text")
    }
    
    // This test verifies that a task can be marked as completed successfully.
    func testCompleteTask() throws {
        let app = XCUIApplication()
        app.launch()

        // Tap the add task button.
        app.buttons["AddButtonIdentifier"].tap()

        // Add a small delay to allow for animations and UI updates.
        sleep(2)

        // Verify that the task has been added.
        let taskField = app.textFields.firstMatch
        XCTAssertTrue(taskField.exists, "\(TestConstants.addTaskTitle) field should exist")

        // Mark the task as completed.
        app.images["IncompleteIcon"].firstMatch.tap()

        // Verify that the icon has changed to a checkmark.
        XCTAssertTrue(app.images["CompletedIcon"].exists, "Completed icon should exist")
    }
}
