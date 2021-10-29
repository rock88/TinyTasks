import Combine
import Lists

protocol ListsModule: Module, EditListAlertPresenter {
    func update(items: [List])
}

protocol ListsController {
    func moduleDidLoad()
    func moduleDidTapAddList()
    func moduleDidSelect(list: List)
    func moduleDidEdit(list: List)
    func moduleDidExchange(list: List, other: List)
    func moduleDidDelete(list: List)
}

final class ListsControllerImpl {
    weak var module: ListsModule?
    var listsCoordinator: ListsCoordinator?
    var appRouter: AppRouter?

    var cancellables: Set<AnyCancellable> = []
}

extension ListsControllerImpl: ListsController {
    func moduleDidLoad() {
        listsCoordinator?
            .subscribe()
            .sink { [weak self] items in
                self?.module?.update(items: items)
            }
            .store(in: &cancellables)
    }

    func moduleDidTapAddList() {
        let context = EditListAlertContext(
            title: "Create a new List",
            placeholder: "Title",
            text: nil,
            action: "Create",
            completion: { [weak self] title in
                self?.listsCoordinator?.addList(title: title)
            }
        )
        module?.presentEditListAlert(context: context)
    }

    func moduleDidSelect(list: List) {
        if let module = module {
            appRouter?.openTasks(from: module, list: list)
        }
    }

    func moduleDidEdit(list: List) {
        let context = EditListAlertContext(
            title: "Rename List",
            placeholder: "Title",
            text: list.title,
            action: "Rename",
            completion: { [weak self] title in
                self?.listsCoordinator?.update(title: title, list: list)
            }
        )
        module?.presentEditListAlert(context: context)
    }

    func moduleDidExchange(list: List, other: List) {
        listsCoordinator?.exchange(list: list, other: other)
    }

    func moduleDidDelete(list: List) {
        listsCoordinator?.delete(list: list)
    }
}
