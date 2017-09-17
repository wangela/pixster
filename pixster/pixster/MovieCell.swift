//
//  MovieCell.swift
//  pixster
//
//  Created by Angela Yu on 9/12/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storylineLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

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
