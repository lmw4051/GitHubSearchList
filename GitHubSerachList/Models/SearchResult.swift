//
//  SearchResult.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
  var items: [UserInfo]
}

struct UserInfo: Decodable {
  let login: String
  let score: Double
  let avatar_url: String
}
