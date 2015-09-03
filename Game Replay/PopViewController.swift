//
//  PopViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/25/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {

    @IBOutlet weak var trailButton: UIButton!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var leadButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 800, height: 300)
        trailButton.layer.cornerRadius = 10
        trailButton.layer.borderWidth = 1
        trailButton.layer.borderColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 ).CGColor
        centerButton.layer.cornerRadius = 10
        centerButton.layer.borderWidth = 1
        centerButton.layer.borderColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 ).CGColor
        leadButton.layer.cornerRadius = 10
        leadButton.layer.borderWidth = 1
        leadButton.layer.borderColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 ).CGColor
        yesButton.layer.borderColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 ).CGColor
        yesButton.layer.cornerRadius = 10
        yesButton.layer.borderWidth = 1
        noButton.layer.cornerRadius = 10
        noButton.layer.borderWidth = 1
        noButton.layer.borderColor = UIColor ( red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0 ).CGColor


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
