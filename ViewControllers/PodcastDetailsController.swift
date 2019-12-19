//
//  PodcastDetailsController.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import UIKit

class PodcastDetailsController: UIViewController {
    
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var podcastGenreLabel: UILabel!
    
    var podcast: PodcastModelStruct?
    var podcastArr = [PodcastModelStruct]()
    var favorite: Favorite?
    
    var favorited = [Favorite]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateFavoriteUI()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? ViewController else {
            fatalError("segue is not working")
        }
        vc.podcast = podcast
    }
    
    
    func updateUI() {
        guard let podcastPicked = podcast else {
            return
        }
        podcastNameLabel.text = podcastPicked.collectionName
        artistNameLabel.text = podcastPicked.artistName
        podcastGenreLabel.text = podcastPicked.genres.first
        podcastImage.getImage(with: podcastPicked.artworkUrl600) { [weak self] (result) in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "person.fill")
                }
            case .success(let image):
                DispatchQueue.main.async {
                    self?.podcastImage.image = image
                }
            }
        }
    }
    
    func updateFavoriteUI() {
        guard let idNumber = favorite?.trackId else {
            return
        }
        PodcastAPIClient.getID(for: idNumber) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let podcast):
                self?.podcastArr = podcast
                DispatchQueue.main.async {
                    self?.podcastNameLabel.text = self?.podcastArr.first?.collectionName
                    self?.artistNameLabel.text = self?.podcastArr.first?.artistName
                    self?.podcastGenreLabel.text = self?.podcastArr.first?.genres.first
                    self?.podcastImage.getImage(with: self?.podcastArr.first?.artworkUrl600 ?? "") { [weak self] (result) in
                        switch result {
                        case .failure:
                            DispatchQueue.main.async {
                                self?.podcastImage.image = UIImage(systemName: "person.fill")
                            }
                        case .success(let image):
                            DispatchQueue.main.async {
                                self?.podcastImage.image = image
                            }
                        }
                    }
                }
                
                
            }
        }
        
    }
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        
        guard let podcast = podcast else {
            showAlert(title: "App Error", message: "Issue uploading data")
            return
        }

        
        let favorite = Favorite(trackId: podcast.trackId, favoritedBy: "Margiett X Gil", collectionName: podcast.collectionName, artworkUrl600: podcast.artworkUrl600)

        FavoritesAPIClient.postFaves(favorite: favorite) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "<3", message: "successfully added to your favorites")

                }
            }
        }
        
    }
    
    
}
