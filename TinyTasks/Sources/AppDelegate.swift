import DI
import Lists
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var context = DIContext()
    lazy var listsAssembly: ListsAssembly = context.assembly()
    lazy var appAssembly: AppAssembly = context.assembly()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        addDemoListIfNeeded()

        let viewController = appAssembly.listsViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

private extension AppDelegate {
    func addDemoListIfNeeded() {
        if UserDefaults.standard.bool(forKey: "not_first_app_launch") {
            return
        }

        UserDefaults.standard.set(true, forKey: "not_first_app_launch")

        let listsCoordinator = listsAssembly.listsCoordinator
        let list = listsCoordinator.addList(title: "Demo")

        let tasksCoordinator = listsAssembly.tasksCoordinator(list: list)
        let last = tasksCoordinator.addTask(title: "Make this list", information: nil)
        tasksCoordinator.update(isCompleted: true, task: last)
        tasksCoordinator.addTask(title: "Demo Task 2", information: "Just demo...")
        tasksCoordinator.addTask(title: "Demo Task 1", information: "Just demo...")
    }
}
