import DI
import Lists
import SwiftUI

@main
final class TinyTasksMultiplatformApp: App {
    lazy var context = DIContext()
    lazy var listsAssembly: ListsAssembly = context.assembly()
    lazy var demoListsManagerAssembly: DemoListsManagerAssembly = context.assembly()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ListsManager(listsCoordinator: listsAssembly.listsCoordinator))
                .environmentObject(TasksManagerProvider(listsAssembly: listsAssembly))
                .onAppear {
                    self.demoListsManagerAssembly.demoListsManager.addDemoListsOnFirstAppLaunch()
                }
        }
    }
}

final class TasksManagerProvider: ObservableObject {
    let listsAssembly: ListsAssembly

    init(listsAssembly: ListsAssembly) {
        self.listsAssembly = listsAssembly
    }

    func tasksManager(list: Lists.List) -> TasksManager {
        return TasksManager(tasksCoordinator: listsAssembly.tasksCoordinator(list: list))
    }
}
