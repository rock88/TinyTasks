import SwiftUI

struct ListsView: View {
    @EnvironmentObject var listsManager: ListsManager
    @EnvironmentObject var tasksManagerProvider: TasksManagerProvider

    @State private var showCreateListSheet = false
    @State private var showEditListSheet = false
    @State private var currentList: ListItem?

    var body: some View {
        if listsManager.lists.isEmpty {
            Text("No lists here...\nPress + to add a new one!")
                .multilineTextAlignment(.center)
                .frame(minWidth: 300)
                .bind(createListContext)
        } else {
            List {
                ForEach(listsManager.lists, id: \.self) { list in
                    NavigationLink(destination: TasksView(list: list).environmentObject(tasksManagerProvider.tasksManager(list: list))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(list.title).bold()
                                HStack {
                                    Text(list.createDate, style: .date)
                                    Text(list.createDate, style: .time)
                                }
                            }
                            Spacer()
                            Button(
                                action: {
                                    currentList = list
                                    showEditListSheet.toggle()
                                },
                                label: { Image(systemName: "pencil") }
                            )
                            Button(
                                action: { withAnimation { self.listsManager.delete(list: list) } },
                                label: { Image(systemName: "trash") }
                            )
                        }
                    }.transition(.opacity)
                }
                .onMove { listsManager.move(source: $0, destination: $1) }
            }
            .frame(minWidth: 300)
            .bind(createListContext)
            .bind(editListContext)
        }
    }
}

private extension ListsView {
    var createListContext: CreateListContext {
        return CreateListContext(
            showCreateListSheet: $showCreateListSheet,
            createListAction: { listsManager.addList(title: $0) }
        )
    }

    var editListContext: EditListContext {
        return EditListContext(
            currentList: currentList,
            showEditListSheet: $showEditListSheet,
            editListAction: { title in
                if let list = currentList {
                    listsManager.update(title: title, list: list)
                }
                currentList = nil
            }
        )
    }
}

private struct CreateListContext {
    let showCreateListSheet: Binding<Bool>
    let createListAction: (String) -> Void
}

private struct EditListContext {
    @State var currentList: ListItem?
    let showEditListSheet: Binding<Bool>
    let editListAction: (String) -> Void
}

private extension View {
    func bind(_ context: CreateListContext) -> some View {
        return toolbar {
            Button(action: { context.showCreateListSheet.wrappedValue.toggle() }, label: { Image(systemName: "plus") })
        }
        .oneTextFieldSheet(
            isShowing: context.showCreateListSheet,
            title: "Create a new List",
            placeholder: "Title",
            action: "Create",
            handler: context.createListAction
        )
    }

    func bind(_ context: EditListContext) -> some View {
        return oneTextFieldSheet(
            isShowing: context.showEditListSheet,
            title: "Rename List",
            placeholder: "Title",
            text: context.currentList?.title,
            action: "Rename",
            handler: context.editListAction
        )
    }
}
