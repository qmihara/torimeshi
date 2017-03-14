import Foundation

struct Message {

    var text: String

    init(event: PullRequestReviewEvent) {
        let review = event.review
        let pullRequest = event.pullRequest
        var text = "[\(event.repository.fullName)] \(review.state.emoji) \(review.state.text) by \(review.user.login) on pull request <\(review.htmlURL)|#\(pullRequest.number) \(pullRequest.title)>"
        if !review.body.isEmpty {
            text += "\n"
            text += review.body.components(separatedBy: "\r\n").map({ "> \($0)" }).joined(separator: "\n")
        }
        self.text = text
    }
}
