//
//  RepositoryDetailsModel.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation

struct RepositoryDetailsModel: Codable {
    let name: String
    let description: String?
    let html_url: String
    let owner: Owner
    let contributors_url: String
}


