import UIKit

struct EditListAlertContext {
    let title: String
    let placeholder: String
    let text: String?
    let action: String
    let completion: (String) -> Void
}

protocol EditListAlertPresenter {
    func presentEditListAlert(context: EditListAlertContext)
}

extension EditListAlertPresenter where Self: UIViewController {
    func presentEditListAlert(context: EditListAlertContext) {
        let alert = UIAlertController(title: context.title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = context.placeholder
            textField.text = context.text
            textField.autocapitalizationType = .words
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: context.action, style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty {
                context.completion(text)
            }
        }))
        present(alert, animated: true)
    }
}
