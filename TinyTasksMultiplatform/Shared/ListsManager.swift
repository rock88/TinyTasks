import Combine
import Lists
import SwiftUI

typealias ListItem = Lists.List

final class ListsManager: ObservableObject {
    private let listsCoordinator: ListsCoordinator

    @Published var lists: [ListItem] = []

    var cancellable: Cancellable?

    init(listsCoordinator: ListsCoordinator) {
        self.listsCoordinator = listsCoordinator

        cancellable = listsCoordinator
            .subscribe()
            .assign(to: \.lists, on: self)
    }

    func addList(title: String) {
        listsCoordinator.addList(title: title)
    }

    func update(title: String, list: ListItem) {
        listsCoordinator.update(title: title, list: list)
    }

    func delete(list: ListItem) {
        listsCoordinator.delete(list: list)
    }

    func move(source: IndexSet, destination: Int) {
        guard let indices = fixIndices(source: source, destination: destination, items: lists) else {
            return
        }

        listsCoordinator.exchange(list: lists[indices.source], other: lists[indices.destination])
    }
}

func fixIndices<T>(source: IndexSet, destination: Int, items: [T]) -> (source: Int, destination: Int)? {
    let destination = max(0, destination - 1)

    guard source.count == 1, let index = source.first, items.indices.contains(index), items.indices.contains(destination) else {
        return nil
    }

    return (index, destination)
}
