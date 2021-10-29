import UIKit

protocol EmptyItemsPlaceholder {
    func showPlaceholderIfEmpty<T>(text: String, items: [T])
}

extension UITableViewController: EmptyItemsPlaceholder {
    func showPlaceholderIfEmpty<T>(text: String, items: [T]) {
        if items.isEmpty {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.textColor = .gray
            label.numberOfLines = 0
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
}
