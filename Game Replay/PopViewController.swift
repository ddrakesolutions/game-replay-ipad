//
//  PopViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/25/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import AVFoundation

class PopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    var mainView = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "PopTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(documentsDirectory)
        
        while let file = files!.nextObject() as? String {
            if file.hasSuffix("mp4") || file.hasSuffix("mov") || file.hasSuffix("m4v") || file.hasSuffix("MP4") || file.hasSuffix("MOV") || file.hasSuffix("M4V") {
                data.append(file)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = (tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell?)!
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.clearColor()
        }else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        cell.textLabel?.text = self.data[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        gameForInsert = data[indexPath.row]
    }
    

    

}
