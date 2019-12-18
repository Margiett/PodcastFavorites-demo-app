//
//  FavoriteCell.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var podcastNameLabel: UILabel!
    
    var favorite: Favorite?
    
    func configureCell(for fave: Favorite){
        podcastNameLabel.text = fave.collectionName
        
        //Memory mangement - we need to handle retain cycles here
        // we can archieve this by using a capture list example [unownd self] or [weak self] \
        // !!! ALWAYS REMEMBER THE COLONS AFTER THE CASE IN A SWITCH STATMENT !!!!!
        
        // what is this doing ?????
        //
        podcastImage.getImage(with: fave.artworkUrl600) { [weak self] (result) in
            
            // this is a UI update
            // you about to update a UI on a non UI thread
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.podcastImage.image = UIImage(systemName: "headphones")
                }
            case .success(let image):
                //MARK: UPDATE ANY UI ELEMENTS ON THE MAIN THREAD
                DispatchQueue.main.async {
                    //MARK: UI updates goes here
                    self?.podcastImage.image = image
                }
            }
        }
    }
    
}

