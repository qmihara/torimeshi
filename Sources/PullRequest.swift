import Foundation
import SwiftyJSON

struct PullRequest: JSONDecodable {

    var number: Int
    var title: String
    var user: User

    init?(json: [String : JSON]) {
        guard let number = json["number"]?.int else { return nil }
        self.number = number

        guard let title = json["title"]?.string else { return nil }
        self.title = title

        guard let userDictionary = json["user"]?.dictionary, let user = User(json: userDictionary) else { return nil }
        self.user = user
    }
}
