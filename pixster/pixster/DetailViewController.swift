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
    var movie: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        // Do any additional setup after loading the view.
        var title: String
        if type == "movie" {
            title = (movie["title"] as? String)!
        } else {
            title = (movie["name"] as? String)!
        }
        let storyline = movie["overview"] as? String
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/original"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            posterView.setImageWith(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            posterView.image = nil
        }
        
        titleLabel.text = title
        storylineLabel.text = storyline
        storylineLabel.sizeToFit()
        self.title = title
        
        let barButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: nil)
        barButton.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)], for: UIControlState.normal)
        print (barButton.title!)
        self.navigationItem.backBarButtonItem = barButton
        print (self.navigationItem.backBarButtonItem?.title)
        // self.navigationItem.backBarButtonItem.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)], for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
