import Foundation

struct Message {

    var text: String

    init(event: PullRequestReviewEvent) {
        let review = event.review
        var text = "[\(event.repository.fullName)] \(review.state.emoji) \(review.state.text) by \(review.user.login) on pull request \(review.htmlURL)"
        if let body = event.review.body, !body.isEmpty {
            print("start appending body ======>")
            text += "\n"
            print("added line break")
//            let carriageReturnRemovedBody = body.replacingOccurrences(of: "\r", with: "")
//            print("carriageReturnRemovedBody:\(carriageReturnRemovedBody)")
            let splitedBody = body.components(separatedBy: "\r\n")
            print("splitedBody:\(splitedBody)")
            let quotedBody = splitedBody.map { "> \($0)" }
            print("quotedBody:\(quotedBody)")
            let joinedBody = quotedBody.joined(separator: "\n")
            text += joinedBody
//            text += body.replacingOccurrences(of: "\r", with: "").components(separatedBy: "\n").map({ "> \($0)" }).joined(separator: "\n")
        }
        self.text = text
    }
}
