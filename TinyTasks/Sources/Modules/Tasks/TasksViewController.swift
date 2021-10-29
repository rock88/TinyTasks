import Lists
import UIKit

final class TasksViewController: UITableViewController {
    lazy var tableViewHelper = TableViewHelper<Task>(tableView: tableView, delegate: self)
    lazy var navigationItemsHelper = NavigationItemsHelper(navigationItem: navigationItem)

    var controller: TasksController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationItems()

        controller?.moduleDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let task = tableViewHelper.item(at: indexPath) else { return }

        if tableView.isEditing {
            controller?.moduleDidEdit(task: task)
        } else {
            controller?.moduleDidSelect(task: task)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let task = tableViewHelper.item(at: indexPath) {
            controller?.moduleDidDelete(task: task)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let task = tableViewHelper.item(at: sourceIndexPath), let other = tableViewHelper.item(at: destinationIndexPath) {
            controller?.moduleDidExchange(task: task, other: other)
        }
    }
}

extension TasksViewController: TasksModule {
    func update(items: [Task]) {
        showPlaceholderIfEmpty(text: "No tasks here...\nPress + to add a new one!", items: items)
        tableViewHelper.update(items: items, animated: view.window != nil)
    }
}

private extension TasksViewController {
    func setupNavigationItems() {
        navigationItemsHelper.setAddAction { [weak self] _ in
            self?.controller?.moduleDidTapAddTask()
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
        tableViewHelper.setConfigurationHandler { cell, task in
            if task.isCompleted {
                cell.imageView?.image = UIImage(systemName: "checkmark.circle")
                cell.imageView?.tintColor = .systemGreen
                cell.textLabel?.attributedText = task.title.strikethrough(color: .gray)
                cell.detailTextLabel?.attributedText = task.information?.strikethrough(color: .lightGray)
            } else {
                cell.imageView?.image = UIImage(systemName: "circle")
                cell.imageView?.tintColor = .lightGray
                cell.textLabel?.attributedText = NSAttributedString(string: task.title)
                cell.detailTextLabel?.attributedText = task.information.map { NSAttributedString(string: $0) }
            }
        }
    }
}

private extension String {
    func strikethrough(color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [
            .foregroundColor: color,
            .strikethroughStyle: 1
        ])
    }
}
