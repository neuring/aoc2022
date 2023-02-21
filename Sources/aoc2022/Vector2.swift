struct Vector2 : Equatable, AdditiveArithmetic, Hashable {
    let x: Int
    let y: Int

    static let zero: Vector2 = Vector2(x: 0, y: 0)

    static prefix func + (_ self: Vector2) -> Vector2 {
        self
    }

    static func + (_ left: Vector2, _ right: Vector2) -> Vector2 {
        Vector2(x: left.x + right.x, y: left.y + right.y)
    }

    static func += (_ self: inout Vector2, _ other: Vector2) {
        self = self + other
    }

    static prefix func - (_ self: Vector2) -> Vector2 {
        Vector2(x: -self.x, y: -self.y)
    }

    static func - (_ left: Vector2, _ right: Vector2) -> Vector2 {
        Vector2(x: left.x - right.x, y: left.y - right.y)
    }

    static func -= (_ self: inout Vector2, _ other: Vector2) {
        self = self - other
    }

    static func * (_ left: Vector2, _ right: Int) -> Vector2 {
        Vector2(x: left.x * right, y: left.y * right)
    }

    static func * (_ left: Int, _ right: Vector2) -> Vector2 {
        Vector2(x: right.x * left, y: right.y * left)
    }

    var euclidDistance: Double {
        Double(self.x * self.x + self.y * self.y).squareRoot()
    }

    static func euclidDistanceBetween(_ p0: Vector2, _ p1: Vector2) -> Double {
        (p0 - p1).euclidDistance
    }

    var manhattenDistance : Int {
        Swift.abs(self.x) + Swift.abs(self.y)
    }

    static func manhattenDistanceBetween(_ p0: Vector2, _ p1: Vector2) -> Int {
        (p0 - p1).manhattenDistance
    }

    func abs() -> Vector2 {
        return Vector2(x: Swift.abs(self.x), y: Swift.abs(self.y))
    }

    func signum() -> Vector2 {
        return Vector2(x: self.x.signum(), y: self.y.signum())
    }

}