//
//  TaskView.swift
//  TestToDoList
//
//  Created by Иван Марин on 18.10.2023.
//
import SwiftUI
import CoreHaptics  /// Importing CoreHaptics for haptic feedback.

// MARK: - TaskView

/// TaskView represents a single task in the to-do list.
struct TaskView: View {
    @ObservedObject var taskListVM: TaskListViewModel  /// The ViewModel which manages tasks.
    @ObservedObject var task: TaskEntity  /// The task entity this view represents.
    @State private var scale: CGFloat = 1.0  /// A state for managing the scale effect on the task icon.
    
    // MARK: - Body

    /// The body property defines the UI and behavior of the TaskView.
    var body: some View {
        HStack {  /// A horizontal stack for laying out the text field and icon.
            
            /// Conditionally use different TextField based on iOS version.
            if #available(iOS 16, *) {
                TextField(AppConstants.titleKey, text: bindingForTextField())
                    .strikethrough(task.isCompleted)  /// Apply strikethrough if the task is completed.
                    .accessibilityIdentifier("TaskFieldIdentifier")  /// Identifier for UI testing.
                    .onChange(of: task.name ?? "") { _, _ in taskListVM.saveContext() }  /// Save context on change.
            } else {
                TextField(AppConstants.titleKey, text: bindingForTextField())
                    .strikethrough(task.isCompleted)  /// Apply strikethrough if the task is completed.
                    .accessibilityIdentifier("TaskFieldIdentifier")  /// Identifier for UI testing.
                    .onChange(of: task.name ?? "") { _ in taskListVM.saveContext() }  /// Save context on change.
            }

            Spacer()  /// A spacer for pushing the icon to the right.
            
            /// The icon which represents the completion status of the task.
            Image(systemName: task.isCompleted ? AppConstants.checkmarkIcon : AppConstants.circleIcon)
                .accessibilityIdentifier(task.isCompleted ? "CompletedIcon" : "IncompleteIcon")  /// Identifier for UI testing.
                .font(.system(size: 30))  /// Set the font size of the icon.
                .scaleEffect(scale)  /// Apply scaling effect.
                .onTapGesture {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()  /// Generate haptic feedback.
                    
                    withAnimation {
                        scale += 0.1  /// Enlarge icon slightly.
                    }
                    
                    task.isCompleted.toggle()  /// Toggle the completion status.
                    
                    withAnimation {
                        scale = 1.0  /// Reset icon size.
                    }
                    
                    taskListVM.reorderTasks()  /// Call to reorder tasks (if defined in ViewModel).
                }
        }
        .padding(.horizontal, 10)  /// Apply horizontal padding.
        .padding(.vertical, 15)  /// Apply vertical padding.
        .background(AppConstants.secondaryColor)  /// Set the background color.
    }
    
    // MARK: - Binding Helper

    /// A helper method for creating a two-way binding to the task name.
    private func bindingForTextField() -> Binding<String> {
        Binding(get: { task.name ?? "" }, set: { task.name = $0 })  /// Get and set the task name.
    }
}

// MARK: - Preview

/// A preview for designing and testing the TaskView in Xcode.
#Preview {
    let context = PersistenceController.shared.container.viewContext
    let task = TaskEntity(context: context)
    task.name = "FOO"
    task.isCompleted = false
    
    return TaskView(taskListVM: TaskListViewModel(viewContext: context), task: task)
}
