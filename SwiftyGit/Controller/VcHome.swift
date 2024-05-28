//
//  VcHome.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import UIKit

class VcHome: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tvRepoList: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    private var viewModel = RepositoryListViewModel()
    private var currentPage = 1
    private var currentQuery = ""
    private var isOfflineMode = false
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tvRepoList.indexPathForSelectedRow {
            tvRepoList.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .networkStatusChanged, object: nil)
    }
    
    private func ConfigUI() {
        searchBar.delegate = self
        tvRepoList.delegate = self
        tvRepoList.dataSource = self
        
        NetworkConnectivity.shared.startListening()
        
        if !NetworkConnectivity.shared.isConnected {
            loadSavedRepositories()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: .networkStatusChanged, object: nil)
        updateNoDataLabel()
    }
    
    private func searchRepositories(query: String) {
        guard !isFetching else { return }
        currentQuery = query
        currentPage = 1
        isOfflineMode = false
        isFetching = true
        ShowActivityIndicator(uiView: self.view)
        
        if NetworkConnectivity.shared.isConnected {
            viewModel.searchRepositories(query: query, page: currentPage) {
                DispatchQueue.main.async {
                    HideActivityIndicator(uiView: self.view)
                    self.tvRepoList.reloadData()
                    self.isFetching = false
                    self.updateNoDataLabel()
                    if let error = self.viewModel.error as? APIError {
                        showErrorAlert(on: self, message: error.localizedDescription)
                        self.isOfflineMode = true
                    }
                }
            }
        } else {
            HideActivityIndicator(uiView: self.view)
            showErrorAlert(on: self, message: "No network available")
            loadSavedRepositories()
            self.isFetching = false
        }
    }
    
    private func loadMoreRepositories() {
        guard !isOfflineMode, !isFetching, !currentQuery.isEmpty else { return }
        currentPage += 1
        isFetching = true
        ShowActivityIndicator(uiView: self.view)
        
        if NetworkConnectivity.shared.isConnected {
            viewModel.loadMoreRepositories(query: currentQuery, page: currentPage) {
                DispatchQueue.main.async {
                    HideActivityIndicator(uiView: self.view)
                    self.tvRepoList.reloadData()
                    self.isFetching = false
                }
            }
        } else {
            HideActivityIndicator(uiView: self.view)
            showErrorAlert(on: self, message: "No network available")
            self.isFetching = false
        }
    }
    
    private func loadSavedRepositories() {
        viewModel.fetchSavedRepositories {
            DispatchQueue.main.async {
                self.tvRepoList.reloadData()
                self.updateNoDataLabel()
            }
        }
    }
    
    @objc private func networkStatusChanged() {
        if !NetworkConnectivity.shared.isConnected {
            HideActivityIndicator(uiView: self.view)
            showErrorAlert(on: self, message: "No network available")
        } else {
            if isOfflineMode {
                isOfflineMode = false
                if !currentQuery.isEmpty {
                    loadMoreRepositories()
                }
            }
        }
    }
    
    private func updateNoDataLabel() {
        if viewModel.repositories.isEmpty {
            lblNoData.text = currentQuery.isEmpty ? "Please search to see repositories." : "No repositories found."
            lblNoData.isHidden = false
            tvRepoList.isHidden = true
        } else {
            lblNoData.isHidden = true
            tvRepoList.isHidden = false
        }
    }
}

extension VcHome: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchRepositories(query: query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.repositories.removeAll()
            tvRepoList.reloadData()
            updateNoDataLabel()
        }
    }
}

extension VcHome: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tvRepoList.dequeueReusableCell(withIdentifier: "TvCellRepositoryList", for: indexPath) as? TvCellRepositoryList else {
            return UITableViewCell()
        }
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(with: repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.repositories.count - 1 {
            loadMoreRepositories()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = viewModel.repositories[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vcRepoDetails = storyboard.instantiateViewController(withIdentifier: "VcRepoDetails") as? VcRepoDetails {
            vcRepoDetails.repositoryFullName = repository.fullName
            navigationController?.pushViewController(vcRepoDetails, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}
