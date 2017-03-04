import Foundation
import SwiftyJSON

struct Repository: JSONDecodable {

    var fullName: String

    init?(json: [String : JSON]) {
        guard let fullName = json["full_name"]?.string else { return nil }
        self.fullName = fullName
    }
}
