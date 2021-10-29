import UIKit

final class EditTaskViewController: UIViewController {
    lazy var navigationItemsHelper = NavigationItemsHelper(navigationItem: navigationItem)

    var controller: EditTaskController?

    lazy var textField = UITextField()
    lazy var textView = UITextView()
    lazy var placeholderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
        setupSubviews()
        setupPlaceholderVisibleUpdate()

        controller?.moduleDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
    }
}

extension EditTaskViewController: EditTaskModule {
    func update(context: EditTaskContext) {
        title = context.title
        textField.text = context.taskTitle
        textView.text = context.taskInformation
        hidePlaceholderLabelIfNeeded()
    }
}

private extension EditTaskViewController {
    func setupNavigationItems() {
        navigationItemsHelper.setupEditActions(animated: false)
        navigationItemsHelper.setDoneAction { [weak self] _ in
            self?.controller?.moduleDidDone(title: self?.textField.text, information: self?.textView.text)
        }
    }

    func setupSubviews() {
        view.backgroundColor = .white

        textField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [.foregroundColor: UIColor.lightGray])
        placeholderLabel.text = "Information"
        placeholderLabel.textColor = .lightGray

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        textField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

        placeholderLabel.font = textField.font
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)

        placeholderLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        placeholderLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

        textView.font = textField.font
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)

        textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16).isActive = true
        textView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func setupPlaceholderVisibleUpdate() {
        textView.delegate = self
    }

    func hidePlaceholderLabelIfNeeded() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension EditTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        hidePlaceholderLabelIfNeeded()
    }
}
