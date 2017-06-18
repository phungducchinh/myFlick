//
//  DetailsViewController.swift
//  flick
//
//  Created by phungducchinh on 6/16/17.
//  Copyright © 2017 phungducchinh. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var datailLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scroolView: UIScrollView!
    
    var imgUrl = ""
    var overview = ""
    var titleLb = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        scroolView.contentSize = CGSize(width: scroolView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        
        // Do any additional setup after loading the view.
        
        //posterImage.setImageWith(NSURL(String: imgUrl) as! URL)
        posterImage.setImageWith(NSURL(string: imgUrl) as! URL)
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        datailLabel.text = titleLb
        datailLabel.sizeToFit()
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
