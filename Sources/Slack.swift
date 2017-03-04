import Foundation
import LoggerAPI

struct Slack {

    static func postMessage(_ text: String) {
        Log.info("post message: \(text)")

        guard let url = ProcessInfo.processInfo.environment["SLACK_INCOMING_WEBHOOK_URL"] else {
            Log.warning("Slack incoming webhook url not found. Please set up SLACK_INCOMING_WEBHOOK_URL.")
            return
        }

        guard let incomingWebhook = IncomingWebhook(url: url) else {
            Log.warning("Invalid url. \"\(url)\"")
            return
        }

        incomingWebhook.postMessage(text)
    }
}

struct IncomingWebhook {

    var url: URL

    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        self.url = url
    }

    func postMessage(_ text: String) {
        let payload = makePayload(withText: text)
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: []) else {
            Log.warning("JSON serialization failed. payload:\(payload)")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { data, response, error in
            if let error = error {
                Log.warning("Slack post a message failed:\(error)")
                return
            }
        }
        task.resume()
    }

    private func makePayload(withText text: String) -> [String: Any] {
        var jsonBody: [String: Any] = [:]
        jsonBody["text"] = text
        return jsonBody
    }
}
