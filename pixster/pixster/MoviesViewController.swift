//
//  MoviesViewController.swift
//  pixster
//
//  Created by Angela Yu on 9/12/17.
//  Copyright © 2017 Angela Yu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var moviesDict: [[String: Any]] = [[String: Any]]()
    var refreshControl = UIRefreshControl()
    var endpoint: String?
    var navTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = navTitle
        moviesTable.dataSource = self
        moviesTable.delegate = self
        errorView.isHidden = true
        
        // Initialize a UIRefreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // Add refresh control to the table view
        moviesTable.insertSubview(refreshControl, at: 0)
        
        networkRequest(endpoint: endpoint!)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = moviesDict[indexPath.row]
        var title: String
        if endpoint == "movie/now_playing" {
            title = (movie["title"] as? String)!
        } else {
            title = (movie["name"] as? String)!
        }
        
        let storyline = movie["overview"] as? String
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.posterView.setImageWith(posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = title
        cell.storylineLabel.text = storyline
        
        return cell
    }
    
    func networkRequest(endpoint: String) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/\(endpoint)?api_key=\(apiKey)")
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD just before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                // Display error view
                self.errorView.isHidden = false
                print("Load network error")
                
                // Hide HUD to allow refresh
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                self.errorView.isHidden = true
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    print(dictionary)
                    self.moviesDict = dictionary["results"] as! [[String: Any]]
                    self.moviesTable.reloadData()
                    self.refreshControl.endRefreshing()
                    
                    // Hide HUD once the network request comes back
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        });
        task.resume()
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        networkRequest(endpoint: endpoint!)

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = moviesTable.indexPath(for: cell)
        let movie = moviesDict[indexPath!.row]
        print (movie)
        
        var endpointType: String
        if endpoint!.hasPrefix("movie") {
            endpointType = "movie"
        } else {
            endpointType = "tv"
        }
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        detailViewController.type = endpointType
    }

}
