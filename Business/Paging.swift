import Foundation
struct Paging : Codable {
	let next : String?

	enum CodingKeys: String, CodingKey {

		case next = "next"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		next = try values.decodeIfPresent(String.self, forKey: .next)
	}

}
