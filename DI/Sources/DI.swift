import Foundation

public final class DIContext {
    var singletons: [String: Any] = [:]

    public init() {}

    public func assembly<T: Assembly>() -> T {
        return T(context: self)
    }
}

open class Assembly {
    public enum Scope {
        case prototype
        case singleton
    }

    public let context: DIContext

    public required init(context: DIContext) {
        self.context = context
    }

    public func define<Input, Output>(
        key: String = #function,
        scope: Scope = .prototype,
        init initiialize: @autoclosure () -> Input,
        inject: ((Input) -> Void)? = nil
    ) -> Output {
        let key = "\(type(of: self))-\(key)-\(Input.self)-\(Output.self)"

        if scope == .singleton, let instance = context.singletons[key] as? Output {
            return instance
        }

        let instance = initiialize()
        inject?(instance)

        if scope == .singleton {
            context.singletons[key] = instance
        }

        if let instance = instance as? Output {
            return instance
        }
        fatalError("Failed cast \(instance) to \(Output.self)...")
    }
}
