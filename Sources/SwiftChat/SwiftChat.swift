// The Swift Programming Language
// https://docs.swift.org/swift-book
import SwiftUI
import Foundation

public struct ChatView<ViewModel: ChatViewModelProtocol>: View {
    
    let currentUser: any ProfileProtocol
    let otherUser: any ProfileProtocol
    
    @StateObject private var viewModel: ViewModel
    @State private var messageText = ""
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var lastMessageId: String = ""
    
    public init(currentUser: any ProfileProtocol, otherUser: any ProfileProtocol, viewModel: @autoclosure @escaping () -> ViewModel) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    public var body: some View {
        let canSend = !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil
        
        VStack {
            if (!viewModel.messages.isEmpty) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { _, message in
                                MessageBubble(
                                    message: message,
                                    isCurrentUser: message.sender_id == currentUser.id
                                )
                                .id(message.id)
                                .contextMenu {
                                    if message.sender_id == currentUser.id {
                                        Button(role: .destructive) {
                                            Task {
                                                await viewModel.deleteMessage(message)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .onAppear {
                        // Scroll to bottom when view first appears (if messages exist)
                        if let lastMessage = viewModel.messages.last {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        // Scroll when message count changes
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: lastMessageId) { _ in
                        // Scroll when a new message is added (tracked by ID)
                        scrollToBottom(proxy: proxy)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("No messages yet. Start a conversation!")
                    Spacer()
                }
            }
            
            Divider()
            
            if let image = selectedImage {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button("Remove") {
                        selectedImage = nil
                    }
                }
                .padding(.horizontal)
            }
            
            ChatInputBar(
                messageText: $messageText,
                onSend: {
                    Task {
                        if let image = selectedImage {
                            await viewModel.sendImageMessage(image: image)
                            selectedImage = nil
                        } else {
                            let text = messageText
                            messageText = ""
                            await viewModel.sendTextMessage(text)
                        }
                    }
                },
                onImageTap: {
                    showImagePicker = true
                },
                isSendEnabled: canSend
            )
        }
        .navigationTitle(otherUser.full_name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.start()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: viewModel.messages) { messages in
            // Track the last message ID to detect new messages
            if let lastMessage = messages.last, lastMessage.id != lastMessageId {
                lastMessageId = lastMessage.id
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = viewModel.messages.last else { return }
        
        // Use a small delay to ensure the view is laid out
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
