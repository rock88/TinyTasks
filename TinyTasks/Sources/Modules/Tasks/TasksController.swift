import Combine
import Lists

protocol TasksModule: Module {
    func update(items: [Task])
}

protocol TasksController {
    func moduleDidLoad()
    func moduleDidTapAddTask()
    func moduleDidSelect(task: Task)
    func moduleDidEdit(task: Task)
    func moduleDidExchange(task: Task, other: Task)
    func moduleDidDelete(task: Task)
}

final class TasksControllerImpl {
    weak var module: TasksModule?
    var tasksCoordinator: TasksCoordinator?
    var appRouter: AppRouter?

    var cancellables: Set<AnyCancellable> = []
}

extension TasksControllerImpl: TasksController {
    func moduleDidLoad() {
        tasksCoordinator?
            .subscribe()
            .sink { [weak self] items in
                self?.module?.update(items: items)
            }
            .store(in: &cancellables)
    }

    func moduleDidTapAddTask() {
        guard let module = module else { return }

        let context = EditTaskContext(
            title: "Add a new Task",
            taskTitle: nil,
            taskInformation: nil,
            completion: { [weak self] title, information in
                self?.tasksCoordinator?.addTask(title: title, information: information)
            }
        )
        appRouter?.openEditTask(from: module, context: context)
    }

    func moduleDidSelect(task: Task) {
        tasksCoordinator?.update(isCompleted: !task.isCompleted, task: task)
    }

    func moduleDidEdit(task: Task) {
        guard let module = module else { return }

        let context = EditTaskContext(
            title: "Edit Task",
            taskTitle: task.title,
            taskInformation: task.information,
            completion: { [weak self] title, information in
                self?.tasksCoordinator?.update(title: title, information: information, task: task)
            }
        )
        appRouter?.openEditTask(from: module, context: context)
    }

    func moduleDidExchange(task: Task, other: Task) {
        tasksCoordinator?.exchange(task: task, other: other)
    }

    func moduleDidDelete(task: Task) {
        tasksCoordinator?.delete(task: task)
    }
}
