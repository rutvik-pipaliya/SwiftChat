import SwiftUI

public struct LinkMessageView: View {
    let urlString: String
    let isCurrentUser: Bool
    
    public init(urlString: String, isCurrentUser: Bool) {
        self.urlString = urlString
        self.isCurrentUser = isCurrentUser
    }
    
    public var body: some View {
        if let url = URL(string: urlString) {
            Link(destination: url) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(urlString)
                        .underline()
                        .lineLimit(2)
                        .foregroundColor(isCurrentUser ? .white : .blue)
                }
            }
        } else {
            Text(urlString)
                .foregroundColor(.red)
        }
    }
}
