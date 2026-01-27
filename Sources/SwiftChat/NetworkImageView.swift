import SwiftUI

public struct NetworkImageView: View {
    let urlString: String
    let isCurrentUser: Bool
    
    public init(urlString: String, isCurrentUser: Bool) {
        self.urlString = urlString
        self.isCurrentUser = isCurrentUser
    }
    
    public var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 200, height: 150)
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 220, maxHeight: 180)
                    .clipped()
                    .cornerRadius(10)
                
            case .failure:
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 150)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}
