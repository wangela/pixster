//
//  DetailViewController.swift
//  pixster
//
//  Created by Angela Yu on 9/13/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storylineLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var type: String!
    var video: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize navigation bar
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.barStyle = UIBarStyle.black
            navigationBar.titleTextAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin),
                NSForegroundColorAttributeName: UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            ]
        }
        
        // Set sizes of poster and details
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        posterView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        infoView.frame.origin.x = 0
        infoView.frame.origin.y = posterView.frame.height
        infoView.frame.size.width = posterView.frame.width

        // Fill in main content view
        var title: String
        if type == "movie" {
            title = (video["title"] as? String)!
        } else {
            title = (video["name"] as? String)!
        }
        let storyline = video["overview"] as? String
        if let posterPath = video["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/original"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            loadImage(imageVue: posterView, imageUrl: posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            posterView.image = nil
        }
        
        titleLabel.text = title
        storylineLabel.text = storyline
        self.title = title
        
        // Set scrollview content size
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, delay: 0.3, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.infoView.frame.origin.y = (self.posterView.frame.height - 300)
            self.infoView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8)
            
        }, completion: { (finished: Bool) in
            let maxSize = CGSize(width: self.infoView.frame.width, height: 800)
            let storySize = self.storylineLabel.sizeThatFits(maxSize)
            self.storylineLabel.frame = CGRect(origin: CGPoint(x: self.storylineLabel.frame.origin.x, y: self.storylineLabel.frame.origin.y), size: storySize)
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.infoView.frame.origin.y + self.infoView.frame.size.height)

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fade in image
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
