import Foundation
import SwiftyJSON

struct Review: JSONDecodable {

    enum State: String {
        case commented = "commented"
        case changesRequested = "changes_requested"
        case approved = "approved"
    }

    var state: State
    var body: String?
    var user: User
    var htmlURL: URL

    init?(json: [String: JSON]) {
        guard let stateValue = json["state"]?.string, let state = State(rawValue: stateValue) else { return nil }
        self.state = state

        body = json["body"]?.string

        guard let userDictionary = json["user"]?.dictionary, let user = User(json: userDictionary) else { return nil }
        self.user = user

        guard let htmlURLValue = json["html_url"]?.string, let htmlURL = URL(string: htmlURLValue) else { return nil }
        self.htmlURL = htmlURL
    }
}
