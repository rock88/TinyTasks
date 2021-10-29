import CoreData

protocol OrderedManagedObject: NSManagedObject {
    var order: Int64 { get set }
    var id: UUID? { get set }
}

extension OrderedManagedObject {
    static func makeFetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest(entityName: "\(Self.self)")
    }
}

extension ListMO: OrderedManagedObject {}
extension TaskMO: OrderedManagedObject {}

final class ManagedObjectController<T: OrderedManagedObject> {
    let context: NSManagedObjectContext
    let incrementCounter: IncrementCounter
    let predicate: NSPredicate?

    init(context: NSManagedObjectContext, incrementCounter: IncrementCounter, predicate: NSPredicate?) {
        self.context = context
        self.incrementCounter = incrementCounter
        self.predicate = predicate
    }
}

extension ManagedObjectController {
    func makeModel() -> T {
        let model = T(context: context)
        model.id = UUID()
        model.order = incrementCounter.incrementIndex(for: T.self)
        return model
    }

    func exchange(model: T, other: T) {
        guard model != other else { return }

        let orderPredicate = NSPredicate(
            format: "(%@ <= order) AND (order <= %@)",
            NSNumber(value: min(model.order, other.order)),
            NSNumber(value: max(model.order, other.order))
        )

        let request = T.makeFetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, orderPredicate].compactMap { $0 })
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]

        do {
            var items = try context.fetch(request)

            if let index = items.firstIndex(of: model), let another = items.firstIndex(of: other) {
                let orders = items.map(\.order)
                items.remove(at: index)
                items.insert(model, at: another)
                zip(orders, items).forEach { $1.order = $0 }

                save()
            } else {
                print("Failed to find indices...")
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func delete(model: T) {
        context.delete(model)
        save()
    }

    func save() {
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
