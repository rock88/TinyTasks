import DI
import Lists

final class AppAssembly: Assembly {
    lazy var listsAssembly: ListsAssembly = context.assembly()

    var appRouter: AppRouter {
        return define(scope: .singleton, init: AppRouterImpl(appAssembly: self))
    }

    var listsViewController: UIViewController {
        return define(init: ListsViewController()) {
            $0.controller = self.listsController(module: $0)
        }
    }

    func listsController(module: ListsModule) -> ListsController {
        return define(init: ListsControllerImpl()) {
            $0.module = module
            $0.listsCoordinator = self.listsAssembly.listsCoordinator
            $0.appRouter = self.appRouter
        }
    }

    func tasksViewController(list: List) -> UIViewController {
        return define(init: TasksViewController()) {
            $0.title = list.title
            $0.controller = self.tasksController(module: $0, list: list)
        }
    }

    func tasksController(module: TasksModule, list: List) -> TasksController {
        return define(init: TasksControllerImpl()) {
            $0.module = module
            $0.tasksCoordinator = self.listsAssembly.tasksCoordinator(list: list)
            $0.appRouter = self.appRouter
        }
    }

    func editTaskViewController(context: EditTaskContext) -> UIViewController {
        return define(init: EditTaskViewController()) {
            $0.controller = self.editTaskController(module: $0, context: context)
        }
    }

    func editTaskController(module: EditTaskModule, context: EditTaskContext) -> EditTaskController {
        return define(init: EditTaskControllerImpl(context: context)) {
            $0.module = module
        }
    }
}
