import Foundation

struct Message {

    var text: String

    init(event: PullRequestReviewEvent) {
        var text = String(
            format: "[%@] %@ %@ by %@ on pull request %@",
            event.repository.fullName,
            event.review.state.emoji,
            event.review.state.text,
            event.review.user.login,
            event.review.htmlURL.absoluteString
        )
        if let body = event.review.body, !body.isEmpty {
            text += "\n"
            text += body.components(separatedBy: "\n").map({ "> \($0)" }).joined(separator: "\n")
        }
        self.text = text
    }
}
