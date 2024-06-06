
import Foundation

struct ConversationResponse: Codable {

    var type      : Int?         = 0
    var target    : String?      = ""
    var arguments : [ConvesationArguments]? = []

    enum CodingKeys: String, CodingKey {
        case type      = "type"
        case target    = "target"
        case arguments = "arguments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        type      = try values.decodeIfPresent(Int.self , forKey: .type)
        target    = try values.decodeIfPresent(String.self, forKey: .target)
        arguments = try values.decodeIfPresent([ConvesationArguments].self , forKey: .arguments)
    }

    init() {

    }
}
