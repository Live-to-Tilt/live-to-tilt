import Foundation

protocol MessageDelegate: AnyObject {
    func onReceive(data: Data)
}
