//
//  WebServiceHelper.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebServiceHelper {
    static let shared = WebServiceHelper()
    
    private init() {
        NetworkConnectivity.shared.startListening()
    }
    
    func searchRepositories(query: String, page: Int, completion: @escaping (Result<[RepositoryListModel], APIError>) -> Void) {
        guard NetworkConnectivity.shared.isConnected else {
            if page == 1 {
                let offlineRepositories = CoreDataManager.shared.fetchRepositories()
                completion(.success(Array(offlineRepositories.prefix(10))))
            } else {
                let apiError = APIError(errorResponse: nil, statusCode: -1009)
                completion(.failure(apiError))
            }
            return
        }
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.searchRepositories)?q=\(query)&page=\(page)&per_page=10"
        performRequest(urlString: urlString) { (result: Result<SearchResponseModel, APIError>) in
            switch result {
            case .success(let response):
                completion(.success(response.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchRepositoryDetails(repoFullName: String, completion: @escaping (Result<RepositoryDetailsModel, APIError>) -> Void) {
        guard NetworkConnectivity.shared.isConnected else {
            let apiError = APIError(errorResponse: nil, statusCode: -1009)
            completion(.failure(apiError))
            return
        }
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.repoDetails)\(repoFullName)"
        performRequest(urlString: urlString, completion: completion)
    }

    func fetchContributors(repoFullName: String, completion: @escaping (Result<[ContributorModel], APIError>) -> Void) {
        guard NetworkConnectivity.shared.isConnected else {
            let apiError = APIError(errorResponse: nil, statusCode: -1009)
            completion(.failure(apiError))
            return
        }
        
        let urlString = "\(APIConstants.baseURL)\(APIConstants.repoDetails)\(repoFullName)\(APIConstants.contributors)"
        performRequest(urlString: urlString, completion: completion)
    }

    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, APIError>) -> Void) {
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    if let json = try? JSON(data: data).rawString() {
                        print("Raw JSON response: \(json)")
                    }
                    let json = try JSON(data: data)
                    let result = try JSONDecoder().decode(T.self, from: json.rawData())
                    completion(.success(result))
                } catch let error {
                    let apiError = APIError(errorResponse: nil, statusCode: response.response?.statusCode)
                    completion(.failure(apiError))
                }
            case .failure:
                let statusCode = response.response?.statusCode
                if let data = response.data {
                    let decoder = JSONDecoder()
                    let errorResponse = try? decoder.decode(ErrorResponseModel.self, from: data)
                    let apiError = APIError(errorResponse: errorResponse, statusCode: statusCode)
                    completion(.failure(apiError))
                } else {
                    let apiError = APIError(errorResponse: nil, statusCode: statusCode)
                    completion(.failure(apiError))
                }
            }
        }
    }
}
