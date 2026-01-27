import SwiftUI

public struct ChatInputBar: View {
    
    @Binding var messageText: String
    let onSend: () -> Void
    let onImageTap: () -> Void
    let isSendEnabled: Bool
    
    public init(messageText: Binding<String>, onSend: @escaping () -> Void, onImageTap: @escaping () -> Void, isSendEnabled: Bool) {
        self._messageText = messageText
        self.onSend = onSend
        self.onImageTap = onImageTap
        self.isSendEnabled = isSendEnabled
    }
    
    public var body: some View {
        
        HStack(spacing: 8) {
            
            Button(action: onImageTap) {
                Image(systemName: "photo")
                    .font(.system(size: 22))
            }
            
            TextField("Message...", text: $messageText)
                .textFieldStyle(.roundedBorder)
            
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .rotationEffect(.degrees(45))
            }
            .disabled(!isSendEnabled)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
