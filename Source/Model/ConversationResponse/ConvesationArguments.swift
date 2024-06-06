
import Foundation

struct ConvesationArguments: Codable {

    var conversations  : Conversations?    = Conversations()
    var users : [Users]? = []

    enum CodingKeys: String, CodingKey {
        case conversations  = "conversations"
        case users = "users"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        conversations  = try values.decodeIfPresent(Conversations.self , forKey: .conversations)
        users = try values.decodeIfPresent([Users].self , forKey: .users)
    }

    init() {

    }
}
