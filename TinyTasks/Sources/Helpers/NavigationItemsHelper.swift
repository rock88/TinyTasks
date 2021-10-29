import UIKit

final class NavigationItemsHelper: NSObject {
    typealias Action = (NavigationItemsHelper) -> Void

    private var actions = Actions()

    let navigationItem: UINavigationItem

    init(navigationItem: UINavigationItem) {
        self.navigationItem = navigationItem
        super.init()
        setupDefaultActions()
    }

    func setupDefaultActions(animated: Bool = true) {
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit)),
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
            ],
            animated: animated
        )
    }

    func setupEditActions(animated: Bool = true) {
        navigationItem.setRightBarButtonItems(
            [
                UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
            ],
            animated: animated
        )
    }

    func setAddAction(handler: @escaping Action) {
        actions.add = handler
    }

    func setEditAction(handler: @escaping Action) {
        actions.edit = handler
    }

    func setDoneAction(handler: @escaping Action) {
        actions.done = handler
    }
}

private extension NavigationItemsHelper {
    struct Actions {
        var add: Action?
        var edit: Action?
        var done: Action?
    }

    @objc func handleAdd() {
        actions.add?(self)
    }

    @objc func handleEdit() {
        actions.edit?(self)
    }

    @objc func handleDone() {
        actions.done?(self)
    }
}
