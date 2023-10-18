//
//  TaskListView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM = TaskListViewModel()
    @State private var rotation: Double = 0
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            ZStack {
                taskList
            }
            .navigationBarTitle("Список задач", displayMode: .large)
            .navigationBarItems(leading: editButton, trailing: addButton)
            .environment(\.editMode, $editMode) // <-- Добавьте эту строку
        }
    }
    
    private var taskList: some View {
        List {
            ForEach(taskListVM.tasks.indices, id: \.self) { index in
                TaskView(task: $taskListVM.tasks[index])
                    .swipeActions(edge: .trailing) {
                        Button("Delete") {
                            taskListVM.removeTask(at: index)
                        }
                        .tint(.red)
                    }
            }
            .onDelete(perform: removeTasks)
        }
    }


    
    private func removeTasks(at offsets: IndexSet) {
        taskListVM.removeTasks(at: offsets)
    }
    
    private var editButton: some View {
        EditButton()
    }
    
    private var addButton: some View {
        Button(action: {
            addTask()
            withAnimation {
                rotation += 360
            }
        }) {
            rotatingPlusIcon
        }
        .animation(.easeInOut(duration: 1.0), value: rotation)
    }
    
    private var rotatingPlusIcon: some View {
        Image(systemName: "plus")
            .rotationEffect(.degrees(rotation))
            .padding(5)
            .foregroundColor(.white)
            .background(Circle().fill(Color.gray))
    }
    
    private func addTask() {
        taskListVM.addTask(name: "Новая задача")
    }
    
    private func binding(for task: Task) -> Binding<Task> {
        guard let taskIndex = taskListVM.tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found")
        }
        return $taskListVM.tasks[taskIndex]
    }
}

struct TaskCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .gray, radius: 2, x: 0, y: 2))
            .padding(.horizontal, 16)
    }
}

#Preview {
    TaskListView()
}
