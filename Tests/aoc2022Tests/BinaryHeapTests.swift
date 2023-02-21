import XCTest
import Foundation
@testable import aoc2022

final class BinaryHeapTests: XCTestCase {
    
    func testBasic() {
        var heap: BinaryHeap<Int, _> = BinaryHeap()

        heap.push(5)
        heap.push(3)
        heap.push(4)
        heap.push(1)
        heap.push(2)
        heap.push(0)
        heap.push(4)

        XCTAssertEqual(heap.pop(), 0)
        XCTAssertEqual(heap.pop(), 1)
        XCTAssertEqual(heap.pop(), 2)
        XCTAssertEqual(heap.pop(), 3)
        XCTAssertEqual(heap.pop(), 4)
        XCTAssertEqual(heap.pop(), 4)
        XCTAssertEqual(heap.pop(), 5)
        XCTAssertEqual(heap.pop(), nil)
    }

    func testEmpty() {
        var heap: BinaryHeap<Int, _> = BinaryHeap()
        XCTAssertEqual(heap.pop(), nil)
        XCTAssertEqual(heap.pop(), nil)
    }
}