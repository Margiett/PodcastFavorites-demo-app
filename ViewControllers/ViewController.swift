//
//  ViewController.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import UIKit

//FavoritesViewController
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favorites = [Favorite]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var podcast: PodcastModelStruct?
    var podcastArr = [PodcastModelStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadData() {
        
        FavoritesAPIClient.getFaves { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let favorite):
                self?.favorites = favorite.filter {$0.favoritedBy == "Margiett X Gil"}
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favorite"{
            guard let podcastDetail = segue.destination as? PodcastDetailsController, let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("issue in segue")
            }
            
            if podcastDetail.podcast?.trackId == podcastArr.first?.trackId {
                podcastDetail.favorite = favorites[indexPath.row]
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? FavoriteCell else {
            fatalError("cell incorrect")
        }
        let fave = favorites[indexPath.row]
        
        cell.configureCell(for: fave)
        
     return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
