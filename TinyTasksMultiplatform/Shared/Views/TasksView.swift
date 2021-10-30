import SwiftUI

struct TasksView: View {
    let list: ListItem
    @EnvironmentObject var tasksManager: TasksManager

    @State private var showCreateTaskSheet = false
    @State private var showEditTaskSheet = false
    @State private var currentTask: TaskItem?

    var body: some View {
        if tasksManager.tasks.isEmpty {
            Text("No tasks here...\nPress + to add a new one!")
                .multilineTextAlignment(.center)
                .navigationTitle(list.title)
                .bind(createTaskContext)
        } else {
            List {
                ForEach(tasksManager.tasks, id: \.self) { task in
                    HStack {
                        Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                            .configure(isCompleted: task.isCompleted)

                        VStack(alignment: .leading) {
                            Text(task.title).configure(isCompleted: task.isCompleted, isTitle: true)

                            if let information = task.information {
                                Text(information).configure(isCompleted: task.isCompleted, isTitle: false)
                            }
                        }
                        Spacer()
                        Button(
                            action: {
                                currentTask = task
                                showEditTaskSheet.toggle()
                            },
                            label: { Image(systemName: "pencil") }
                        )
                        Button(
                            action: { withAnimation { tasksManager.tasksCoordinator.delete(task: task) } },
                            label: { Image(systemName: "trash") }
                        )
                    }
                    // TODO: Tap conflicting with onMove: Tap works only if tap on some content (image/text),
                    // move works on whole cell except image/text
                    .onTapGesture {
                        tasksManager.update(isCompleted: !task.isCompleted, task: task)
                    }
                }
                .onMove { tasksManager.move(source: $0, destination: $1) }
            }
            .navigationTitle(list.title)
            .bind(createTaskContext)
            .bind(editTaskContext)
        }
    }
}

private extension TasksView {
    var createTaskContext: CreateTaskContext {
        return CreateTaskContext(
            showCreateTaskSheet: $showCreateTaskSheet,
            createTaskAction: { tasksManager.addTask(title: $0, information: $1) }
        )
    }

    var editTaskContext: EditTaskContext {
        return EditTaskContext(
            currentTask: currentTask,
            showEditTaskSheet: $showEditTaskSheet,
            editTaskAction: { title, information in
                if let task = currentTask {
                    tasksManager.update(title: title, information: information, task: task)
                }
                currentTask = nil
            }
        )
    }
}

private struct CreateTaskContext {
    let showCreateTaskSheet: Binding<Bool>
    let createTaskAction: (String, String?) -> Void
}

private struct EditTaskContext {
    @State var currentTask: TaskItem?
    let showEditTaskSheet: Binding<Bool>
    let editTaskAction: (String, String?) -> Void
}

private extension View {
    func bind(_ context: CreateTaskContext) -> some View {
        return toolbar {
            Button(action: { context.showCreateTaskSheet.wrappedValue.toggle() }, label: { Image(systemName: "plus") })
        }
        .twoTextFieldSheet(
            isShowing: context.showCreateTaskSheet,
            title: "Create a new Task",
            firstPlaceholder: "Title",
            secondPlaceholder: "Information",
            action: "Create",
            handler: context.createTaskAction
        )
    }

    func bind(_ context: EditTaskContext) -> some View {
        return twoTextFieldSheet(
            isShowing: context.showEditTaskSheet,
            title: "Edit Task",
            firstPlaceholder: "Title",
            firstText: context.currentTask?.title,
            secondPlaceholder: "Information",
            secondText: context.currentTask?.information,
            action: "Done",
            handler: context.editTaskAction
        )
    }
}

private extension Text {
    func configure(isCompleted: Bool, isTitle: Bool) -> some View {
        if isCompleted, isTitle {
            return bold()
                .foregroundColor(Color.gray)
                .strikethrough()
        } else if isCompleted {
            return foregroundColor(Color.gray.opacity(0.75))
                .strikethrough()
        } else if isTitle {
            return bold()
        }
        return foregroundColor(Color.gray)
    }
}

private extension Image {
    func configure(isCompleted: Bool) -> some View {
        if isCompleted {
            return foregroundColor(.green)
        }
        return foregroundColor(.gray)
    }
}
