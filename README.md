# SwiftChat

A SwiftUI chat interface package for iOS. SwiftChat provides beautiful, customizable UI components for building chat applications with support for text messages, images, and links.

## Features

- 🎨 **Modern SwiftUI Design** - Beautiful, native chat interface components
- 📱 **Multi-Platform Support** - Works on iOS
- 🔌 **Protocol-Based Architecture** - Flexible and framework-agnostic
- 🖼️ **Image Support** - Built-in image picker and display
- 🔗 **Link Detection** - Automatic link rendering with tap support
- ✨ **Customizable** - Easy to style and extend

## Requirements

- iOS 15.0+

## Installation

### Swift Package Manager

Add SwiftChat to your project using Swift Package Manager:

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. Enter the repository URL: `https://github.com/yourusername/SwiftChat.git`
3. Select the version you want to use
4. Click **Add Package**

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftChat.git", from: "1.0.0")
]
```

## Usage

### 1. Conform to Protocols

First, make your data models conform to the required protocols:

```swift
import SwiftChat

// Your message model
struct ChatMessage: ChatMessageProtocol {
    let id: String
    let content: String
    let type: MessageType
    let sender_id: String
    var is_read: Bool
}

// Your profile model
struct Profile: ProfileProtocol {
    let id: String
    let full_name: String
}

// Your view model
@MainActor
class ChatViewModel: ChatViewModelProtocol, ObservableObject {
    @Published var messages: [any ChatMessageProtocol] = []
    
    func sendTextMessage(_ text: String) async {
        // Your implementation
    }
    
    func sendImageMessage(image: UIImage) async {
        // Your implementation
    }
    
    func deleteMessage(_ message: any ChatMessageProtocol) async {
        // Your implementation
    }
    
    func start() async {
        // Your implementation (e.g., start listening for messages)
    }
}
```

### 2. Use ChatView

```swift
import SwiftUI
import SwiftChat

struct ContentView: View {
    let currentUser = Profile(id: "user1", full_name: "You")
    let otherUser = Profile(id: "user2", full_name: "Friend")
    
    var body: some View {
        NavigationView {
            ChatView(
                currentUser: currentUser,
                otherUser: otherUser,
                viewModel: ChatViewModel(currentUser: currentUser, otherUser: otherUser)
            )
        }
    }
}
```

## Components

### ChatView

The main chat interface view that displays messages and handles user input.

```swift
ChatView<ViewModel: ChatViewModelProtocol>(
    currentUser: any ProfileProtocol,
    otherUser: any ProfileProtocol,
    viewModel: ViewModel
)
```

### MessageBubble

Displays individual chat messages with support for text, images, and links.

```swift
MessageBubble(
    message: any ChatMessageProtocol,
    isCurrentUser: Bool
)
```

### ChatInputBar

Input bar component for typing and sending messages.

```swift
ChatInputBar(
    messageText: Binding<String>,
    onSend: () -> Void,
    onImageTap: () -> Void,
    isSendEnabled: Bool
)
```

### NetworkImageView

Displays images from URLs with loading states.

```swift
NetworkImageView(
    urlString: String,
    isCurrentUser: Bool
)
```

### LinkMessageView

Renders clickable links in messages.

```swift
LinkMessageView(
    urlString: String,
    isCurrentUser: Bool
)
```

### ImagePicker

SwiftUI wrapper for UIImagePickerController.

```swift
ImagePicker(image: Binding<UIImage?>)
```

## Protocols

### ChatMessageProtocol

Protocol that chat messages must conform to:

```swift
protocol ChatMessageProtocol: Identifiable {
    var id: String { get }
    var content: String { get }
    var type: MessageType { get }
    var sender_id: String { get }
    var is_read: Bool { get }
}
```

### ProfileProtocol

Protocol for user profiles:

```swift
protocol ProfileProtocol {
    var id: String { get }
    var full_name: String { get }
}
```

### ChatViewModelProtocol

Protocol for chat view models:

```swift
@MainActor
protocol ChatViewModelProtocol: ObservableObject {
    var messages: [any ChatMessageProtocol] { get }
    
    func sendTextMessage(_ text: String) async
    func sendImageMessage(image: UIImage) async
    func deleteMessage(_ message: any ChatMessageProtocol) async
    func start() async
}
```

## Message Types

The `MessageType` enum supports three types:

- `.text` - Plain text messages
- `.image` - Image messages (URL string)
- `.link` - Link messages (URL string)

## Dependencies

- [Supabase Swift](https://github.com/supabase/supabase-swift) - For backend integration (optional, you can use any backend)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Rutvik Pipaliya
