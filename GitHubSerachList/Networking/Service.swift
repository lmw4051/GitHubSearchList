//
//  Service.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

class Service {
  static let shared = Service()
  
  private enum GithubServiceError: Error {
    case responseError
    case limitExeededError
    
    var errorMessage: String {
      switch self {
      case .limitExeededError:
        return "Github API rate limit exceeded. Wait for 60 seconds and try again."
      default:
        return "Error occured."
      }
    }
  }
  
  func fetchSearchData(searchTerm: String, page: Int, completion: @escaping ([UserInfo]?, URLResponse? ,Error?) -> ()) {
    let urlString = "https://api.github.com/search/users?q=\(searchTerm)&page=\(page)"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch apps:", error)
        return
      }        
      
      if let statusCode = (response as? HTTPURLResponse)?.statusCode,
        (statusCode < 200 || statusCode > 300) {
        print(GithubServiceError.limitExeededError.errorMessage)
      }
      
      guard let data = data else { return }
      
      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        completion(searchResult.items, response ,nil)
      } catch let error {
        print("Failed to decode json:", error)
        completion([], nil ,error)
      }
    }.resume()
  }
}
