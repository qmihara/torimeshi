import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import SwiftyJSON

let logLevel: Int = Int(ProcessInfo.processInfo.environment["LOG_LEVEL"] ?? "4") ?? 4 // 4 is verbose
HeliumLogger.use(LoggerMessageType(rawValue: logLevel) ?? .verbose)

let router = Router()

router.post("/") { request, response, next in
    guard let requestBody = try request.readString() else {
        Log.info("No body.")
        next()
        return
    }

    guard let signature = request.headers["X-Hub-Signature"] else {
        Log.info("Signature is nil")
        next()
        return
    }

    if !Signature.veriry(withSignature: signature, requestBody: requestBody) {
        Log.warning("Signature verify failed.")
        next()
        return
    }

    let jsonBody = JSON.parse(string: requestBody)
    guard let pullRequestReviewEvent = PullRequestReviewEvent(json: jsonBody.dictionaryValue) else {
        response.send("No GitHub pull request review event.")
        next()
        return
    }

    Log.debug("event:\(pullRequestReviewEvent)")
    Slack.postMessage(Message(event: pullRequestReviewEvent).text)

    response.send("Successful!!")
    next()
}

let port: Int = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8090") ?? 8090
Kitura.addHTTPServer(onPort: port, with: router)

Kitura.run()
