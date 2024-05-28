//
//  RepositoryListModel.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation

struct SearchResponseModel: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [RepositoryListModel]
}

struct RepositoryListModel: Codable {
    let id: Int
    let name: String
    let description: String?
    let html_url: String
    let owner: Owner
    let contributors_url: String
    
    var fullName: String {
        return "\(owner.login)/\(name)"
    }
}

struct Owner: Codable {
    let login: String
    let avatar_url: String
}
