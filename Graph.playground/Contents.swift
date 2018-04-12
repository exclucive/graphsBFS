//: Playground - noun: a place where people can play

import UIKit

class Vertex<T: Hashable>: Hashable {
    let data: T
    let index: Int
    var visited: Bool = false
    
    init(data: T, index: Int) {
        self.data = data
        self.index = index
    }
    
    public var hashValue: Int {
        get {
            return data.hashValue / index
        }
    }
    
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.index == rhs.index
    }
}

struct GraphEdge<T: Hashable> {
    let neighbor: Vertex<T>
    let weight:Double?
    
    init(neighbor: Vertex<T>, weight: Int = 0) {
        self.neighbor = neighbor
        self.weight = 0
    }
}

class Graph <T: Hashable> {
    typealias Node = Vertex<T>
    typealias Edge = GraphEdge<T>

    let directed: Bool
    var list: [Node: [Edge]] = [:]
    
    init(directed: Bool = false) {
        self.directed = directed
    }
    
    public func createNode(_ data: T) -> Node {
        let newNode = Node(data: data, index: list.count + 1)
        list[newNode] = []
        return newNode
    }
    
    public func addEdge(from: Node, to: Node) {
        let fromEdge = Edge(neighbor: to)
        
        let fromEdges = list[from]?.filter{$0.neighbor.index == to.index} 
        if fromEdges?.count == 0 {
            list[from]?.append(fromEdge)
        }
        
        let toEdges = list[to]?.filter{$0.neighbor.index == from.index}
        if !directed && toEdges?.count == 0 {            
            let toEdge = Edge(neighbor: from)
            list[to]?.append(toEdge)
        }
    }

    public func bfs(node: Node) -> [T] {
        var result:[T] = [] 
        var queue = Queue<Node>()
        var visited:[Node: Node] = [:] 
        visited[node] = node
        result.append(node.data)
        queue.enqueue(node)
        
        while let currentNode = queue.dequeue() {
            let edges = list[currentNode]!
            for edge in edges {
                if visited[edge.neighbor] == nil {
                    visited[edge.neighbor] = edge.neighbor
                    queue.enqueue(edge.neighbor)
                    result.append(edge.neighbor.data)
                }
            }
        }
        
        return result
    }
}

extension Graph: CustomStringConvertible {
    var description: String {
        var resultStr = ""
        
        for node in list.keys {
            resultStr += "\(node.data): "
            list[node]?.map{resultStr += "\($0.neighbor.data),"}
            resultStr = resultStr.dropLast() + "\n"
        }
        
        return resultStr
    }
}

let graph = Graph<String>(directed: false)
let a = graph.createNode("A")
let b = graph.createNode("B")
let c = graph.createNode("C")
let d = graph.createNode("D")
let f = graph.createNode("F")
let g = graph.createNode("G")
let h = graph.createNode("H")

graph.addEdge(from: a, to: b)
graph.addEdge(from: a, to: c)
graph.addEdge(from: c, to: g)
graph.addEdge(from: c, to: h)
graph.addEdge(from: b, to: d)
graph.addEdge(from: b, to: f)

print(graph.bfs(node: a))
