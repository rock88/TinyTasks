import Foundation

public struct List: Hashable {
    let model: ListMO

    public let title: String
    public let createDate: Date

    init(model: ListMO) {
        self.model = model
        title = model.title ?? ""
        createDate = model.createDate ?? Date()
    }
}
