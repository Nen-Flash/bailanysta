import Foundation

struct Post: Identifiable, Codable {
    let id: String
    let author: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case author, content
    }
}

struct Comment: Identifiable, Codable {
    let id: String?
    let postId: String
    let author: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case postId, author, content
    }

    // 👇 Вот это добавь:
    init(id: String? = nil, postId: String, author: String, content: String) {
        self.id = id
        self.postId = postId
        self.author = author
        self.content = content
    }
}
