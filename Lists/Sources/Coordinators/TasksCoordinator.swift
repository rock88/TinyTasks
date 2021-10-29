import Combine
import CoreData

public protocol TasksCoordinator {
    @discardableResult
    func addTask(title: String, information: String?) -> Task
    func update(title: String, information: String?, task: Task)
    func update(isCompleted: Bool, task: Task)
    func delete(task: Task)
    func exchange(task: Task, other: Task)

    func subscribe() -> AnyPublisher<[Task], Never>
}

final class TasksCoordinatorImpl {
    let list: List
    let managedObjectController: ManagedObjectController<TaskMO>
    let fetchedResultsController: FetchedResultsController<TaskMO>

    init(
        list: List,
        managedObjectController: ManagedObjectController<TaskMO>,
        fetchedResultsController: FetchedResultsController<TaskMO>
    ) {
        self.list = list
        self.managedObjectController = managedObjectController
        self.fetchedResultsController = fetchedResultsController
    }
}

extension TasksCoordinatorImpl: TasksCoordinator {
    func addTask(title: String, information: String?) -> Task {
        let model = managedObjectController.makeModel()
        model.title = title
        model.information = information
        list.model.addToTasks(model)

        managedObjectController.save()

        return Task(model: model)
    }

    func update(title: String, information: String?, task: Task) {
        task.model.title = title
        task.model.information = information
        managedObjectController.save()
    }

    func update(isCompleted: Bool, task: Task) {
        task.model.isCompleted = isCompleted
        managedObjectController.save()
    }

    func delete(task: Task) {
        managedObjectController.delete(model: task.model)
    }

    func exchange(task: Task, other: Task) {
        managedObjectController.exchange(model: task.model, other: other.model)
    }

    func subscribe() -> AnyPublisher<[Task], Never> {
        return fetchedResultsController.subject.map { $0.map(Task.init) }.eraseToAnyPublisher()
    }
}
