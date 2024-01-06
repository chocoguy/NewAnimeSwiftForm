import Foundation
struct Node : Codable {
	let id : Int?
	let title : String?
	let main_picture : Main_picture?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case title = "title"
		case main_picture = "main_picture"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		main_picture = try values.decodeIfPresent(Main_picture.self, forKey: .main_picture)
	}

}
