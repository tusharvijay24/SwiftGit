//
//  RepositoryDetailsViewModel.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation

class RepositoryDetailsViewModel {
    var repositoryDetails: RepositoryDetailsModel?
    var contributors: [ContributorModel] = []
    var error: Error?

    func fetchRepositoryDetails(repoFullName: String, completion: @escaping () -> Void) {
        WebServiceHelper.shared.fetchRepositoryDetails(repoFullName: repoFullName) { result in
            switch result {
            case .success(let details):
                self.repositoryDetails = details
                self.fetchContributors(repoFullName: repoFullName, completion: completion)
            case .failure(let error):
                self.error = error
                completion()
            }
        }
    }

    private func fetchContributors(repoFullName: String, completion: @escaping () -> Void) {
        WebServiceHelper.shared.fetchContributors(repoFullName: repoFullName) { result in
            switch result {
            case .success(let contributors):
                self.contributors = contributors
            case .failure(let error):
                self.error = error
            }
            completion()
        }
    }
}
