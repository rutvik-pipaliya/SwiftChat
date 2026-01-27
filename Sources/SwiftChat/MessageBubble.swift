import SwiftUI

public struct MessageBubble: View {
    let message: any ChatMessageProtocol
    let isCurrentUser: Bool
    
    public init(message: any ChatMessageProtocol, isCurrentUser: Bool) {
        self.message = message
        self.isCurrentUser = isCurrentUser
    }
    
    public var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: .leading, spacing: 6) {
                messageContent
                    .padding(10)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                    .cornerRadius(12)
                
                Text(message.is_read ? "Read" : "Unread")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var messageContent: some View {
        switch message.type {
            
        case .text:
            Text(message.content)
                .foregroundColor(isCurrentUser ? .white : .black)
            
        case .image:
            NetworkImageView(
                urlString: message.content,
                isCurrentUser: isCurrentUser
            )
            
        case .link:
            LinkMessageView(
                urlString: message.content,
                isCurrentUser: isCurrentUser
            )
        }
    }
}
