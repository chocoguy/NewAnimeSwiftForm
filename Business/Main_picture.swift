import Foundation
struct Main_picture : Codable {
	let medium : String?
	let large : String?

	enum CodingKeys: String, CodingKey {

		case medium = "medium"
		case large = "large"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		medium = try values.decodeIfPresent(String.self, forKey: .medium)
		large = try values.decodeIfPresent(String.self, forKey: .large)
	}

}
