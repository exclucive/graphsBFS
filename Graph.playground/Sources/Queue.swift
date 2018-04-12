import Foundation

public class Queue<T> {
    private var elements:[T] = []
    public init(){}
    
    public func enqueue(_ element: T) {
        elements.insert(element, at: 0)
    }
    
    public func dequeue() -> T? {
        return elements.popLast()
    }
}
