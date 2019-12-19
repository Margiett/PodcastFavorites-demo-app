//
//  PodcastAPIClient.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import Foundation

struct PodcastAPIClient {
    static func getPodcasts(for search: String, completion: @escaping (Result <[PodcastModelStruct], AppError>) -> ()) {
        
        
         // this is protecting the user from putting spaces in the url, from which the method addingPercentEncoding() would replace the space with %20. http links cant have empty spaces at all e.g " "
        let searchQuery = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "swift"
        
         // using string interpolation to build endpoint url
        let endpointURL =
        "https://itunes.apple.com/search?media=podcast&limit=200&term=\(searchQuery)"
        
        
        //MARK: Create a URL from the endpoint String
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        // make a URLRequest object to pass to the NetworkingHelper
    //https://developer.apple.com/documentation/foundation/urlrequest
        let request = URLRequest(url: url)
        // set the HTTP method, example GET, POST, Delete, Put, UPDATE,....
        //request.httpBody = data
        // request.httBody = "POST"
        
        // this is required when posting so we inform the POST request of the data type, if we do not  provide the header value as "application/json"
        // we will get a decoding error when attempting to decode the JSON
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                
                do{
                    let podcasts = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let results = podcasts.results
                    completion(.success(results))
                }catch{
                    completion(.failure(.decodingError(error))) // this is protection just incase it fails this code would be activated
                }
            }
        }
    }
    static func getID(for trackId: Int, completion: @escaping (Result<[PodcastModelStruct], AppError>) -> () ) {
        
        let endpointURL = "https://itunes.apple.com/search?media=podcast&limit=200&term=\(trackId)"
      
        
        //MARK: Create a url
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL))) // this is not needed only if it fails 
            return
        }
      //MARK: Confirgure out URLRequest
      // type of url
        var request = URLRequest(url: url)
        
        
        //MARK: Execute POST request
        // either our completion captures Data or AppError
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let podcasts = try JSONDecoder().decode(PodcastSearch.self, from: data)
                    let results = podcasts.results
                    completion(.success(results))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    static func postPodcast(post: PodcastSearch) {
        
    }
}
