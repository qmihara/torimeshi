import Foundation
import SwiftyJSON

struct User: JSONDecodable {

    var login: String

    init?(json: [String : JSON]) {
        guard let login = json["login"]?.string else { return nil }
        self.login = login
    }
}
