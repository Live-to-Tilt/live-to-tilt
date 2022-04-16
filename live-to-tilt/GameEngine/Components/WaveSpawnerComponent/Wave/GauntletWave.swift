import CoreGraphics

class GauntletWave: Wave {
    private(set) var gapCenter: CGPoint = .zero

    func coroutine(nexus: Nexus) {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio

        let halfGap = Constants.gauntletStraightWaveGap / 2
        let gapCenterY = CGFloat.random(in: halfGap...Constants.gameArenaHeight - halfGap)
        let gapCenter = CGPoint(x: maxX, y: gapCenterY)
        let gapStart = CGPoint(x: maxX, y: gapCenter.y - halfGap)
        let gapEnd = CGPoint(x: maxX, y: gapCenter.y + halfGap)

        let topWaveStart = CGPoint(x: maxX, y: 0)
        let bottomWaveEnd = CGPoint(x: maxX, y: Constants.gameArenaHeight)

        let topWave = StraightWave(from: topWaveStart, to: gapStart)
        let bottomWave = StraightWave(from: gapEnd, to: bottomWaveEnd)

        topWave.coroutine(nexus: nexus)
        bottomWave.coroutine(nexus: nexus)
        self.gapCenter = gapCenter
    }
}
