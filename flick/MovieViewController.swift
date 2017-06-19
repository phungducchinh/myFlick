//
//  MovieViewController.swift
//  flick
//
//  Created by phungducchinh on 6/14/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movies = [NSDictionary] ()
    let baseUrl = "http://image.tmdb.org/t/p/w500"
    var refreshControl = UIRefreshControl()
    var url = URL(string: "")
    var selectedUrl = ""
    var selectedOverview = ""
    var selectedtitleLabel = ""
    var selecteddateLabel = ""
    var selectedVote : Double = 0.0
    var searchbarNav = UISearchBar()
    var search = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(MovieViewController.fetchMovies), for: UIControlEvents.valueChanged)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        
            tableView.addSubview(refreshControl)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MBProgressHUD.hide(for: self.view, animated: true)
        checkConnection()
        searchBar()
     
    }


    func fetchMovies(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if tabBarController?.selectedIndex == 0{
            url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }else {
            url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        }
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
                                         MBProgressHUD.hide(for: self.view, animated: true)
                                        self.refreshControl.endRefreshing()
                                        
                                    }
                                    else {
                                       self.tableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                        
                                    }
                                }
            })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func checkConnection(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status: AFNetworkReachabilityStatus?) in
            switch status!.hashValue{
            case AFNetworkReachabilityStatus.notReachable.hashValue:
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                MBProgressHUD.hide(for: self.view, animated: true)
                print("No Internet Connection")
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                break;
            case AFNetworkReachabilityStatus.reachableViaWiFi.hashValue,AFNetworkReachabilityStatus.reachableViaWWAN.hashValue:
                self.fetchMovies()
                self.refreshControl.endRefreshing()
                break;
            default:
                print("unknown")
            }
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let cell = UITableViewCell()
        //cell.textLabel?.text = movies[indexPath.row]["title"] as! String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell") as! MoviesCell
        cell.titleLabel.text = movies[indexPath.row]["title"] as! String
        cell.overviewLabel.text = movies[indexPath.row]["overview"] as! String
        let imgUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        cell.posterImage.setImageWith(NSURL(string: imgUrl) as! URL)
        
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = backgroundView

               
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = baseUrl + (movies[indexPath.row]["poster_path"] as! String)
        selectedOverview = movies[indexPath.row]["overview"] as! String
        selectedtitleLabel = movies[indexPath.row]["title"] as! String
        selecteddateLabel = movies[indexPath.row]["release_date"] as! String
        selectedVote = movies[indexPath.row]["vote_average"] as! Double
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func searchBar(){
        searchbarNav = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        searchbarNav.showsCancelButton = true
        searchbarNav.placeholder = "Enter search your here"
        
        //searchbarNav.delegate = self as! UISearchBarDelegate
        searchbarNav.showsScopeBar = true
        searchbarNav.tintColor = UIColor.lightGray
        self.navigationItem.titleView = searchbarNav
        search = searchbarNav.text!
        print(search)
        
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
        nextVC.dateLb = selecteddateLabel
        nextVC.voteLb = selectedVote
    }
 

}
