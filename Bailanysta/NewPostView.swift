import SwiftUI

struct NewPostView: View {
    @State private var author: String = ""
    @State private var content: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Имя автора", text: $author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Что у вас нового?", text: $content, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)

                Button(action: submitPost) {
                    Text("Опубликовать")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(author.isEmpty || content.isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("Новый пост")
        }
    }

    func submitPost() {
        guard let url = URL(string: "http://localhost:3000/posts") else { return }

        let newPost = Post(id: "", author: author, content: content)
        guard let encoded = try? JSONEncoder().encode(newPost) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }.resume()
    }
}
