//
//  MainViewController.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .red
  }
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
