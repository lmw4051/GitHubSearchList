//
//  MainViewController.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  // MARK: - Instance Properties
  fileprivate var userInfos = [UserInfo]()
  fileprivate let cellId = "CellId"
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    fetchData()
  }
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  func configureCollectionView() {
    navigationItem.title = "Search User"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  fileprivate func fetchData() {
    Service.shared.fetchSearchData { [weak self] (userInfos, error) in
      guard let self = self else { return }
      
      if let error = error {
        print("Failed to fetch data:", error)
        return
      }
      
      self.userInfos = userInfos
      
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    }
  }
  
  // MARK: - UICollectionViewDataSource Methods
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userInfos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.userInfo = userInfos[indexPath.item]
    return cell
  }
  
  // MARK: -  UICollectionViewDelegateFlowLayout Methods
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
}
