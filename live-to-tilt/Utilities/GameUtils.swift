import CoreGraphics

struct GameUtils {
    static func generateRandomSpawnPosition(forEntityOfWidth width: CGFloat, height: CGFloat) -> CGPoint {
        let minX = width / 2
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio - minX
        let x = CGFloat.random(in: minX...maxX)

        let minY = height / 2
        let maxY = Constants.gameArenaHeight - minY
        let y = CGFloat.random(in: minY...maxY)

        let position = CGPoint(x: x, y: y)

        return position
    }
}
