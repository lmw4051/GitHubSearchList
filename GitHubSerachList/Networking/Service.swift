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
  
  func fetchSearchData(completion: @escaping ([UserInfo], Error?) -> ()) {
    let urlString = "https://api.github.com/search/users?q=a&page=1"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Failed to fetch apps:", error)
        return
      }
      
      guard let data = data else { return }
      
      do {
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        completion(searchResult.items, nil)
      } catch let error {
        print("Failed to decode json:", error)
        completion([], error)
      }
    }.resume()
  }
}
