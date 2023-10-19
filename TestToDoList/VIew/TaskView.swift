//
//  TaskView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//

import SwiftUI
import CoreHaptics

struct TaskView: View {
    @ObservedObject var taskListVM: TaskListViewModel
    @ObservedObject var task: TaskEntity
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        HStack {
            
            if #available(iOS 16, *) {
                TextField(AppConstants.titleKey, text: bindingForTextField())
                    .accessibilityIdentifier("TaskFieldIdentifier")
                    .onChange(of: task.name ?? "") { _, _ in taskListVM.saveContext() }
            } else {
                TextField(AppConstants.titleKey, text: bindingForTextField())
                    .accessibilityIdentifier("TaskFieldIdentifier")
                    .onChange(of: task.name ?? "") { _ in taskListVM.saveContext() }
            }

            Spacer()
            
            Image(systemName: task.isCompleted ? AppConstants.checkmarkIcon : AppConstants.circleIcon)
                .accessibilityIdentifier(task.isCompleted ? "CompletedIcon" : "IncompleteIcon")
                .font(.system(size: 30))
                .scaleEffect(scale)
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    withAnimation {
                        scale += 0.1
                    }
                    
                    task.isCompleted.toggle()
                    
                    withAnimation {
                        scale = 1.0
                    }
                }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(AppConstants.secondaryColor)
    }
    
    private func bindingForTextField() -> Binding<String> {
        Binding(get: { task.name ?? "" }, set: { task.name = $0 })
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let task = TaskEntity(context: context)
    task.name = "Пример"
    task.isCompleted = false
    
    return TaskView(taskListVM: TaskListViewModel(viewContext: context), task: task)
}
 
