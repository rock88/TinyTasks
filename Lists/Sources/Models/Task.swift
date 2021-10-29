import Foundation

public struct Task: Hashable {
    let model: TaskMO

    public let title: String
    public let information: String?
    public let isCompleted: Bool

    init(model: TaskMO) {
        self.model = model
        title = model.title ?? ""
        information = model.information
        isCompleted = model.isCompleted
    }
}
