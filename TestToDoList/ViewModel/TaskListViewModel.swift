import Foundation
import CoreData
import SwiftUI

// MARK: - TaskListViewModel

/// This class serves as the ViewModel in the MVVM architectural pattern,
/// acting as an intermediary between the View and the Model (which in this case is CoreData).
class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [TaskEntity] = []  /// An array to hold the tasks fetched from CoreData.
    private var viewContext: NSManagedObjectContext  /// The managed object context from CoreData.
    
    // MARK: - Initialization

    /// Initializer to setup the view context and fetch tasks from CoreData.
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchTasks()
    }

    // MARK: - Fetch Tasks

    /// This method loads tasks from CoreData.
    func fetchTasks() {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        // Sort by completion status, then by whatever other criteria you prefer
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.isCompleted, ascending: true)]
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Fetching tasks failed: \(error)")
        }
    }

    // MARK: - Add Task

    /// This method adds a new task to CoreData.
    func addTask(name: String) {
        let newTask = TaskEntity(context: viewContext)  /// Create a new TaskEntity object.
        newTask.name = name  /// Set the name of the new task.
        newTask.isCompleted = false  /// Set the completion status to false.
        newTask.id = UUID()  /// Assign a unique identifier to the new task.
        
        saveContext()  /// Save the changes to CoreData.
    }

    // MARK: - Remove Tasks

    /// This method removes tasks at specified indices.
    func removeTasks(at offsets: IndexSet) {
        offsets.forEach { index in  /// Iterate through the provided indices.
            let task = tasks[index]  /// Get the task at the current index.
            viewContext.delete(task)  /// Delete the task from CoreData.
        }
        saveContext()  /// Save the changes to CoreData.
    }
    
    /// This method removes a task at a specified index.
    func removeTask(at index: Int) {
        let task = tasks[index]  /// Get the task at the specified index.
        viewContext.delete(task)  /// Delete the task from CoreData.
        saveContext()  /// Save the changes to CoreData.
    }

    // MARK: - Save Context

    /// This method saves any changes to the CoreData context and then fetches the updated list of tasks.
    func saveContext() {
        do {
            try viewContext.save()  /// Attempt to save the context.
            fetchTasks()  /// Fetch the updated list of tasks.
        } catch {
            print("Saving context failed: \(error)")  /// Log any errors that occur during saving.
        }
    }
    
    // MARK: - Reorder Tasks

    /// Method for task reordering
    func reorderTasks() {
        withAnimation {
            tasks.sort { !$0.isCompleted && $1.isCompleted }
        }
    }
}
