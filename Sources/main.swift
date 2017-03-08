import Foundation
import Kitura
import HeliumLogger
import SwiftyJSON

HeliumLogger.use()

let router = Router()

router.post("/") { request, response, next in
    guard let requestBody = try request.readString() else {
        print("No body.")
        next()
        return
    }

    guard let signature = request.headers["X-Hub-Signature"] else {
        print("Signature is nil")
        next()
        return
    }

    if !Signature.veriry(withSignature: signature, requestBody: requestBody) {
        print("Signature verify failed.")
        next()
        return
    }

    let jsonBody = JSON.parse(string: requestBody)
    guard let pullRequestReviewEvent = PullRequestReviewEvent(json: jsonBody.dictionaryValue) else {
        response.send("No GitHub pull request review event.")
        next()
        return
    }

    print("event:\(pullRequestReviewEvent)")
    Slack.postMessage(Message(event: pullRequestReviewEvent).text)

    response.send("Successful!!")
    next()
}

let port: Int = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8090") ?? 8090
Kitura.addHTTPServer(onPort: port, with: router)

Kitura.run()
