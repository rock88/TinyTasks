import CoreData
import Foundation

public extension ListMO {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ListMO> {
        return NSFetchRequest<ListMO>(entityName: "ListMO")
    }

    @NSManaged var title: String?
    @NSManaged var createDate: Date?
    @NSManaged var order: Int64
    @NSManaged var id: UUID?
    @NSManaged var tasks: NSSet?
}

// MARK: Generated accessors for tasks

public extension ListMO {
    @objc(addTasksObject:)
    @NSManaged func addToTasks(_ value: TaskMO)

    @objc(removeTasksObject:)
    @NSManaged func removeFromTasks(_ value: TaskMO)

    @objc(addTasks:)
    @NSManaged func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged func removeFromTasks(_ values: NSSet)
}

extension ListMO: Identifiable {}
