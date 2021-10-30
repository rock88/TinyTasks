import DI
import Lists

final class DemoListsManagerAssembly: Assembly {
    lazy var listsAssembly: ListsAssembly = context.assembly()

    var demoListsManager: DemoListsManager {
        return define(init: DemoListsManagerIml(assembly: listsAssembly))
    }
}

protocol DemoListsManager {
    func addDemoListsOnFirstAppLaunch()
}

private struct DemoListsManagerIml: DemoListsManager {
    let assembly: ListsAssembly

    func addDemoListsOnFirstAppLaunch() {
        if UserDefaults.standard.bool(forKey: "not_first_app_launch") {
            return
        }

        UserDefaults.standard.set(true, forKey: "not_first_app_launch")

        let listsCoordinator = assembly.listsCoordinator
        let demoList = listsCoordinator.addList(title: "Demo")
        let demoTasksCoordinator = assembly.tasksCoordinator(list: demoList)
        let demoTask = demoTasksCoordinator.addTask(title: "Make demo list", information: "Just demo list with one demo task")
        demoTasksCoordinator.update(isCompleted: true, task: demoTask)

        let shoppingList = listsCoordinator.addList(title: "Shopping List")
        let shoppingListCoordinator = assembly.tasksCoordinator(list: shoppingList)
        shoppingListCoordinator.addTask(title: "Orange Juice", information: "Two bottles")
        shoppingListCoordinator.addTask(title: "Apples", information: "1kg")
        shoppingListCoordinator.addTask(title: "Cheese", information: "Parmesan")
        shoppingListCoordinator.addTask(title: "Eggs", information: "One pack")
        shoppingListCoordinator.addTask(title: "Bread", information: nil)
        shoppingListCoordinator.addTask(title: "Milk", information: nil)
    }
}
