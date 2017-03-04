import Foundation
import Kitura
import HeliumLogger
import SwiftyJSON

HeliumLogger.use()

let router = Router()

router.post("/", middleware: BodyParser())
router.post("/") { request, response, next in
    guard let parsedBody = request.body else {
        response.send("No body.")
        next()
        return
    }

    switch parsedBody {
    case .json(let jsonBody):
        guard let pullRequestReviewEvent = PullRequestReviewEvent(json: jsonBody.dictionaryValue) else {
            response.send("No GitHub pull request review event.")
            next()
            return
        }
        print("event:\(pullRequestReviewEvent)")
        response.send("Successful!!")
        next()
    default:
        print("No jsonBody...")
        next()
    }
}

let port: Int = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8090") ?? 8090
Kitura.addHTTPServer(onPort: port, with: router)

Kitura.run()
