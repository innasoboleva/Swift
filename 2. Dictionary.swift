//
//  Dictionary.swift
//  
//
//  Created by Inna Soboleva on 3/23/18.
//

struct DictNode<K: Hashable, V> {
    var data: [(key: K, value: V)] = []
    
    func getValue(key: K) -> V? {
        return data.first(where: {$0.key == key})?.value
    }
    
    mutating func removeValue(key: K) {
        data = data.filter{$0.key != key}
    }
}

class Dict<K: Hashable, V> {
    private var array = Array(repeating: DictNode<K,V>(), count: 8) // power of 2
    
    private var maximumFactor = 0.7 // any number from 0.1 to 1, better to use about 60-70%
    
    private var size: Int {
        return array.count
    }
    
    private func remove(key: K) {
        let position = abs(key.hashValue) % array.count
        array[position].removeValue(key: key)
    }
    
    var count: Int {
        return array.flatMap({$0.data}).count
    }
    
    var currentFactor: Double {
        return Double(count) / Double(size)
    }
    
    func changeArraySize() {
        if currentFactor > maximumFactor {
            let oldDictionary = self
            self.array = Array<DictNode<K, V>>(repeating: DictNode<K, V>(), count: size*2)
            for (key, value) in oldDictionary {
                self[key] = value
            }
        }
    }
    
    subscript(key: K) -> V? {
        set(newValue) {
            if let value = newValue {
                remove(key: key)
                let position = abs(key.hashValue) % array.count
                array[position].data.append((key:key, value:value))
                changeArraySize()
            } else {
                remove(key: key)
            }
        }
        get {
            let position = abs(key.hashValue) % array.count
            return array[position].getValue(key: key)
        }
    }
}

extension Dict: Sequence {
    
    typealias Iterator = AnyIterator<(K, V)>
    
    func makeIterator() -> Dict.Iterator {
        var arrIterator = array.makeIterator()
        var currentIterator: AnyIterator<(key: K, value: V)>?
        return AnyIterator{
            if let next = currentIterator?.next() {
                return next
            }
            var nextNode = arrIterator.next()
            while nextNode != nil {
                currentIterator = AnyIterator(nextNode!.data.makeIterator())
                if let next = currentIterator?.next() {
                    return next
                } else {
                    nextNode = arrIterator.next()
                }
            }
            return currentIterator?.next()
        }
    }
}
