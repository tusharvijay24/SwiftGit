//
//  RepositoryListViewModel.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation

class RepositoryListViewModel {
    var repositories: [RepositoryListModel] = []
    var error: Error?

    func searchRepositories(query: String, page: Int, completion: @escaping () -> Void) {
        WebServiceHelper.shared.searchRepositories(query: query, page: page) { result in
            switch result {
            case .success(let repositories):
                if page == 1 {
                    self.repositories = repositories
                    CoreDataManager.shared.saveRepositories(repositories)
                } else {
                    self.repositories.append(contentsOf: repositories)
                }
            case .failure(let error):
                self.error = error
                if page == 1 {
                    self.repositories = CoreDataManager.shared.fetchRepositories()
                }
            }
            completion()
        }
    }

    func loadMoreRepositories(query: String, page: Int, completion: @escaping () -> Void) {
        WebServiceHelper.shared.searchRepositories(query: query, page: page) { result in
            switch result {
            case .success(let repositories):
                self.repositories.append(contentsOf: repositories)
            case .failure(let error):
                self.error = error
            }
            completion()
        }
    }
    
    func fetchSavedRepositories(completion: @escaping () -> Void) {
        repositories = CoreDataManager.shared.fetchRepositories()
        completion()
    }
}
