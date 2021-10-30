import Combine
import Lists
import SwiftUI

typealias TaskItem = Lists.Task

final class TasksManager: ObservableObject {
    let tasksCoordinator: TasksCoordinator

    @Published var tasks: [TaskItem] = []

    var cancellable: Cancellable?

    init(tasksCoordinator: TasksCoordinator) {
        self.tasksCoordinator = tasksCoordinator

        cancellable = tasksCoordinator
            .subscribe()
            .assign(to: \.tasks, on: self)
    }

    func addTask(title: String, information: String?) {
        tasksCoordinator.addTask(title: title, information: information)
    }

    func update(title: String, information: String?, task: TaskItem) {
        tasksCoordinator.update(title: title, information: information, task: task)
    }

    func update(isCompleted: Bool, task: TaskItem) {
        tasksCoordinator.update(isCompleted: isCompleted, task: task)
    }

    func delete(task: TaskItem) {
        tasksCoordinator.delete(task: task)
    }

    func move(source: IndexSet, destination: Int) {
        guard let indices = fixIndices(source: source, destination: destination, items: tasks) else {
            return
        }

        tasksCoordinator.exchange(task: tasks[indices.source], other: tasks[indices.destination])
    }
}
