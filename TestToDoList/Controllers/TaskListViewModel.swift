//
//  TaskListViewModel.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []

    // Добавление новой задачи
    func addTask(name: String) {
        tasks.append(Task(name: name, isCompleted: false))
    }

    // Удаление задачи по индексу
    func removeTask(at index: Int) {
        tasks.remove(at: index)
    }

    // Удаление задач по набору индексов
    func removeTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    // Изменение статуса задачи на выполненную/невыполненную
    func toggleTaskCompletion(at index: Int) {
        tasks[index].isCompleted.toggle()
    }
}

