import CoreData

protocol IncrementCounter {
    func incrementIndex<T: NSManagedObject>(for type: T.Type) -> Int64
}

final class IncrementCounterImpl {
    let userDefaults: UserDefaults = .standard
}

extension IncrementCounterImpl: IncrementCounter {
    func incrementIndex<T: NSManagedObject>(for type: T.Type) -> Int64 {
        let key = "increment_index_\(T.self)"
        let index = (userDefaults.object(forKey: key) as? NSNumber) ?? NSNumber(value: 0)
        userDefaults.setValue(NSNumber(value: index.int64Value + 1), forKey: key)
        userDefaults.synchronize()
        return index.int64Value + 1
    }
}
