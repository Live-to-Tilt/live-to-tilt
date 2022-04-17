import CoreGraphics

class GapWave: Wave {
    private(set) var gaps: [CGRect] = []

    init(gapWidths: [CGFloat]) {
        let gaps = gapWidths.map({ CGRect(x: .zero, y: .zero, width: .zero, height: $0) })
        self.gaps = gaps
    }

    func coroutine(nexus: Nexus) {
        generateGaps()
        generateWaves(nexus: nexus)
    }

    private func generateGaps() {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio
        let gapWidths = gaps.map({ $0.height })
        var gaps = [CGRect]()
        for i in 0..<gapWidths.count {
            let gapWidth = gapWidths[i]
            let halfGapWidth = gapWidth / 2
            let partitionStart = CGFloat(Constants.gameArenaHeight) / CGFloat(gapWidths.count) * CGFloat(i)
            let partitionEnd = CGFloat(Constants.gameArenaHeight) / CGFloat(gapWidths.count) * CGFloat(i + 1)
            let gapCenterY = CGFloat.random(in: partitionStart + halfGapWidth...partitionEnd - halfGapWidth)
            let gapMinY = gapCenterY - halfGapWidth
            let gap = CGRect(x: maxX, y: gapMinY, width: .zero, height: gapWidth)
            gaps.append(gap)
        }
        self.gaps = gaps
    }

    private func generateWaves(nexus: Nexus) {
        let maxX = Constants.gameArenaHeight * Constants.gameArenaAspectRatio

        for i in 0..<gaps.count {
            let gap = gaps[i]
            let gapStart = CGPoint(x: maxX, y: gap.minY)
            let gapEnd = CGPoint(x: maxX, y: gap.maxY)
            var topWaveStart: CGPoint

            if i == 0 {
                topWaveStart = CGPoint(x: maxX, y: .zero)
            } else {
                let previousGap = gaps[i - 1]
                topWaveStart = CGPoint(x: maxX, y: previousGap.maxY)
            }

            let topWave = StraightWave(from: topWaveStart, to: gapStart)
            topWave.coroutine(nexus: nexus)

            if i == gaps.count - 1 {
                let bottomWaveEnd = CGPoint(x: maxX, y: Constants.gameArenaHeight)
                let bottomWave = StraightWave(from: gapEnd, to: bottomWaveEnd)
                bottomWave.coroutine(nexus: nexus)
            }
        }
    }
}
