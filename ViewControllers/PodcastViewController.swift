//
//  PodcastViewController.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var podcasts = [PodcastModelStruct](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var searchQuery = "" {
        didSet{
            loadData(for: searchQuery)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(for: "swift")
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    private func loadData(for search: String){
        PodcastAPIClient.getPodcasts(for: search) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let podcasts):
                self?.podcasts = podcasts.sorted {$0.collectionName < $1.collectionName }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let podcastDetail = segue.destination as? PodcastDetailsController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("could not segue")
        }
        podcastDetail.podcast = podcasts[indexPath.row]
    }
    
}

extension PodcastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "podcastCell", for: indexPath) as? PodcastCell else {
            fatalError("issue connecting cell")
        }
        
        let podcast = podcasts[indexPath.row]
        
        cell.configureCell(for: podcast)
        return cell
    }
}

extension PodcastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension PodcastViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
}
