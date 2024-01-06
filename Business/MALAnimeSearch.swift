import Foundation
struct MALAnimeSearch : Codable {
	let data : [Data]?
	let paging : Paging?

	enum CodingKeys: String, CodingKey {

		case data = "data"
		case paging = "paging"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent([Data].self, forKey: .data)
		paging = try values.decodeIfPresent(Paging.self, forKey: .paging)
	}

}
