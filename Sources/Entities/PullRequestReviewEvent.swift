import Foundation
import SwiftyJSON

struct PullRequestReviewEvent: JSONDecodable {

    var review: Review
    var pullRequest: PullRequest
    var repository: Repository

    init?(json: [String: JSON]) {
        guard let reviewDictionary = json["review"]?.dictionary, let review = Review(json: reviewDictionary) else { return nil }
        self.review = review

        guard let pullRequestDictionary = json["pull_request"]?.dictionary, let pullRequest = PullRequest(json: pullRequestDictionary) else { return nil }
        self.pullRequest = pullRequest

        guard let repositoryDictionary = json["repository"]?.dictionary, let repository = Repository(json: repositoryDictionary) else { return nil }
        self.repository = repository
    }
}
