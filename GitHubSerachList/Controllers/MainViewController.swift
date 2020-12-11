//
//  MainViewController.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
  
  // MARK: - Instance Properties
  fileprivate var userInfos = [UserInfo]()
  fileprivate let cellId = "CellId"
  fileprivate let searchController = UISearchController(searchResultsController: nil)
  
  var timer: Timer?
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    setupSearchBar()
  }
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helper Methods
  fileprivate func configureCollectionView() {
    navigationItem.title = "Search User"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    collectionView.backgroundColor = .white
    collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  fileprivate func setupSearchBar() {
    navigationItem.searchController = self.searchController
    searchController.searchBar.delegate = self
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
  
  // MARK: - UISearchBarDelegate
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
      Service.shared.fetchSearchData(searchTerm: searchText, page: 1) { (userInfos, error) in
        if let error = error {
          print("Failed to fetch apps:", error)
          return
        }
        
        self.userInfos = userInfos ?? []
        
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
      }
    })        
  }
}
