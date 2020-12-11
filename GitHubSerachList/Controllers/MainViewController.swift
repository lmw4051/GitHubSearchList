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
  fileprivate var userItems = [UserInfo]()
  fileprivate let cellId = "CellId"
  fileprivate let searchController = UISearchController(searchResultsController: nil)

  fileprivate var timer: Timer?
  fileprivate var searchStr: String?
  
  fileprivate var activityIndicatorView = UIActivityIndicatorView()
  
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
  
  func fetchData(searchTerm: String, page: Int) {
    
  }
  
  fileprivate func loadUserInfos(searchTerm: String) {
    let page = userItems.count / 100 + 1
    
    Service.shared.fetchSearchData(searchTerm: searchTerm, page: page) { (userInfos, error) in
      
      if let error = error {
        print("Failed to fetch apps:", error)
        return
      }
          
      if let newItems = userInfos {
        self.userItems += newItems
      }
      
      DispatchQueue.main.async {
        self.collectionView.performBatchUpdates(nil, completion: nil)
      }
    }
  }
  
  // MARK: - UICollectionViewDataSource Methods
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userItems.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.userInfo = userItems[indexPath.item]
    
    if indexPath.row == userItems.count - 1 {
      loadUserInfos(searchTerm: searchStr ?? "")
    }
    return cell
  }
  
  // MARK: -  UICollectionViewDelegateFlowLayout Methods
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
      
  // MARK: - UISearchBarDelegate
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    searchStr = searchText
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        self.userItems.removeAll()
        self.collectionView.reloadData()
        self.loadUserInfos(searchTerm: self.searchStr ?? "")
      }
    })
  }
}
