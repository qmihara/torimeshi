import Foundation
import SwiftyJSON

struct Review: JSONDecodable {

    enum State: String {
        case commented = "commented"
        case changesRequested = "changes_requested"
        case approved = "approved"

        var text: String {
            switch self {
            case .commented:
                return "Commented"
            case .changesRequested:
                return "Requested changes"
            case .approved:
                return "Approved"
            }
        }

        var emoji: String {
            switch self {
            case .commented:
                return ":speech_balloon:"
            case .changesRequested:
                return ":pray:"
            case .approved:
                return ":tada:"
            }
        }
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
