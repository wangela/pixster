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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        moviesTable.dataSource = self
        moviesTable.delegate = self
        errorView.isHidden = true
        
        // Load the movies list from The Movie DB API into an array of dicitionaries
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
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
                    
                    // Hide HUD once the network request comes back
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        });
        task.resume()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // Add refresh control to the table view
        moviesTable.insertSubview(refreshControl, at: 0)
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
        let title = movie["title"] as? String
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

    // Makes a netwwork request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Configure the session so that completion handler is executed on main UI thread
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        var myRequest = URLRequest(url: url!)
        myRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        // Display HUD just before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task: URLSessionTask = session.dataTask(with: myRequest) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                // Display error view
                self.errorView.isHidden = false
                print("Refresh network error")
                
                // Hide HUD to allow another refresh
                MBProgressHUD.hide(for: self.view, animated: true)
                refreshControl.endRefreshing()
            } else {
                // ... Use the new data to update the data source ...
                self.errorView.isHidden = true
                if let newData = data {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: newData, options: []) as! [String:Any]
                    
                    print(dictionary)
                    self.moviesDict = dictionary["results"] as! [[String: Any]]
                    
                    // Reload the tableView now that there is new data
                    self.moviesTable.reloadData()
                    
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                    
                    // Hide HUD once the network request comes back
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }

        }
        task.resume()
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
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }

}
