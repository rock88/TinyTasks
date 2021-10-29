import CoreData
import DI

public final class ListsAssembly: Assembly {
    //
}

public extension ListsAssembly {
    var listsCoordinator: ListsCoordinator {
        return define(
            scope: .singleton,
            init: ListsCoordinatorImpl(
                managedObjectController: managedObjectController(),
                fetchedResultsController: fetchedResultsController()
            )
        )
    }

    func tasksCoordinator(list: List) -> TasksCoordinator {
        return define(init: TasksCoordinatorImpl(
            list: list,
            managedObjectController: managedObjectController(predicate: NSPredicate(format: "list == %@", list.model)),
            fetchedResultsController: fetchedResultsController(predicate: NSPredicate(format: "list == %@", list.model))
        ))
    }
}

private extension ListsAssembly {
    var incrementCounter: IncrementCounter {
        return define(scope: .singleton, init: IncrementCounterImpl())
    }

    var persistentContainer: NSPersistentContainer {
        return define(scope: .singleton, init: { () -> NSPersistentContainer? in
            let bundle = Bundle.main.url(forResource: "Lists", withExtension: "bundle").flatMap(Bundle.init)
            let url = bundle?.url(forResource: "Lists", withExtension: "momd")
            let model = url.flatMap(NSManagedObjectModel.init)
            let persistentContainer = model.flatMap { NSPersistentContainer(name: "Lists", managedObjectModel: $0) }
            persistentContainer?.loadPersistentStores { _, error in
                if let error = error {
                    print("Load persistent stores failed: \(error)")
                }
            }
            return persistentContainer
        }())
    }

    func managedObjectController<T: OrderedManagedObject>(predicate: NSPredicate? = nil) -> ManagedObjectController<T> {
        return define(init: ManagedObjectController<T>(
            context: persistentContainer.viewContext,
            incrementCounter: incrementCounter,
            predicate: predicate
        ))
    }

    func fetchedResultsController<T: OrderedManagedObject>(predicate: NSPredicate? = nil) -> FetchedResultsController<T> {
        return define(init: FetchedResultsController<T>(
            persistentContainer: persistentContainer,
            incrementCounter: incrementCounter,
            predicate: predicate
        ))
    }
}
