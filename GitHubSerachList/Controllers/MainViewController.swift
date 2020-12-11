//
//  MainViewController.swift
//  GitHubSerachList
//
//  Created by David on 2020/12/11.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
  
  // MARK: - Instance Properties
  fileprivate var userItems = [UserInfo]()
  fileprivate let cellId = "CellId"
  fileprivate let searchController = UISearchController(searchResultsController: nil)
  
  fileprivate var timer: Timer?
  fileprivate var searchStr: String?
  
  fileprivate var activityIndicatorView = UIActivityIndicatorView()
  
  fileprivate var nextPage = 1
  
  fileprivate var isSearching = false
  
//  fileprivate var lastPage = 0
  
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
  
  fileprivate func loadUserInfos(searchTerm: String) {
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    Service.shared.fetchSearchData(searchTerm: searchTerm, page: nextPage) { [weak self] (userInfos, response, error) in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        MBProgressHUD.hide(for: self.view, animated: true)
      }
      
      if let error = error {
        print("Failed to fetch apps:", error)
        return
      }
      
      if self.isSearching {
        self.userItems = userInfos ?? []
      } else {
        if let newItems = userInfos {
          self.userItems += newItems
        }
      }
                  
      DispatchQueue.main.async {
        self.collectionView.performBatchUpdates(nil, completion: nil)
      }
      
      self.parseHeader(response: response as? HTTPURLResponse)
    }
  }
  
  func parseHeader(response: HTTPURLResponse?) {
    if let httpResponse = response {
      if let linkHeader = httpResponse.allHeaderFields["Link"] as? String {
        print("linkHeader:", linkHeader)
        
        let links = linkHeader.components(separatedBy: ",")
        
        var dictionary: [String: String] = [:]
        links.forEach {
          let components = $0.components(separatedBy:"; ")
          let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
          dictionary[components[1]] = cleanPath
        }
        
        if let nextPagePath = dictionary["rel=\"next\""] {
          print("nextPagePath: \(nextPagePath)")
          if let nextPage = nextPagePath.components(separatedBy: "=").last {
            print(nextPage)
            self.nextPage = Int(nextPage) ?? 0
          }
        }
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
    
    if indexPath.item == userItems.count - 1 {
      if !isSearching {
        loadUserInfos(searchTerm: searchStr ?? "")
      }
    }
    
    return cell
  }
    
  // MARK: -  UICollectionViewDelegateFlowLayout Methods
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 100)
  }
  
  // MARK: - UISearchBarDelegate Methods
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    isSearching = true
    
    searchStr = searchText
    self.userItems.removeAll()
    
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [weak self] _ in
      guard let self = self else { return }
      
      self.loadUserInfos(searchTerm: self.searchStr ?? "")
    })
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("searchBarTextDidEndEditing")
    isSearching = false
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    print("searchBarTextDidBeginEditing")
    isSearching = true
  }
}
