struct Grid<Element> {
    fileprivate(set) var data: [Element]
    fileprivate(set) var width: Int
    fileprivate(set) var height: Int

    subscript (_ x: Int, _ y: Int) -> Element {
        get {
            let idx = y * width + x
            return data[idx]
        }
        set(newValue) {
            let idx = y * width + x
            data[idx] = newValue
        }
    }

    subscript (_ p: (Int, Int)) -> Element {
        get { return self[p.0, p.1] }
        set { self[p.0, p.1] = newValue }
    }

    fileprivate init(width: Int, height: Int, data: [Element]) {
        self.width = width
        self.height = height
        self.data = data
    }

    init(width: Int, height: Int, fill: Element) {
        self.data = Array(repeating: fill, count: width * height)
        self.width = width
        self.height = height
    }

    init(rowMajor: [[Element]]) {
        if rowMajor.isEmpty {
            self.width = 0
        } else {
            let width = rowMajor[0].count
            assert(rowMajor.allSatisfy { $0.count == width })
            self.width = width
        }
        self.height = rowMajor.count
        self.data = rowMajor.reduce([], +)
    }

    func contains(x: Int, y: Int) -> Bool {
        0 <= x && x < self.width && 0 <= y && y < self.height
    }

    func contains(pos: (Int, Int)) -> Bool {
        let (x, y) = pos
        return self.contains(x: x, y: y)
    }

    struct IndexIterator : IteratorProtocol, Sequence {
        fileprivate var x: Int
        fileprivate var y: Int
        fileprivate let width: Int
        fileprivate let height: Int

        mutating func next() -> (Int, Int)? {
            if self.y == self.width { return nil }
            let result = (self.x, self.y)

            self.x += 1

            if self.x == self.width {
                self.x = 0
                self.y += 1
            }

            return result
        }
    }

    func indices() -> IndexIterator {
        return IndexIterator(x: 0, y: 0, width: self.width, height: self.height)
    }

    struct GridCellIterator : IteratorProtocol, Sequence {
        fileprivate var grid: Array<Element>.Iterator
        fileprivate var indices: IndexIterator

        mutating func next() -> (Int, Int, Element)? {
            guard let (x, y) = self.indices.next() else {
                return nil
            }

            return (x, y, self.grid.next()!)
        }
    }

    func cells() -> GridCellIterator {
        return GridCellIterator(grid: self.data.makeIterator(), indices: self.indices())
    }

    func map<NewElement>(withIndex: (Int, Int, Element) throws -> NewElement) rethrows -> Grid<NewElement> {
        var indices = self.indices();
        let newData = try self.data.map {
            let index = indices.next()!
            return try withIndex(index.0, index.1, $0)
        }
        return Grid<NewElement>(width: width, height: height, data: newData)
    }

    func map<NewElement>(transform: (Element) throws -> NewElement) rethrows -> Grid<NewElement> {
        let newData = try self.data.map {
            return try transform($0)
        }
        return Grid<NewElement>(width: width, height: height, data: newData)
    }
}

extension Grid {
    subscript(_ p: Vector2) -> Element {
        get { self[p.x, p.y] }
        set { self[p.x, p.y] = newValue }
    }

    func contains(vec2: Vector2) -> Bool {
        self.contains(x: vec2.x, y: vec2.y)
    }
}

extension Grid where Element : CustomStringConvertible {
    func prettyPrint(separator: String = "") {

        for y in 0..<self.height {
            for x in 0..<self.width {
                print(self[x, y], terminator: "")
                if x < self.width - 1 {
                    print(separator, terminator: "")
                }
            }
            print()
        }
    }
}

extension Grid {
    func prettyPrint(separator: String = "", fmt: (Element)->String) {

        for y in 0..<self.height {
            for x in 0..<self.width {
                print(fmt(self[x, y]), terminator: "")
                if x < self.width - 1 {
                    print(separator, terminator: "")
                }
            }
            print()
        }
    }
}