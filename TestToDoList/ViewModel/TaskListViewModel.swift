//
//  TaskListViewModel.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import Foundation
import CoreData
import SwiftUI

class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [TaskEntity] = []
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchTasks()
    }

    // Загрузка задач из CoreData
    func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Fetching tasks failed: \(error)")
        }
    }

    // Добавление новой задачи
    func addTask(name: String) {
        let newTask = TaskEntity(context: viewContext)
        newTask.name = name
        newTask.isCompleted = false
        newTask.id = UUID()
        
        saveContext()
    }

    // Удаление задачи
    func removeTasks(at offsets: IndexSet) {
        offsets.forEach { index in
            let task = tasks[index]
            viewContext.delete(task)
        }
        saveContext()
    }
    
    func removeTask(at index: Int) {
        let task = tasks[index]
        viewContext.delete(task)
        saveContext()
    }

    // Сохранение изменений в CoreData
    func saveContext() {
        do {
            try viewContext.save()
            fetchTasks()
        } catch {
            print("Saving context failed: \(error)")
        }
    }
}
