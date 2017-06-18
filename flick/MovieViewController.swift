//
//  MovieViewController.swift
//  flick
//
//  Created by phungducchinh on 6/14/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit
import AFNetworking
class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    //var array:[Int] = [1, 2, 3]
    var movies = [NSDictionary] ()
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var refreshControl : UIRefreshControl!
    
    var selectedUrl = ""
    var selectedOverview = ""
    var selectedtitleLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", for: UIControlEvents.valueChanged)
        //refreshControl.addTarget(self, action: #selector(ViewController.refreshData(sender:)), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
 //     loadData()
        fetchMovies()
    }
    
//    func refresh(sender:AnyObject) {
//        self.loadData()
//    }
//    
//    func loadData() {
////        url.getFeedItems({ (items, error) in
////            if error != nil {
////                let alert = UIAlertController(title: "Error", message: "Could not load stock quotes \(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
////                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
////                self.presentViewController(alert, animated: true, completion: nil)
////            }
////            self.itemsArray = items
////            
////            // tell refresh control it can stop showing up now
//            if self.refreshControl.beginRefreshing() as! Bool
//            {
//                self.refreshControl.endRefreshing()
//            }
//            
//            self.tableView?.reloadData()
//        
//    }

    func fetchMovies(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(
            url: url!,
            cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        let task: URLSessionDataTask =
            session.dataTask(with: request,
                             completionHandler: { (dataOrNil, response, error) in
                                if let data = dataOrNil {
                                    if let responseDictionary = try! JSONSerialization.jsonObject(
                                        with: data, options:[]) as? NSDictionary {
                                        print("response: \(responseDictionary)")
                                        self.movies = responseDictionary["results"] as! [NSDictionary]
                                        self.tableView.reloadData()
                                    }
                                }
            })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let cell = UITableViewCell()
        //cell.textLabel?.text = movies[indexPath.row]["title"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as! MoviesCell
        cell.titleLabel.text = movies[indexPath.row]["title"] as! String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as! String
        
        let imgUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)

        
        cell.posterImage.setImageWith(NSURL(string: imgUrl) as! URL)

        return cell
    }
    
//    func refresh(){
//        tableView.reloadData()
//        //refreshControl.endRefreshing()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        selectedOverview = movies[indexPath.row]["overview"] as! String
        selectedtitleLabel = movies[indexPath.row]["title"] as! String

        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let nextVC = segue.destination as! DetailsViewController
        
        nextVC.imgUrl = selectedUrl
        nextVC.overview = selectedOverview
        nextVC.titleLb = selectedtitleLabel
    }
 

}
