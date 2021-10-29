import Combine
import CoreData

public protocol ListsCoordinator {
    @discardableResult
    func addList(title: String) -> List
    func update(title: String, list: List)
    func delete(list: List)
    func exchange(list: List, other: List)

    func subscribe() -> AnyPublisher<[List], Never>
}

final class ListsCoordinatorImpl {
    let managedObjectController: ManagedObjectController<ListMO>
    let fetchedResultsController: FetchedResultsController<ListMO>

    init(
        managedObjectController: ManagedObjectController<ListMO>,
        fetchedResultsController: FetchedResultsController<ListMO>
    ) {
        self.managedObjectController = managedObjectController
        self.fetchedResultsController = fetchedResultsController
    }
}

extension ListsCoordinatorImpl: ListsCoordinator {
    func addList(title: String) -> List {
        let model = managedObjectController.makeModel()
        model.title = title
        model.createDate = Date()

        managedObjectController.save()

        return List(model: model)
    }

    func update(title: String, list: List) {
        list.model.title = title
        managedObjectController.save()
    }

    func delete(list: List) {
        managedObjectController.delete(model: list.model)
    }

    func exchange(list: List, other: List) {
        managedObjectController.exchange(model: list.model, other: other.model)
    }

    func subscribe() -> AnyPublisher<[List], Never> {
        return fetchedResultsController.subject.map { $0.map(List.init) }.eraseToAnyPublisher()
    }
}
