import UIKit

final class TableViewHelper<Item: Hashable> {
    typealias ConfigurateHandler = (UITableViewCell, Item) -> Void

    private var diffableDataSource: TableViewDiffableDataSource<Int, Item>?
    private var configurationHandler: ConfigurateHandler?

    init(tableView: UITableView, delegate: UITableViewDataSource & UITableViewDelegate) {
        tableView.allowsSelectionDuringEditing = true

        diffableDataSource = TableViewDiffableDataSource(tableView: tableView) { [weak self] tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = .gray
            self?.configurationHandler?(cell, item)
            return cell
        }
        diffableDataSource?.defaultRowAnimation = .fade
        diffableDataSource?.proxyDelegate = delegate
    }

    func setConfigurationHandler(handler: @escaping (UITableViewCell, Item) -> Void) {
        configurationHandler = handler
    }

    func update(items: [Item], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        diffableDataSource?.apply(snapshot, animatingDifferences: animated)
    }

    func item(at indexPath: IndexPath) -> Item? {
        return diffableDataSource?.itemIdentifier(for: indexPath)
    }
}

private final class TableViewDiffableDataSource<Section: Hashable, Item: Hashable>: UITableViewDiffableDataSource<Section, Item> {
    weak var proxyDelegate: (UITableViewDataSource & UITableViewDelegate)?

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return proxyDelegate?.tableView?(tableView, canEditRowAt: indexPath) ?? true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        proxyDelegate?.tableView?(tableView, commit: editingStyle, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return proxyDelegate?.tableView?(tableView, canMoveRowAt: indexPath) ?? true
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        proxyDelegate?.tableView?(tableView, moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
}
