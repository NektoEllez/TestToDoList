//
//  TaskListView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskListVM: TaskListViewModel
    @State private var rotation: Double = 0
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            ZStack {
                taskList
            }
            .navigationBarTitle(AppConstants.navBarTitle, displayMode: .large)
            .navigationBarItems(leading: editButton, trailing: addButton)
            .environment(\.editMode, $editMode)
        }
    }
    
    private var taskList: some View {
        List {
            ForEach(taskListVM.tasks.indices, id: \.self) { index in
                TaskView(taskListVM: taskListVM, task: taskListVM.tasks[index])
                    .accessibilityElement(children: .ignore)     
                    .accessibilityIdentifier("TaskCellIdentifier")
                    .swipeActions(edge: .trailing) {
                        Button(AppConstants.deleteButtonTitle) {
                            taskListVM.removeTask(at: index)
                        }
                        .accessibilityIdentifier("DeleteButtonIdentifier")
                        .tint(.red)
                    }
            }
            .onDelete(perform: taskListVM.removeTasks)
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
        .accessibilityIdentifier("AddButtonIdentifier")
    }
    
    private var rotatingPlusIcon: some View {
            Image(systemName: AppConstants.plusIcon)
                .rotationEffect(.degrees(rotation))
                .padding(5)
                .foregroundColor(.white)
                .background(Circle().fill(AppConstants.primaryColor))
        }
    
    private func addTask() {
        taskListVM.addTask(name: AppConstants.addTaskTitle)
    }
    
    private func binding(for task: TaskEntity) -> Binding<TaskEntity> {
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
