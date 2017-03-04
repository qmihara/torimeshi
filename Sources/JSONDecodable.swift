import Foundation
import SwiftyJSON

protocol JSONDecodable {
    init?(json: [String: JSON])
}
