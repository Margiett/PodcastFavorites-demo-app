//
//  Favorite.swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import Foundation

struct Favorite: Codable {
    let trackId : Int
    let favoritedBy: String
    let collectionName: String
    let artworkUrl600: String
}
