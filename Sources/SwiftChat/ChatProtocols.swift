import Foundation
import SwiftUI

/// Message type enumeration for different message content types
public enum MessageType {
    case text
    case image
    case link
}

/// Protocol that chat messages must conform to
public protocol ChatMessageProtocol: Identifiable {
    var id: String { get }
    var content: String { get }
    var type: MessageType { get }
    var sender_id: String { get }
    var is_read: Bool { get }
}

/// Protocol that user profiles must conform to
public protocol ProfileProtocol {
    var id: String { get }
    var full_name: String { get }
}

/// Protocol that chat view models must conform to
@MainActor
public protocol ChatViewModelProtocol: ObservableObject {
    var messages: [any ChatMessageProtocol] { get }
    
    func sendTextMessage(_ text: String) async
    func sendImageMessage(image: UIImage) async
    func deleteMessage(_ message: any ChatMessageProtocol) async
    func start() async
}
