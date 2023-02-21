fileprivate indirect enum FSNode {
    case file(name: String, size: Int)
    case directory(name: String, content: [FSNode]?)

    var name: String {
        switch self {
            case .file(let name, _), .directory(let name, _): return name
        }
    }

    func prettyPrint(indent: Int = 0) {
        switch self {
        case .file(let name, let size):
            print("\(String(repeating: "\t", count: indent))File: \(name) \(size)")
        case .directory(let name, let content):
            if let content {
                print("\(String(repeating: "\t", count: indent))Dir: \(name)")
                for entry in content {
                    entry.prettyPrint(indent: indent + 1)
                }
            } else {
                print("\(String(repeating: "\t", count: indent))Dir: \(name) <empty>")
            }
        }
    }
}

fileprivate func parseInput(_ str: String) -> FSNode {
    let lines = str.split(separator: "\n")

    var folderStack: [(name: String, content: Array<FSNode>?)] = []

    let backtrack = {
        let leavingFolder = folderStack.popLast()!
        assert(leavingFolder.content != nil)
        assert(!folderStack.isEmpty)
        let newCurrentFolder = folderStack[folderStack.count - 1]
        for j in 0..<newCurrentFolder.content!.count {
            switch newCurrentFolder.content![j] {
                case .directory(let name, let content) where name == leavingFolder.name:
                    assert(content == nil)
                    folderStack[folderStack.count - 1].content![j] = .directory(name: name, content: leavingFolder.content)
                default: continue
            }
        }
    }

    var lineIdx = 0
    while lineIdx < lines.count {

        let line = lines[lineIdx];

        assert(line.starts(with: "$"))

        let strippedDollar = line.trimmingPrefix("$ ")

        if strippedDollar.starts(with: "cd") {
            let parts = strippedDollar.split(separator: " ");
            let folder = parts[1]

            if folder == ".." {
                backtrack()
            }else{
                folderStack.append((name: String(folder), content: nil))
            }

        } else if strippedDollar.starts(with: "ls") {
            assert(folderStack.last!.content == nil)

            var directoryContent: [FSNode] = []

            while (true) {
                lineIdx += 1
                guard lineIdx < lines.count else { break }
                let contentLine = lines[lineIdx]
                let entryParts = contentLine.split(separator: " ")
                let firstPart = entryParts[0]
                let namePart = entryParts[1]

                if firstPart == "dir" {
                    directoryContent.append(.directory(name: String(namePart), content: nil))
                } else if let size = Int(firstPart) {
                    directoryContent.append(.file(name: String(namePart), size: size))
                } else {
                    assert(firstPart.starts(with: "$"))
                    lineIdx -= 1
                    break
                }
            }
            folderStack[folderStack.count - 1].content = directoryContent

        } else {
            assert(false, "Invalid command '\(strippedDollar)'")
        }

        lineIdx += 1
    }

    while folderStack.count > 1 {
        backtrack()
    }

    assert(folderStack.count == 1)
    let root = folderStack[0]
    return .directory(name: root.name, content: root.content)
}

fileprivate func largeDirectorySum(node: FSNode, runningSum: inout Int, maxDirectorySize: Int = 100_000) -> Int {
    switch node {
    case .file(_, let size):
        return size
    case .directory(_, let content):
        if let content {
            let size = content.map { largeDirectorySum(node: $0, runningSum: &runningSum) }.reduce(0, {$0 + $1});
            if size <= maxDirectorySize {
                runningSum += size
            }
            return size
        } else {
            return 0
        }
    }
}

func day07_part1_solve(str: String) throws -> String {
    let fs = parseInput(str)
    //fs.prettyPrint()
    var result = 0;
    let _ = largeDirectorySum(node: fs, runningSum: &result)
    return String(result)
}

fileprivate func largeDirectorySum2(node: FSNode, directorySizes: inout [Int]) -> Int {
    switch node {
    case .file(_, let size):
        return size
    case .directory(_, let content):
        if let content {
            let size = content.map { largeDirectorySum2(node: $0, directorySizes: &directorySizes) }.reduce(0, {$0 + $1});
            directorySizes.append(size)
            return size
        } else {
            return 0
        }
    }
}

func day07_part2_solve(str: String) throws -> String {
    let fs = parseInput(str)
    //fs.prettyPrint()
    var directorySizes: [Int] = []
    let totalSize = largeDirectorySum2(node: fs, directorySizes: &directorySizes)
    let freeSpace = 70000000 - totalSize
    let neededSpace = 30000000 - freeSpace

    if neededSpace > 0 {
        directorySizes.sort()

        for directorySize in directorySizes {
            if directorySize >= neededSpace {
                return String(directorySize)
            }
        }
    } 

    assert(false, "Either no space needed or impossible to satisfy")
}