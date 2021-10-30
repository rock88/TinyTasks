import DI
import Lists
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var context = DIContext()
    lazy var listsAssembly: ListsAssembly = context.assembly()
    lazy var appAssembly: AppAssembly = context.assembly()
    lazy var demoListsManagerAssembly: DemoListsManagerAssembly = context.assembly()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        demoListsManagerAssembly.demoListsManager.addDemoListsOnFirstAppLaunch()

        let viewController = appAssembly.listsViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
