import SwiftUI

struct PostView: View {
    let post: Post
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(post.author)
                    .font(.headline)
                Text(post.content)
                    .font(.body)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Divider()

            Text("Комментарии:")
                .font(.subheadline)
                .bold()

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
            }
            .frame(minHeight: 100)

            HStack {
                TextField("Добавить комментарий...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Отправить") {
                    submitComment()
                }
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
        .onAppear(perform: fetchComments)
    }

    func fetchComments() {
        guard let url = URL(string: "http://localhost:3000/comments/\(post.id)") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([Comment].self, from: data) {
                    DispatchQueue.main.async {
                        comments = decoded
                    }
                }
            }
        }.resume()
    }

    func submitComment() {
        guard let url = URL(string: "http://localhost:3000/comments") else { return }

        let comment = Comment(postId: post.id, author: "User", content: newComment)
        guard let encoded = try? JSONEncoder().encode(comment) else {
            print("❌ Не удалось закодировать комментарий")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded

        print("📤 Отправка комментария: \(comment)")

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse {
                print("📬 Ответ сервера: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        newComment = ""
                        fetchComments()
                    }
                } else {
                    print("❌ Ошибка при отправке комментария")
                }
            }
        }.resume()
    }
}

struct CommentRow: View {
    let comment: Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(comment.author)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(comment.content)
                .font(.body)
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
