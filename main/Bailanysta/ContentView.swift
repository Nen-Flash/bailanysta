import SwiftUI

struct ContentView: View {
    @State private var posts: [Post] = []
    @State private var showNewPostView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(posts) { post in
                        PostView(post: post)
                    }
                }
                .padding()
            }
            .navigationTitle("Bailanysta")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showNewPostView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewPostView, onDismiss: fetchPosts) {
                NewPostView()
            }
            .onAppear(perform: fetchPosts)
        }
    }

    func fetchPosts() {
        guard let url = URL(string: "http://localhost:3000/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        posts = decoded
                    }
                }
            }
        }.resume()
    }
}

