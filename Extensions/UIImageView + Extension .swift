//
//  UIImageView + Extension .swift
//  PodcastFavorites demo app
//
//  Created by Margiett Gil on 12/17/19.
//  Copyright © 2019 Margiett Gil. All rights reserved.
//

import UIKit

extension UIImageView {
    // a completion handler, it allows the app to return the information on what is happening in the app if it works or if it was a failure
    //@escaping allows the information to escape to go out ..
  func getImage(with urlString: String,
                completion: @escaping (Result<UIImage, AppError>) -> ()) {
    
    // The UIActivityIndicatorView is used to indicate to the user that a download is in progress
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .orange
    activityIndicator.startAnimating() // it's hidden until we explicitly start animating
    activityIndicator.hidesWhenStopped = true // if the spinning stop it would make it dissapear
    activityIndicator.center = center
    addSubview(activityIndicator) // we add the indicattor as a subview of the image view
    
    // so is searching in the data base to see if it can turn it into a url type and convert it into a urlstring, if is not able to than we will get a badURL
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL(urlString)))
      return
    }
    // if line 25 works (guard let url = URL(string: urlString))now that we have the urlstring, than we can request the data from the url.
    let request = URLRequest(url: url)
    
    NetworkHelper.shared.performDataTask(with: request) { [weak activityIndicator] (result) in
        // it allows the data to download, doesn't matter if is in order or not it would load in the correct cell but allows to download which ever is faster , example like Netflix downloads when you want to down load a whole season some ep dont down load as fast as others, but the ones that don't need so much time or data to download it allows it to
      DispatchQueue.main.async {
        activityIndicator?.stopAnimating() // hides when we stop animating the indicator
      }
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        if let image = UIImage(data: data) {
          completion(.success(image))
        }
      }
    }
  }
}
