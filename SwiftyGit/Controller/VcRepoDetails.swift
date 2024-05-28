//
//  VcRepoDetails.swift
//  SwiftyGit
//
//  Created by Tushar on 29/05/24.
//

import UIKit
import WebKit
import SDWebImage

class VcRepoDetails: UIViewController {
    @IBOutlet weak var imgAvator: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnProjectLink: UIButton!
    @IBOutlet weak var tvContributors: UITableView!
    
    var repositoryFullName: String!
    private var viewModel = RepositoryDetailsViewModel()
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigUI()
    }
    
    private func ConfigUI() {
        tvContributors.delegate = self
        tvContributors.dataSource = self
        btnProjectLink.layer.cornerRadius = 10
        fetchDetails()
    }
    
    private func fetchDetails() {
        ShowActivityIndicator(uiView: self.view)
        viewModel.fetchRepositoryDetails(repoFullName: repositoryFullName) {
            DispatchQueue.main.async {
                HideActivityIndicator(uiView: self.view)
                self.updateUI()
                self.tvContributors.reloadData()
                if let error = self.viewModel.error as? APIError {
                    showErrorAlert(on: self, message: error.localizedDescription)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func updateUI() {
        guard let details = viewModel.repositoryDetails else { return }
        lblName.text = details.name
        lblDesc.text = details.description
        btnProjectLink.setTitle(details.html_url, for: .normal)
        if let url = URL(string: details.owner.avatar_url) {
            imgAvator.sd_setImage(with: url)
        }
    }
    
    @IBAction func didTapOpenLink(_ sender: UIButton) {
        if let urlString = sender.title(for: .normal), let url = URL(string: urlString) {
            ShowActivityIndicator(uiView: self.view)
            webView = WKWebView()
            webView.navigationDelegate = self
            let webViewController = UIViewController()
            webViewController.view = webView
            webView.load(URLRequest(url: url))
            navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}

extension VcRepoDetails: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HideActivityIndicator(uiView: self.view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HideActivityIndicator(uiView: self.view)
        showErrorAlert(on: self, message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        HideActivityIndicator(uiView: self.view)
        showErrorAlert(on: self, message: error.localizedDescription)
    }
}

extension VcRepoDetails: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tvContributors.dequeueReusableCell(withIdentifier: "TvCellContributors", for: indexPath) as? TvCellContributors else {
            return UITableViewCell()
        }
        let contributor = viewModel.contributors[indexPath.row]
        cell.lblContributorsName.text = contributor.login
        if let url = URL(string: contributor.avatar_url) {
            cell.ImgContributorsAvatar.sd_setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
