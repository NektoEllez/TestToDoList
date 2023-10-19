//
//  AppConstants.swift
//  TestToDoList
//
//  Created by Иван Марин on 19.10.2023.
//

import SwiftUI

// A struct for organizing application-wide constant values.
struct AppConstants {
    // Colors used throughout the app.
    static let primaryColor: Color = Color.blue  // Primary color used for main UI elements.
    static let secondaryColor: Color = Color.white  // Secondary color used for background or contrasting elements.

    // A common corner radius value for buttons or other UI elements.
    static let buttonCornerRadius: CGFloat = 10

    // Icon names used for system images.
    static let plusIcon = "plus"  // Plus icon typically used for "Add" actions.
    static let checkmarkIcon = "checkmark.circle.fill"  // Checkmark icon used for indicating completion.
    static let circleIcon = "circle"  // Circle icon used for indicating incompletion.

    // Text used for buttons, titles, or labels.
    static let deleteButtonTitle = "Delete"  // Title text for the delete button.
    static let navBarTitle = "Task list"  // Title text for the navigation bar in task list view.
    static let addTaskTitle = "New Task"  // Default title text for new tasks.
    static let titleKey = "Task"  // Key text used for task title field.
}
