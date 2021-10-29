import Lists
import UIKit

final class ListsViewController: UITableViewController {
    lazy var tableViewHelper = TableViewHelper<List>(tableView: tableView, delegate: self)
    lazy var navigationItemsHelper = NavigationItemsHelper(navigationItem: navigationItem)

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    var controller: ListsController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tiny Tasks"

        setupTableView()
        setupNavigationItems()

        controller?.moduleDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let list = tableViewHelper.item(at: indexPath) else { return }

        if tableView.isEditing {
            controller?.moduleDidEdit(list: list)
        } else {
            controller?.moduleDidSelect(list: list)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let list = tableViewHelper.item(at: indexPath) {
            controller?.moduleDidDelete(list: list)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let list = tableViewHelper.item(at: sourceIndexPath), let other = tableViewHelper.item(at: destinationIndexPath) {
            controller?.moduleDidExchange(list: list, other: other)
        }
    }
}

extension ListsViewController: ListsModule {
    func update(items: [List]) {
        showPlaceholderIfEmpty(text: "No lists here...\nPress + to add a new one!", items: items)
        tableViewHelper.update(items: items, animated: view.window != nil)
    }
}

private extension ListsViewController {
    func setupNavigationItems() {
        navigationItemsHelper.setAddAction { [weak self] _ in
            self?.controller?.moduleDidTapAddList()
        }
        navigationItemsHelper.setEditAction { [weak self] helper in
            helper.setupEditActions()
            self?.tableView.isEditing = false
            self?.tableView.setEditing(true, animated: true)
        }
        navigationItemsHelper.setDoneAction { [weak self] helper in
            helper.setupDefaultActions()
            self?.tableView.setEditing(false, animated: true)
        }
    }

    func setupTableView() {
        tableViewHelper.setConfigurationHandler { [weak self] cell, list in
            cell.textLabel?.text = list.title
            cell.detailTextLabel?.text = self?.dateFormatter.string(from: list.createDate)
        }
    }
}
