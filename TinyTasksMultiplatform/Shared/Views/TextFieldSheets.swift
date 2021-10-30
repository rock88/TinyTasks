import SwiftUI

private struct TextFieldSheetButtons: View {
    @Environment(\.presentationMode) var presentationMode

    let action: String
    let handler: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: { hideSheet(performHandler: false) }, label: { Text("Cancel") })
            Spacer(minLength: 16)
            Button(action: { hideSheet(performHandler: true) }, label: { Text(action).bold() })
            Spacer()
        }
    }

    func hideSheet(performHandler: Bool) {
        presentationMode.wrappedValue.dismiss()

        #if os(OSX)
            NSApp.mainWindow?.endSheet(NSApp.keyWindow!)
        #endif

        if performHandler {
            handler()
        }
    }
}

private struct OneTextFieldSheetContent: View {
    @Binding var isShowing: Bool
    @State var text: String

    let title: String
    let placeholder: String
    let action: String
    let handler: (String) -> Void

    var body: some View {
        VStack {
            Text(self.title)
            TextField(self.placeholder, text: $text)
            Spacer()
            TextFieldSheetButtons(action: action, handler: {
                if let text = text.nonEmpty {
                    handler(text)
                }
            })
        }
        .padding()
    }
}

private struct TwoTextFieldSheetContent: View {
    @Binding var isShowing: Bool
    @State var firstText: String
    @State var secondText: String

    let title: String
    let firstPlaceholder: String
    let secondPlaceholder: String
    let action: String
    let handler: (String, String?) -> Void

    var body: some View {
        VStack {
            Text(self.title)
            TextField(self.firstPlaceholder, text: $firstText)
            TextField(self.secondPlaceholder, text: $secondText)
            Spacer()
            TextFieldSheetButtons(action: action, handler: {
                if let text = firstText.nonEmpty {
                    handler(text, secondText.nonEmpty)
                }
            })
        }
        .padding()
    }
}

private extension String {
    var nonEmpty: String? {
        let string = trimmingCharacters(in: .whitespaces)
        return string.isEmpty ? nil : string
    }
}

extension View {
    func oneTextFieldSheet(
        isShowing: Binding<Bool>,
        title: String,
        placeholder: String,
        text: String? = nil,
        action: String,
        handler: @escaping (String) -> Void
    ) -> some View {
        return sheet(isPresented: isShowing) {
            OneTextFieldSheetContent(
                isShowing: isShowing,
                text: text ?? "",
                title: title,
                placeholder: placeholder,
                action: action,
                handler: handler
            )
        }
    }

    // swiftlint:disable:next function_parameter_count
    func twoTextFieldSheet(
        isShowing: Binding<Bool>,
        title: String,
        firstPlaceholder: String,
        firstText: String? = nil,
        secondPlaceholder: String,
        secondText: String? = nil,
        action: String,
        handler: @escaping (String, String?) -> Void
    ) -> some View {
        return sheet(isPresented: isShowing) {
            TwoTextFieldSheetContent(
                isShowing: isShowing,
                firstText: firstText ?? "",
                secondText: secondText ?? "",
                title: title,
                firstPlaceholder: firstPlaceholder,
                secondPlaceholder: secondPlaceholder,
                action: action,
                handler: handler
            )
        }
    }
}
