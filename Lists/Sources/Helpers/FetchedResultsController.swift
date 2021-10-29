import Combine
import CoreData

final class FetchedResultsController<T: OrderedManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    let persistentContainer: NSPersistentContainer
    let incrementCounter: IncrementCounter
    let fetchedResultsController: NSFetchedResultsController<T>

    lazy var subject = CurrentValueSubject<[T], Never>(fetchedResultsController.fetchedObjects ?? [])

    init(persistentContainer: NSPersistentContainer, incrementCounter: IncrementCounter, predicate: NSPredicate?) {
        self.persistentContainer = persistentContainer
        self.incrementCounter = incrementCounter

        let request = T.makeFetchRequest()
        request.fetchBatchSize = 30
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
        request.predicate = predicate

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        subject.send(fetchedResultsController.fetchedObjects ?? [])
    }
}
