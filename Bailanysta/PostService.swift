import Foundation
import Combine

class PostService: ObservableObject {
    @Published var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    let baseURL = "http://localhost:3000" 

    func fetchPosts() {
        guard let url = URL(string: "\(baseURL)/posts") else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.posts, on: self)
            .store(in: &cancellables)
    }

    func createPost(author: String, content: String) {
        guard let url = URL(string: "\(baseURL)/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let post = ["author": author, "content": content]
        request.httpBody = try? JSONSerialization.data(withJSONObject: post)

        URLSession.shared.dataTask(with: request).resume()
    }
}
