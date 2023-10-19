//
//  ContentView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI

@main
struct TodoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let taskListVM = TaskListViewModel(viewContext: persistenceController.container.viewContext)
            TaskListView(taskListVM: taskListVM)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
