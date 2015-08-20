//
//  DownloadViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/15/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import WebKit

class DownloadViewController: UIViewController, UISearchBarDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var currentProgress: UILabel!
    @IBOutlet weak var totalFileSize: UILabel!
    @IBOutlet weak var downloadView: UIVisualEffectView!
    @IBOutlet weak var backBarView: UIView!
    @IBOutlet weak var ipadButton: UIButton!

    
    var downloadTask: NSURLSessionDownloadTask?
    
    var items = [String]()
    var url: NSURL!
    var fileName = ""
    var req = NSURLRequest()
    var text: String!
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate = self
        statusLabel.text = ""
        navigationBar.frame.size.height = 50
        url = NSURL(string: "http://apple.com")
        req = NSURLRequest(URL:url)
        webView!.loadRequest(req)
        progressBar.progress = 0.0
        //downloadView.frame.origin.y = 900
        //backBarView.backgroundColor = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
        searchBar.backgroundColor = UIColor.clearColor()
            }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       

        searchBar.resignFirstResponder()
        text = searchBar.text!
        
        
        
        if(text.characters.count == 0)
        {
            return
        }
        
        
        if ((text.rangeOfString("http://")) == nil){
            
            text = text.stringByReplacingOccurrencesOfString("", withString: "+")
            url = NSURL(string: "http://".stringByAppendingString(text))
            fileName = url.lastPathComponent!
            
            if ( text.rangeOfString(".com") == nil && text.rangeOfString(".org") == nil && text.rangeOfString(".info") == nil && text.rangeOfString(".net") == nil && text.rangeOfString(".us") == nil ){
                text = text.stringByReplacingOccurrencesOfString(" ", withString: "+")
                url = NSURL(string: "http://google.com/#q=".stringByAppendingString(text))
                fileName = url.lastPathComponent!
                
            }
            
    
        }else{
            url = NSURL(string: text)
            fileName = url.lastPathComponent!
        }
        
        print(url)
        let req = NSURLRequest(URL:url)
        self.webView!.loadRequest(req)
        
        if (text.hasSuffix(".mp4") && text != nil || text.hasSuffix(".mov") && text != nil || text.hasSuffix(".m4v") && text != nil){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Download Availible", message: "\(fileName)", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) { action -> Void in
            //Code for launching the camera goes here
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Download Video", style: .Default) { action -> Void in
            
            UIView.animateWithDuration(1.0,
                delay: 0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    self.downloadView.frame.origin.y = 680
                    
                }, completion: {finish in
            
                    self.statusLabel.text = "Downloading to iPad"
                    self.createDownloadTask()
            
            })
            
            
        }
        actionSheetController.addAction(choosePictureAction)
        
        //We need to provide a popover sourceView when using it on iPad
        actionSheetController.popoverPresentationController?.sourceView = self.ipadButton
        actionSheetController.popoverPresentationController?.sourceRect = self.ipadButton.bounds
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    
        
        }
        
        
        
        
    }
    
    @IBAction func refresh(sender: AnyObject) {
        webView.reload()
        
        if (text.hasSuffix(".mp4") && text != nil || text.hasSuffix(".mov") && text != nil || text.hasSuffix(".m4v") && text != nil){
            
            let actionSheetController: UIAlertController = UIAlertController(title: "Download Availible", message: "\(fileName)", preferredStyle: .ActionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default) { action -> Void in
                //Code for launching the camera goes here
            }
            actionSheetController.addAction(takePictureAction)
            //Create and add a second option action
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Download Video", style: .Default) { action -> Void in
                
                UIView.animateWithDuration(1.0,
                    delay: 0.0,
                    usingSpringWithDamping: 1.0,
                    initialSpringVelocity: 0.5,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        
                        self.downloadView.frame.origin.y = 680
                        
                    }, completion: {finish in
                        
                        self.statusLabel.text = "Downloading to iPad"
                        self.createDownloadTask()
                        
                })
                
                
            }
            actionSheetController.addAction(choosePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = self.ipadButton
            actionSheetController.popoverPresentationController?.sourceRect = self.ipadButton.bounds
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func forward(sender: AnyObject) {
        
        if (webView.canGoForward) {
            webView.goForward()
        }

    }
    
    @IBAction func back(sender: AnyObject) {
        
        if (webView.canGoBack) {
            webView.goBack()
        }
    }
    

    @IBAction func dismissView(sender: AnyObject) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
 
    func createDownloadTask() {
        let downloadRequest = NSMutableURLRequest(URL: url)
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    
        downloadTask = session.downloadTaskWithRequest(downloadRequest)
        downloadTask!.resume()
        
        
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        
        let fileSize = totalBytesExpectedToWrite / 1000000
        print(fileSize)
        
        if(fileSize <= 700){
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressBar.progress = progress
        currentProgress.text = NSString(format: "%.0f %@", progress * 100, "%") as String
        totalFileSize.text = NSString(format: "%.1f MB / %.1f MB", convertFileSizeToMegabyte(Float(totalBytesWritten)), convertFileSizeToMegabyte(Float(totalBytesExpectedToWrite))) as String
        }else
        {
            self.downloadTask!.cancel()
            
            let alertView = UIAlertController(title: "Game Replay", message: "This file is too big to download. Files over 700MB can not be download.", preferredStyle: .Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            presentViewController(alertView, animated: true, completion: nil)
            
            
        }
        
    }
    
    private func convertFileSizeToMegabyte(size: Float) -> Float {
        return (size / 1024) / 1024
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        statusLabel.text = "Download finished"
        statusLabel.frame.origin.x += 10
        
        UIView.animateWithDuration(0.3,
            delay: 1.5,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                
                self.searchBar.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.webView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
            }, completion: nil)
        
       
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        
        let filemgr = NSFileManager.defaultManager()
        
        if (NSFileManager.defaultManager().fileExistsAtPath(docsDir))
        {
            // avoid open add friend
        }
        
        do{
            try filemgr.moveItemAtPath(location.path!, toPath: "\(docsDir)/\(fileName)")
            print("Move successful")
            
            UIView.animateWithDuration(1.0,
                delay: 1.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    
                    self.downloadView.frame.origin.y = 900
                    
                }, completion: nil)

            
        }
        catch{print("Moved failed with error")
        }
        
        
        resetView()
    }


    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let _ = error {
            statusLabel.text = "Download failed"
        } else {
            statusLabel.text = "Download finished"
            
        }
        resetView()
    }



    
    func resetView() {
        downloadTask!.cancel()
    }
    
 


}