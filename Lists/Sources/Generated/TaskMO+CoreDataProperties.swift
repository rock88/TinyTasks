import CoreData
import Foundation

extension TaskMO {
    @nonobjc class func fetchRequest() -> NSFetchRequest<TaskMO> {
        return NSFetchRequest<TaskMO>(entityName: "TaskMO")
    }

    @NSManaged var id: UUID?
    @NSManaged var isCompleted: Bool
    @NSManaged var order: Int64
    @NSManaged var title: String?
    @NSManaged var information: String?
    @NSManaged var list: ListMO?
}

extension TaskMO: Identifiable {}
