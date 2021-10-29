import UIKit

protocol EditTaskModule: Module {
    func update(context: EditTaskContext)
}

protocol EditTaskController {
    func moduleDidLoad()
    func moduleDidDone(title: String?, information: String?)
}

struct EditTaskContext {
    let title: String
    let taskTitle: String?
    let taskInformation: String?
    let completion: (String, String?) -> Void
}

final class EditTaskControllerImpl {
    let context: EditTaskContext

    weak var module: EditTaskModule?

    init(context: EditTaskContext) {
        self.context = context
    }
}

extension EditTaskControllerImpl: EditTaskController {
    func moduleDidLoad() {
        module?.update(context: context)
    }

    func moduleDidDone(title: String?, information: String?) {
        if let title = title ?? context.taskTitle, !title.isEmpty {
            context.completion(title, information)
        }
        module?.dismiss(animated: true)
    }
}
