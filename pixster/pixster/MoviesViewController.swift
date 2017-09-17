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


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var moviesCollection: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var layoutControl: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    
    var moviesDict: [[String: Any]] = [[String: Any]]()
    var refreshControl = UIRefreshControl()
    var refreshCollectionControl = UIRefreshControl()
    var endpoint: String?
    var navTitle: String?
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data setups
        self.title = navTitle
        moviesTable.dataSource = self
        moviesTable.delegate = self
        moviesCollection.dataSource = self
        moviesCollection.delegate = self
        moviesCollection.isHidden = true
        errorView.isHidden = true
        
        // Customize navigation bar, including list vs grid preference
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.isTranslucent = false
            navigationBar.barStyle = UIBarStyle.black
            navigationBar.titleTextAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin),
                NSForegroundColorAttributeName: UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 13.0/255.0, alpha: 1.0)
            ]
        }
        if !isKeyPresentInUserDefaults(key: "viewPref") {
            defaults.set(0, forKey: "viewPref")
            defaults.synchronize()
        }
        layoutControl.selectedSegmentIndex = defaults.integer(forKey: "viewPref")
        layoutControl.tintColor = UIColor(red: 255.0/255.0, green: 212.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        layoutControl.sizeToFit()
        layoutControl.addTarget(self, action: #selector(layoutChangeAction(_:)), for: .valueChanged)
        layoutChange()
        let layoutButton = UIBarButtonItem(customView: layoutControl)
        navigationItem.rightBarButtonItem = layoutButton
        self.edgesForExtendedLayout = [UIRectEdge.all]
        
        // Set size of TableView and CollectionView
        moviesCollection.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        moviesTable.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        // Calculate cell size to make collection lay out in 3 columns
        let posterwidth = (moviesCollection.frame.width / 3) - 4
        let posterheight = (posterwidth * 1.5) + 30
        let cellSize = CGSize(width: posterwidth, height: posterheight)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        moviesCollection.setCollectionViewLayout(layout, animated: true)
        moviesCollection.reloadData()
        
        // Initialize a UIRefreshControls for both tableview and collectionview
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        refreshCollectionControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTable.insertSubview(refreshControl, at: 0)
        moviesCollection.insertSubview(refreshCollectionControl, at: 0)
        
        networkRequest(endpoint: endpoint!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutControl.selectedSegmentIndex = defaults.integer(forKey: "viewPref")
        layoutChange()
        self.title = navTitle
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
        } else { // this is a TV show
            title = (movie["name"] as? String)!
        }
        
        let storyline = movie["overview"] as? String
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.loadImage(imageVue: cell.posterView, imageUrl: posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        // Customize selected behavior for tableview
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = bgColorView

        cell.titleLabel.text = title
        cell.storylineLabel.text = storyline
        
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesDict.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! MovieCollectionViewCell
        let movie = moviesDict[indexPath.row]
        var title: String
        if endpoint == "movie/now_playing" {
            title = (movie["title"] as? String)!
        } else {
            title = (movie["name"] as? String)!
        }
        
        // Fill the cell with the poster image
        cell.posterView.frame = CGRect(x:0, y:0, width: cell.frame.width, height: cell.frame.height - 30)
        if let posterPath = movie["poster_path"] as? String {
            let posterBaseUrl = "http://image.tmdb.org/t/p/w500"
            let posterUrl = URL(string: posterBaseUrl + posterPath)
            cell.loadImage(imageVue: cell.posterView, imageUrl: posterUrl!)
        }
        else {
            // No poster image. Can either set to nil (no image) or a default movie poster image
            // that you include as an asset
            cell.posterView.image = nil
        }
        
        cell.titleLabel.frame = CGRect(x:0, y: cell.frame.height - 28, width: cell.frame.width, height: 28)
        cell.titleLabel.text = title
        
        return cell

    }
    
    // Customize selected behavior for collectionview
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = moviesCollection.cellForItem(at: indexPath) as! MovieCollectionViewCell
        cell.backgroundColor = UIColor.darkGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = moviesCollection.cellForItem(at: indexPath) as! MovieCollectionViewCell
        cell.backgroundColor = UIColor.black
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
                self.refreshControl.endRefreshing()
                self.refreshCollectionControl.endRefreshing()
                
                // Hide HUD to allow refresh
                MBProgressHUD.hide(for: self.view, animated: true)
            } else {
                self.errorView.isHidden = true
                if let data = dataOrNil {
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    
                    self.moviesDict = dictionary["results"] as! [[String: Any]]
                    self.moviesTable.reloadData()
                    self.moviesCollection.reloadData()
                    self.refreshControl.endRefreshing()
                    self.refreshCollectionControl.endRefreshing()
                    
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
    
    func layoutChange() {
        if layoutControl.selectedSegmentIndex == 0 {
            // List view chosen
            moviesTable.isHidden = false
            moviesCollection.isHidden = true
            defaults.set(0, forKey: "viewPref")
            defaults.synchronize()
        } else {
            // Grid view chosen
            moviesCollection.isHidden = false
            moviesTable.isHidden = true
            defaults.set(1, forKey: "viewPref")
            defaults.synchronize()
        }
    }
    
    @IBAction func layoutChangeAction(_ sender: UISegmentedControl) {
        layoutChange()
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "grid" {
            let cell = sender as! MovieCollectionViewCell
            let indexPath = moviesCollection.indexPath(for: cell)
            let video = moviesDict[indexPath!.item]
            
            var endpointType: String
            if endpoint!.hasPrefix("movie") {
                endpointType = "movie"
            } else {
                endpointType = "tv"
            }
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.video = video
            detailViewController.type = endpointType
        } else if segue.identifier == "list" {
            let cell = sender as! MovieCell
            let indexPath = moviesTable.indexPath(for: cell)
            let video = moviesDict[(indexPath?.row)!]
            
            var endpointType: String
            if endpoint!.hasPrefix("movie") {
                endpointType = "movie"
            } else {
                endpointType = "tv"
            }
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.video = video
            detailViewController.type = endpointType
        }
    }

}
