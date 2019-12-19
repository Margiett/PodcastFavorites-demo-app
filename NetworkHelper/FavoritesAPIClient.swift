//
//  FavoritesAPIClient.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import Foundation

struct FavoritesAPIClient {
    static func postFaves(favorite: Favorite, completion: @escaping (Result<Bool, AppError>) -> () ) {
        
        let endpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        
        //MARK: Create a URL from the endpoint String
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        //MARK: Coverting to Data
        do {
            let data = try JSONEncoder().encode(favorite)
            //MARK: Confirgure out URLRequest
            // type of url
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            // what does this do ???????
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            //MARK: Execute POST request
            // either our completion captures Data or AppError
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
    // what is this function doing ????????
    static func getFaves(
                         completion: @escaping (Result<[Favorite], AppError>) -> () ) {
        let endpointURL = "https://5c2e2a592fffe80014bd6904.mockapi.io/api/v1/favorites"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let favorites = try JSONDecoder().decode([Favorite].self, from: data)
                    completion(.success(favorites))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
