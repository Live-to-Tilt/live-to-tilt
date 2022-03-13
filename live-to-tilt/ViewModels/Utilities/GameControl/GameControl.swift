import CoreGraphics
import Foundation

protocol GameControl {
    func start()

    func stop()

    func getInputForce() -> CGVector
}
