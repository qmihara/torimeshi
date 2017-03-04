import Foundation

struct Message {

    var text: String

    init(event: PullRequestReviewEvent) {
        let review = event.review
        var text = "[\(event.repository.fullName)] \(review.state.emoji) \(review.state.text) by \(review.user.login) on pull request \(review.htmlURL)"
        if let body = event.review.body, !body.isEmpty {
            text += "\n"
            text += body
//            text += body.replacingOccurrences(of: "\r", with: "").components(separatedBy: "\n").map({ "> \($0)" }).joined(separator: "\n")
        }
        self.text = text
    }
}
