//
//  MoviesViewController.swift
//  MovieViewerAdvanced
//
//  Created by user116136 on 1/30/16.
//  Copyright © 2016 Hannah Werbel. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    var refreshControl: UIRefreshControl!
    var name: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initialization
        self.title = name
        collectionView.dataSource = self
        
        // Set up Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "didRefresh", forControlEvents: .ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        //Load Data
        networkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        
        //Arrange Poster Images
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseURL + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }

        return cell
    }
    
    func networkRequest() {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        //Show Progress Indicator
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                //Hid Progress Indicator
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            //Store Data
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.collectionView.reloadData()
                            self.refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    func didRefresh() {
        
        networkRequest()
        
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailsViewController
        detailViewController.movie = movie
    }


}
