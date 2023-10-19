//
//  ContentView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI

/// The main entry point for the SwiftUI app.
@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared  /// Shared instance of the PersistenceController.

    /// The body property defines the structure and behavior of the app.
    var body: some Scene {
        WindowGroup {  /// A group for sharing app behavior across windows.
            let taskListVM = TaskListViewModel(viewContext: persistenceController.container.viewContext)  /// Create a new TaskListViewModel.
            TaskListView(taskListVM: taskListVM)  /// Create the main TaskListView.
                .environment(\.managedObjectContext, persistenceController.container.viewContext)  /// Provide the managed object context to the TaskListView.
        }
    }
}
