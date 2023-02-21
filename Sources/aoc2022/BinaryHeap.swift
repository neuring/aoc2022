struct BinaryHeap<Element, Key> where Key: Comparable {
    var data: [Element]
    let elemToKey: (Element)->Key

    init(withCmpByKey: @escaping (Element)->Key) {
        self.data = []
        self.elemToKey = withCmpByKey
    }

    var count: Int { self.data.count }

    var min: Element? { self.data.first ?? nil }

    static private func leftChildIdx(_ idx: Int) -> Int {
        2 * idx + 1
    }
    static private func rightChildIdx(_ idx: Int) -> Int {
        2 * idx + 2
    }
    static private func parentIdx(_ idx: Int) -> Int {
        idx / 2
    }

    mutating func push(_ element: Element) {
        self.data.append(element)

        var currentIdx = self.data.count - 1
        var parentIdx = Self.parentIdx(currentIdx)

        while parentIdx != currentIdx && self.compareIdxLT(currentIdx, parentIdx) {
            self.data.swapAt(parentIdx, currentIdx)
            currentIdx = parentIdx
            parentIdx = Self.parentIdx(currentIdx)
        }
    }

    mutating func pop() -> Element? {
        switch self.count {
            case 0: return nil
            case 1: return self.data.popLast()
            case _:
                self.data.swapAt(0, self.data.count - 1)
                let minElement = self.data.popLast()

                self.restoreHeap(idx: 0)

                return minElement
        }
    } 

    private func compareIdxLE(_ i: Int, _ j: Int) -> Bool {
        self.elemToKey(self.data[i]) <= self.elemToKey(self.data[j])
    }

    private func compareIdxLT(_ i: Int, _ j: Int) -> Bool {
        self.elemToKey(self.data[i]) < self.elemToKey(self.data[j])
    }

    private mutating func restoreHeap(idx: Int) {
        var currentIdx = idx

        outer: while true {
            let leftChildIdx = Self.leftChildIdx(currentIdx)
            let rightChildIdx = Self.rightChildIdx(currentIdx)

            let smallerChildIdx: Int
            switch (leftChildIdx < self.data.count, rightChildIdx < self.data.count) {
                case (true , true ): smallerChildIdx =  self.compareIdxLE(leftChildIdx, rightChildIdx) ? leftChildIdx : rightChildIdx
                case (true , false): smallerChildIdx = leftChildIdx
                case (false, true ): smallerChildIdx = rightChildIdx
                case (false, false): 
                    break outer
            }

            if self.compareIdxLT(smallerChildIdx, currentIdx) {
                self.data.swapAt(currentIdx, smallerChildIdx)
                currentIdx = smallerChildIdx
            } else {
                break
            }
        }

    }
}

extension BinaryHeap : CustomStringConvertible where Element : CustomStringConvertible {
    var description: String {
        self.data.description
    }
}

extension BinaryHeap where Element == Key, Element: Comparable {
    init() {
        self.data = []
        self.elemToKey = { $0 }
    }
}
