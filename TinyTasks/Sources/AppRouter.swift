import Lists
import UIKit

protocol Module: UIViewController {}

protocol AppRouter {
    func openTasks(from module: Module, list: List)
    func openEditTask(from module: Module, context: EditTaskContext)
}

final class AppRouterImpl {
    let appAssembly: AppAssembly

    init(appAssembly: AppAssembly) {
        self.appAssembly = appAssembly
    }
}

extension AppRouterImpl: AppRouter {
    func openTasks(from module: Module, list: List) {
        let tasksViewController = appAssembly.tasksViewController(list: list)
        module.present(UINavigationController(rootViewController: tasksViewController), animated: true)
    }

    func openEditTask(from module: Module, context: EditTaskContext) {
        let editTaskViewController = appAssembly.editTaskViewController(context: context)
        module.present(UINavigationController(rootViewController: editTaskViewController), animated: true)
    }
}
