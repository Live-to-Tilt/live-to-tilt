import Foundation

protocol MessageHandlerDelegate: AnyObject {
    func onReceive(data: Data?)
}
