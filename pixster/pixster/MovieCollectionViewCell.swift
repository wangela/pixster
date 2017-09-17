//
//  MovieCollectionViewCell.swift
//  pixster
//
//  Created by Angela Yu on 9/16/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func loadImage(imageVue: UIImageView, imageUrl: URL) {
        let imageRequest = URLRequest(url: imageUrl)
        
        imageVue.setImageWith(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    imageVue.alpha = 0.0
                    imageVue.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        imageVue.alpha = 1.0
                    })
                } else {
                    imageVue.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
    }
}
