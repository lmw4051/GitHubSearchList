//
//  SearchResultCell.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
  
  var userInfo: UserInfo! {
    didSet {
      print(userInfo)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .red
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
