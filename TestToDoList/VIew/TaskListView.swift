import SwiftUI

/// A SwiftUI View for displaying a list of tasks.
struct TaskListView: View {
    @ObservedObject var taskListVM: TaskListViewModel  /// ViewModel for managing tasks.
    @State private var rotation: Double = 0  /// Rotation angle for the add button icon.
    @State private var editMode: EditMode = .inactive  /// State for managing edit mode.

    // MARK: - Body

    /// The body property defines the UI and behavior of TaskListView.
    var body: some View {
        NavigationView {  /// Container for navigation interface.
            ZStack {  /// Layering views.
                taskList  /// List of tasks.
            }
            .navigationBarTitle(AppConstants.navBarTitle, displayMode: .large)  /// Navigation bar title.
            .navigationBarItems(leading: editButton, trailing: addButton)  /// Navigation bar items.
            .environment(\.editMode, $editMode)  /// Provide edit mode environment.
        }
    }
    
    // MARK: - Task List

    /// A computed property for generating the list of tasks.
    private var taskList: some View {
        List {
            ForEach(taskListVM.tasks.indices, id: \.self) { index in  /// Loop through each task index.
                TaskView(taskListVM: taskListVM, task: taskListVM.tasks[index])  /// Generate TaskView.
                    .accessibilityElement(children: .ignore)  /// Accessibility setting.
                    .accessibilityIdentifier("TaskCellIdentifier")  /// Identifier for UI testing.
                    .swipeActions(edge: .trailing) {  /// Swipe actions for deleting tasks.
                        Button(AppConstants.deleteButtonTitle) {
                            taskListVM.removeTask(at: index)  /// Call to remove task.
                        }
                        .accessibilityIdentifier("DeleteButtonIdentifier")  /// Identifier for UI testing.
                        .tint(.red)  /// Red tint for delete button.
                    }
            }
            .onDelete(perform: taskListVM.removeTasks)  /// onDelete action for list editing mode.
        }
    }

    // MARK: - Task Removal
    
    /// Function for removing tasks at specified indices.
    private func removeTasks(at offsets: IndexSet) {
        taskListVM.removeTasks(at: offsets)
    }
    
    // MARK: - Edit Button

    /// A computed property for the Edit button.
    private var editButton: some View {
        EditButton()
    }
    
    // MARK: - Add Button
    
    /// A computed property for the Add button with rotating animation.
    private var addButton: some View {
        Button(action: {
            addTask()
            withAnimation {
                rotation += 360  /// Rotate icon 360 degrees.
            }
        }) {
            rotatingPlusIcon  /// Animated rotating icon.
        }
        .animation(.easeInOut(duration: 1.0), value: rotation)  /// Ease-in-out animation.
        .accessibilityIdentifier("AddButtonIdentifier")  /// Identifier for UI testing.
    }
    
    // MARK: - Rotating Plus Icon
    
    /// A computed property for the rotating plus icon.
    private var rotatingPlusIcon: some View {
            Image(systemName: AppConstants.plusIcon)
                .rotationEffect(.degrees(rotation))  /// Apply rotation effect.
                .padding(5)
                .foregroundColor(.white)
                .background(Circle().fill(AppConstants.primaryColor))  /// Circular background.
        }
    
    // MARK: - Add Task
    
    /// Function for adding a new task.
    private func addTask() {
        taskListVM.addTask(name: AppConstants.addTaskTitle)
    }
    
    // MARK: - Task Binding
    
    /// Function for generating a binding for a specific task.
    private func binding(for task: TaskEntity) -> Binding<TaskEntity> {
        guard let taskIndex = taskListVM.tasks.firstIndex(where: { $0.id == task.id }) else {
            fatalError("Task not found")
        }
        return $taskListVM.tasks[taskIndex]
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let task = TaskEntity(context: context)
    task.name = "BUZ"
    task.isCompleted = false
    return TaskListView(taskListVM: TaskListViewModel(viewContext: context))
}
