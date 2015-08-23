//
//  MainViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 7/2/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreMedia
import QuartzCore
import MessageUI
import CoreData

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var playerScrollView: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var ff: UIButton!
    @IBOutlet weak var stepOne: UIButton!
    @IBOutlet weak var rewd: UIButton!
    @IBOutlet weak var stepBack: UIButton!
    @IBOutlet weak var visualForEdit: UIVisualEffectView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var emailClip: UIButton!
    @IBOutlet weak var saveClip: UIButton!
    @IBOutlet weak var startOver: UIButton!
    @IBOutlet weak var saveAndEmail: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var markPlayButton: UIButton!
    @IBOutlet weak var actionViewContainer: UIVisualEffectView!
    @IBOutlet weak var backVisualEffect: UIVisualEffectView!
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var gameScrollView: UIScrollView!
    @IBOutlet weak var playerScrollViewVisualEffectContainer: UIView!
    @IBOutlet weak var statsView: StatView!
    
    
    // MARK: - Variables
    let imagePicker = UIImagePickerController()
    var url = NSURL()
    var player : AVPlayer!
    let playerLayer = AVPlayerLayer()
    var hasURL : Bool!
    var playerItem : AVPlayerItem!
    var asset : AVURLAsset!
    var timer = NSTimer()
    var updateTimer = NSTimer()
    var durationTime : Float64 = 0.0
    var currentTime : Float64 = 0.0
    var slideTimer = NSTimer()
    var markEdit: Float64 = 0.0
    var endEdit: Float64 = 0.0
    var isMarked = false
    var item : AVPlayerItem!
    var inEditMode = false
    var doubleTapGesture = UITapGestureRecognizer()
    var leftSwipe = UIPanGestureRecognizer()
    var rightSwipe = UIPanGestureRecognizer()
    var leftSwipeFast = UIPanGestureRecognizer()
    var rightSwipeFast = UIPanGestureRecognizer()
    let checkTime : CMTime = CMTime()
    var isPlaying = false
    let prefs = NSUserDefaults.standardUserDefaults()
    var originNum : CGFloat = 0
    var views = [UIView]()
    var numOfViews : CGFloat = 1
    var games = [String]()
    var bgImages = [UIImage]()

    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        statsView.backgroundColor = UIColor.clearColor()
        stepBack.hidden = true
        stepOne.hidden = true
        ff.hidden = true
        rewd.hidden = true
        pauseButton.hidden = true
        markPlayButton.hidden = true
        playButton.hidden = true
        pauseButton.hidden = true
        gameScrollView.minimumZoomScale = 1.0
        gameScrollView.maximumZoomScale = 3.0
        hasURL = false
        currentTimeLabel.text = "0:00"
        totalTimeLabel.text = "0:00"
        videoSlider.value = 0
        videoSlider.minimumValue = 0
        videoSlider.maximumValue = 1
        videoSlider.setThumbImage(UIImage(named: "slider.png"), forState: .Normal)
        videoSlider.setMaximumTrackImage(UIImage(named: "back.png"), forState: .Normal)
        videoSlider.setMinimumTrackImage(UIImage(named: "back.png"), forState: .Normal)
        videoSlider.enabled = false
        doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("markForEdit"))
        doubleTapGesture.numberOfTapsRequired = 2
        leftSwipe = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        rightSwipe = UIPanGestureRecognizer(target: self, action: Selector("handlePan:"))
        leftSwipe.minimumNumberOfTouches = 1
        rightSwipe.minimumNumberOfTouches = 1
        leftSwipeFast = UIPanGestureRecognizer(target: self, action: Selector("handlePanx2:"))
        rightSwipeFast = UIPanGestureRecognizer(target: self, action: Selector("handlePanx2:"))
        leftSwipeFast.minimumNumberOfTouches = 2
        rightSwipeFast.minimumNumberOfTouches = 2
        visualForEdit.hidden = true
        startOver.hidden = true
        emailClip.hidden = true
        saveClip.hidden = true
        saveAndEmail.hidden = true
        bottomView.layer.masksToBounds = true
        actionView.hidden = true
        progressView.hidden = true
        progressView.alpha = 0.0
        actionView.layer.masksToBounds = true
        actionView.layer.cornerRadius = 10.0
        gameScrollView.delegate = self
        gameScrollView.scrollEnabled = true
        gameScrollView.hidden = true
 
        
}
    
    override func viewDidDisappear(animated: Bool) {
        

        originNum = 0
        numOfViews = 1
        
            
     for view in playerScrollViewVisualEffectContainer.subviews{
        
                    view.removeFromSuperview()
                    views.removeAll()
                    games.removeAll()
                    bgImages.removeAll()
                print("Removing...")
        
        }
    }

    
    
    override func viewWillAppear(animated: Bool) {
        

        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(documentsDirectory)
        
        while let file = files!.nextObject() as? String {
            if file.hasSuffix("mp4") || file.hasSuffix("mov") || file.hasSuffix("m4v") || file.hasSuffix("MP4") || file.hasSuffix("MOV") || file.hasSuffix("M4V") {
                
                
                var url = NSURL()
                let asset : AVURLAsset!
                let v = UIView()
                let imageView = UIImageView()
                let importButton = UIButton()
                let deleteButton = UIButton()
                let gameName : String = "\(file)"
                
                
                games.append(gameName)
                
                importButton.frame = CGRectMake(0, 0, 1024, 562)
                importButton.backgroundColor = UIColor.clearColor();
                importButton.tag = Int(numOfViews)
                importButton.addTarget(self, action: Selector("insertVideoToView:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                deleteButton.frame = CGRectMake(0, 0, 150, 100)
                deleteButton.backgroundColor = UIColor.redColor();
                deleteButton.tag = Int(numOfViews)
                deleteButton.addTarget(self, action: Selector("deleteVideo:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                imageView.frame = CGRectMake(0, 0, 1024, 562)
                v.frame = CGRectMake(originNum, 0, 1024, 562)
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0] as String
                
                url = NSURL(fileURLWithPath: "\(docsDir)/\(file)")
                let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
                asset = AVURLAsset(URL: url, options: options)
                do{
                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    let time: CMTime = CMTimeMake(0, 1)
                    let img : CGImageRef = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
                    
                    let frameImg : UIImage = UIImage(CGImage: img)
                    
                    imageView.image = frameImg
                    
                    bgImages.append(frameImg)
                    
                } catch{}
                
                let imgBg = imageView
                imgBg.frame = CGRectMake(numOfViews, 0, 1024, 562)
                
                v.tag = Int(numOfViews)
                numOfViews++
                views.append(v)
                playerScrollViewVisualEffectContainer.addSubview(imageView)
                playerScrollViewVisualEffectContainer.addSubview(v)
                v.addSubview(imageView)
                v.addSubview(importButton)
                v.addSubview(deleteButton)
                self.originNum += 1024
                
            }
        }
       

    }
    
    

    @IBAction func viewStats(sender: AnyObject) {
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.statsView.frame.origin.y = 0
            }, completion: nil)
    }
    
    
    
    func deleteVideo(sender: UIButton) {
        
        print(sender.tag)
        
        UIView.animateWithDuration(0.4,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                for view in self.playerScrollViewVisualEffectContainer.subviews {
                    
                    view.viewWithTag(sender.tag)?.alpha = 0.0
                    
                }
            }, completion: nil)
        
        
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        let filemanager:NSFileManager = NSFileManager()
        let files = filemanager.enumeratorAtPath(documentsDirectory)
        
        print("\(documentsDirectory)/\(games[sender.tag-1])")
        originNum = 0
        numOfViews = 1
        
        
        
        do{
        try filemanager.removeItemAtPath("\(documentsDirectory)/\(games[sender.tag-1])")
            print("Remove successful")
        }
        catch{print("Remove failed.")}
        
        for view in playerScrollViewVisualEffectContainer.subviews{
            
        
            view.removeFromSuperview()
            views.removeAll()
            games.removeAll()
            bgImages.removeAll()
            print("Removing...")
            
            
            
        }
        
        
        while let file = files!.nextObject() as? String {
            if file.hasSuffix("mp4") || file.hasSuffix("mov") || file.hasSuffix("m4v") || file.hasSuffix("MP4") || file.hasSuffix("MOV") || file.hasSuffix("M4V") {
                
                
                var url = NSURL()
                let asset : AVURLAsset!
                let v = UIView()
                let imageView = UIImageView()
                let importButton = UIButton()
                let deleteButton = UIButton()
                let gameName : String = "\(file)"
                
                
                games.append(gameName)
                
                importButton.frame = CGRectMake(0, 0, 1024, 562)
                importButton.backgroundColor = UIColor.clearColor();
                importButton.tag = Int(numOfViews)
                importButton.addTarget(self, action: Selector("insertVideoToView:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                deleteButton.frame = CGRectMake(0, 0, 150, 100)
                deleteButton.backgroundColor = UIColor.redColor();
                deleteButton.tag = Int(numOfViews)
                deleteButton.addTarget(self, action: Selector("deleteVideo:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                imageView.frame = CGRectMake(0, 0, 1024, 562)
                v.frame = CGRectMake(originNum, 0, 1024, 562)
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0] as String
                
                url = NSURL(fileURLWithPath: "\(docsDir)/\(file)")
                let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
                asset = AVURLAsset(URL: url, options: options)
                do{
                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    let time: CMTime = CMTimeMake(0, 1)
                    let img : CGImageRef = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
                    
                    let frameImg : UIImage = UIImage(CGImage: img)
                    
                    imageView.image = frameImg
                    
                    bgImages.append(frameImg)
                    
                } catch{}
                
                let imgBg = imageView
                imgBg.frame = CGRectMake(numOfViews, 0, 1024, 562)
                
                v.tag = Int(numOfViews)
                numOfViews++
                views.append(v)
                playerScrollViewVisualEffectContainer.addSubview(imageView)
                playerScrollViewVisualEffectContainer.addSubview(v)
                v.addSubview(imageView)
                v.addSubview(importButton)
                v.addSubview(deleteButton)
                self.originNum += 1024
                
            }
        }

        for view in playerScrollViewVisualEffectContainer.subviews {
            view.transform = CGAffineTransformMakeScale(0.6, 0.6)
            
        }
        self.playerScrollView.contentSize = CGSizeMake(1024 * (self.numOfViews-1), 562)
        self.backVisualEffect.frame.size = CGSizeMake(1024 * (self.numOfViews-1), 562)
        
        if(numOfViews == 1){
            print("NO MORE VIDEOS")
            self.backVisualEffect.frame.size = CGSizeMake(1024, 562)
        }
        
        
            }
    
    
    func insertVideoToView(sender: UIButton) {
        
        
        stepBack.hidden = false
        stepOne.hidden = false
        ff.hidden = false
        rewd.hidden = false
        markPlayButton.hidden = false
        playButton.hidden = false
        let gameTag = sender.tag
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        url = NSURL(fileURLWithPath: "\(docsDir)/\(games[gameTag-1])")
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        asset = AVURLAsset(URL: url, options: options)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.frame = CGRectMake(0, 0, 1024, 562)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.layer.addSublayer(playerLayer)
        hasURL = true
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        videoSlider.enabled = true
        gameName.text = "\(games[gameTag-1])"
        bgView.image = bgImages[gameTag-1]
        view.tag = 10
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                for view in self.views {
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                }
            }, completion: nil)
        gameScrollView.hidden = false
        playerScrollView.scrollEnabled = false
        

        
    }
   
    

    
    /*-----------------------------------------------------------------*/
    
    // MARK: - Update Timer
    
    func updateTime(){
        
        durationTime = CMTimeGetSeconds(self.playerItem.duration) / 60
        currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
        let durationMinString = NSString(format: "%.2f", durationTime)
        let currentMinString = NSString(format: "%.2f", currentTime)
        self.totalTimeLabel.text = durationMinString as String
        self.currentTimeLabel.text = currentMinString as String
        let test = Float(CMTimeGetSeconds(self.playerItem.currentTime())/CMTimeGetSeconds(self.playerItem.duration))
        self.videoSlider.value = test
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
            
    @IBAction func startover(sender: AnyObject) {
        
        markEdit = 0.0
        endEdit = 0.0
        isMarked = false
        playerView.addGestureRecognizer(leftSwipe)
        playerView.addGestureRecognizer(rightSwipe)
        playerView.addGestureRecognizer(leftSwipeFast)
        playerView.addGestureRecognizer(rightSwipeFast)
        playerView.addGestureRecognizer(doubleTapGesture)
       
        
        UIView.animateWithDuration(0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.actionView.frame.origin.y = 150
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.actionView.frame.origin.y = 1000
            }, completion: { finished in
        self.actionView.hidden = true
        
        })
    
        
    }
    
    @IBAction func selectVideo(sender: AnyObject) {
    
        gameScrollView.hidden = true
        stepBack.hidden = true
        stepOne.hidden = true
        ff.hidden = true
        rewd.hidden = true
        pauseButton.hidden = true
        markPlayButton.hidden = true
        playButton.hidden = true
        pauseButton.hidden = true
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                for view in self.views {
                    view.transform = CGAffineTransformMakeScale(0.6, 0.6)
                }
                self.playerScrollView.contentSize = CGSizeMake(1024 * (self.numOfViews-1), 562)
                if(self.numOfViews == 1){
                    print("NO MORE VIDEOS")
                    self.backVisualEffect.frame.size = CGSizeMake(1024, 562)
                }else
                {
                self.backVisualEffect.frame.size = CGSizeMake(1024 * (self.numOfViews-1), 562)
                self.playerScrollView.scrollEnabled = true
                }

            }, completion: nil)
    }



    @IBAction func emailClip(sender: AnyObject) {
    
        if(inEditMode && markEdit != 0.00 && endEdit != 0.00) {
    
    
            let assetVideoTrack: AVAssetTrack = asset.tracksWithMediaType(AVMediaTypeVideo).first!
            
            let comp = AVMutableComposition()
            let comptrack = comp.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let time1 = CMTimeMakeWithSeconds(markEdit,playerItem.currentTime().timescale)
            let time2 = CMTimeMakeWithSeconds(endEdit,playerItem.currentTime().timescale)
            let durationOfCurrentSlice = CMTimeSubtract(time2, time1)
            let timeRangeForCurrentSlice = CMTimeRangeMake(time1, durationOfCurrentSlice)
            do {
                try comptrack.insertTimeRange(timeRangeForCurrentSlice, ofTrack:assetVideoTrack, atTime: kCMTimeZero)
            } catch _ {
                print("Error Inserting Time Range into AssetVideoTrack")
            }
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir = dirPaths[0] as String
            let completeMovie = docsDir.stringByAppendingString("/movie.mov")
            let completeMovieUrl = NSURL(fileURLWithPath: completeMovie)
            let exporter = AVAssetExportSession(asset: comp, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = completeMovieUrl
            exporter!.outputFileType = AVFileTypeMPEG4
            exporter!.exportAsynchronouslyWithCompletionHandler({
                switch exporter!.status{
                case  AVAssetExportSessionStatus.Failed:
                    print("Video Failed to Save \(exporter!.error)")
                case AVAssetExportSessionStatus.Cancelled:
                    print("Video Cancelled \(exporter!.error)")
                default:
                    print("Video Successfully Saved")
                    if( MFMailComposeViewController.canSendMail() ) {
                        print("Can send email.")
                        
                        let mailComposer = MFMailComposeViewController()
                        mailComposer.mailComposeDelegate = self
                        
                        //Set the subject and message of the email
                        mailComposer.setSubject("Game Replay Video Clip")
                        mailComposer.setMessageBody("Please take a look at this play.", isHTML: false)
                        
                        if let fileData = NSData(contentsOfFile: "\(completeMovie)") {
                            print("File data loaded.")
                            mailComposer.addAttachmentData(fileData, mimeType: "video/quicktime", fileName: "video.mov")
                        }
                        
                        self.presentViewController(mailComposer, animated: true, completion: nil)
                    }
                }
            })
            
        }

        
    }
    
    

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        self.dismissViewControllerAnimated(true, completion: {
            
            UIView.transitionWithView(self.visualForEdit, duration: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                let transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.visualForEdit.transform = transform
                self.editButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
                self.editButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.videoSlider.frame.origin.y = 20
                self.currentTimeLabel.frame.origin.y = 20
                self.totalTimeLabel.frame.origin.y = 20
                
                }, completion: nil)
            self.stepBack.hidden = false
            self.stepOne.hidden = false
            self.ff.hidden = false
            self.rewd.hidden = false
            self.playButton.hidden = false
            self.markPlayButton.hidden = false
            self.videoSlider.enabled = true
            self.startOver.hidden = true
            self.emailClip.hidden = true
            self.saveClip.hidden = true
            self.saveAndEmail.hidden = true
            self.importButton.alpha = 1.0
            self.statsButton.alpha = 1.0
           
            self.actionView.hidden = true
        
            
            self.playerView.removeGestureRecognizer(self.leftSwipe)
            self.playerView.removeGestureRecognizer(self.rightSwipe)
            self.playerView.removeGestureRecognizer(self.leftSwipeFast)
            self.playerView.removeGestureRecognizer(self.rightSwipeFast)
            self.playerView.removeGestureRecognizer(self.doubleTapGesture)
            self.inEditMode = false
            self.isMarked = false
            self.visualForEdit.hidden = true
            self.playerScrollView.minimumZoomScale = 1.0
            self.playerScrollView.maximumZoomScale = 3.0
            let filemgr = NSFileManager.defaultManager()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir = dirPaths[0] as String
            let filePath = "\(docsDir)/movie.mov"
            do {
                try filemgr.removeItemAtPath(filePath)
                print("Remove successful")
            }
            catch { print("Remove failed") }
        })
        self.actionView.frame.origin.y = 1000        
        
    }
    

    @IBAction func dismissMarkView(sender: AnyObject) {
        
        UIView.transitionWithView(visualForEdit, duration: 0.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.visualForEdit.alpha = 0.0
            self.videoSlider.frame.origin.y = 900
            self.currentTimeLabel.frame.origin.y = 900
            self.totalTimeLabel.frame.origin.y = 900
            }, completion: nil)
        
        prefs.setValue("true", forKey: "dontShowAgain")
        
    }


    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        
        
        if (!isMarked){
            
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                {
                    dispatch_async(dispatch_get_main_queue(), {
                    
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForward"), userInfo: nil, repeats: false)
                })
                        
                        }
                        
                else
                {

                    dispatch_async(dispatch_get_main_queue(), {
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewind"), userInfo: nil, repeats: false)
                })
                    }
            }
            
            
            
        } else {
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                    
                {
                    
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForward"), userInfo: nil, repeats: false)
                    
                }
                else
                {
                    
                    let checkTime = CMTimeGetSeconds(self.playerItem.currentTime())
                    
                    if (checkTime <= markEdit){
                        return
                    }
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewind"), userInfo: nil, repeats: false)
                    
                }
            }
            
        }
        
        
    }
    
    
    func handlePanx2(gestureRecognizer: UIPanGestureRecognizer) {
        
        
        if (!isMarked){
            
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                {
        
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForwardx2"), userInfo: nil, repeats: false)
     
                }
                else
                {
                    
                    
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewindx2"), userInfo: nil, repeats: false)

                }
            }
            
            
            
        } else {
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                    
                {
                    
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForwardx2"), userInfo: nil, repeats: false)
                    
                }
                else
                {
                    
                    let checkTime = CMTimeGetSeconds(self.playerItem.currentTime())
                    
                    if (checkTime <= markEdit){
                        return
                    }
                    self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                    let currentMinString = NSString(format: "%.2f", self.currentTime)
                    self.currentTimeLabel.text = currentMinString as String
                    self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewindx2"), userInfo: nil, repeats: false)
                    
                }
            }
            
        }
        
        
    }
   
    
    @IBAction func editVideo(sender: UIButton) {
        
        if(!inEditMode){
            
            videoSlider.enabled = false
            markEdit = 0.0
            endEdit = 0.0
            if let dontShowAgain = prefs.objectForKey("dontShowAgain"){
                if dontShowAgain as! String == "false" {
                    
                    
                    self.visualForEdit.alpha = 1.0
                    self.visualForEdit.transform = CGAffineTransformMakeScale(10.0, 10.0)
                    self.visualForEdit.hidden = false
                    UIView.transitionWithView(visualForEdit, duration: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                        let transform = CGAffineTransformMakeScale(1.0, 1.0)
                        self.visualForEdit.transform = transform
                        self.editButton.setTitleColor(UIColor(red: 158/255, green: 66/255, blue: 66/255, alpha: 1), forState: .Normal)
                        self.importButton.alpha = 0.3
                        self.statsButton.alpha = 0.3
                        }, completion:nil)
                
                }else {UIView.animateWithDuration(0.2, animations:{
                    self.editButton.setTitleColor(UIColor(red: 158/255, green: 66/255, blue: 66/255, alpha: 1), forState: .Normal)
                    self.importButton.alpha = 0.3
                    self.statsButton.alpha = 0.3
                    self.visualForEdit.alpha = 0.0
                    self.videoSlider.frame.origin.y = 900
                    self.currentTimeLabel.frame.origin.y = 900
                    self.totalTimeLabel.frame.origin.y = 900
                })}
                
            }else
            {
                self.visualForEdit.alpha = 1.0
                self.visualForEdit.transform = CGAffineTransformMakeScale(10.0, 10.0)
                self.visualForEdit.hidden = false
                UIView.transitionWithView(visualForEdit, duration: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    let transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.visualForEdit.transform = transform
                    self.editButton.setTitleColor(UIColor(red: 158/255, green: 66/255, blue: 66/255, alpha: 1), forState: .Normal)
                    self.importButton.alpha = 0.3
                    self.statsButton.alpha = 0.3
                    }, completion:nil)
            }

            
            print("turning on editing")
            stepBack.hidden = true
            stepOne.hidden = true
            ff.hidden = true
            rewd.hidden = true
            pauseButton.hidden = true
            markPlayButton.hidden = true
            pauseVideo()
            playButton.hidden = true
            playerView.addGestureRecognizer(leftSwipe)
            playerView.addGestureRecognizer(rightSwipe)
            playerView.addGestureRecognizer(leftSwipeFast)
            playerView.addGestureRecognizer(rightSwipeFast)
            playerView.addGestureRecognizer(doubleTapGesture)
            inEditMode = true
            playerScrollView.minimumZoomScale = 0.0
            playerScrollView.maximumZoomScale = 0.0


        }
        else {
            
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.videoSlider.frame.origin.y = 20
                self.currentTimeLabel.frame.origin.y = 20
                self.totalTimeLabel.frame.origin.y = 20
                
                }, completion: nil)
            
            startOver.hidden = true
            emailClip.hidden = true
            saveClip.hidden = true
            saveAndEmail.hidden = true
            
            actionView.hidden = true
           
            

            UIView.transitionWithView(visualForEdit, duration: 0.2, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                let transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.visualForEdit.transform = transform
                self.editButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
                self.importButton.alpha = 1.0
                self.statsButton.alpha = 1.0
                }, completion: nil)
            
            videoSlider.enabled = true
            print("turning off editing")
            self.visualForEdit.hidden = true
            //self.editModeView.hidden = true
            stepBack.hidden = false
            stepOne.hidden = false
            ff.hidden = false
            rewd.hidden = false
            playButton.hidden = false
            markPlayButton.hidden = false
            playerView.removeGestureRecognizer(leftSwipe)
            playerView.removeGestureRecognizer(rightSwipe)
            playerView.removeGestureRecognizer(leftSwipeFast)
            playerView.removeGestureRecognizer(rightSwipeFast)
            playerView.removeGestureRecognizer(doubleTapGesture)
            inEditMode = false
            isMarked = false
            playerScrollView.minimumZoomScale = 1.0
            playerScrollView.maximumZoomScale = 3.0
            progressView.layer.masksToBounds = true
        
        }
}
    
    func markForEdit(){
        
        if (!isMarked){
            markEdit = CMTimeGetSeconds(self.playerItem.currentTime())
            isMarked = true
            progressView.reset()
            progressView.alpha = 1.0
            progressView.hidden = false
            progressView.animateProgressView()
            
            UIView.animateWithDuration(2.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                
                     self.progressView.alpha = 0.0
                
                }, completion: nil)
            
            
        }else {

            endEdit = CMTimeGetSeconds(self.playerItem.currentTime())
           
            self.actionView.frame.origin.y = 1000
            actionView.hidden = false
           
            
            UIView.animateWithDuration(0.2, delay: 2.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                self.startOver.hidden = false
                self.emailClip.hidden = false
                self.saveClip.hidden = false
                self.saveAndEmail.hidden = false
                self.playerView.removeGestureRecognizer(self.leftSwipe)
                self.playerView.removeGestureRecognizer(self.rightSwipe)
                self.playerView.removeGestureRecognizer(self.leftSwipeFast)
                self.playerView.removeGestureRecognizer(self.rightSwipeFast)
                self.playerView.removeGestureRecognizer(self.doubleTapGesture)
                self.progressView.hidden = true
                
                }, completion:nil)
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { [unowned self] in
                    self.actionView.frame.origin.y = 200
                }, completion: nil)
            
}

    
    }

    
    // MARK: - Zoom View
    
    func viewForZoomingInScrollView(scrollView : UIScrollView) -> UIView? {
        return playerView
    }
    
    // MARK: - Image Picker
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        url = info[UIImagePickerControllerReferenceURL] as! NSURL
        asset = AVURLAsset(URL: url, options: nil)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.frame = CGRectMake(0, 0, 1024, 562)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        hasURL = true
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        self.dismissViewControllerAnimated(true, completion: {
            self.videoSlider.enabled = true
        })
    
    }
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    

    
       // MARK: - Play/Pause
    
    @IBAction func playVideo(sender: AnyObject) {
        
        if(hasURL!){
        player.play()
        playButton.hidden = true
        pauseButton.hidden = false
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        stepBack.alpha = 0.25
        stepOne.alpha = 0.25
        ff.alpha = 0.25
        rewd.alpha = 0.25
        markPlayButton.alpha = 0.25
        isPlaying = true
        }
        else {
            let alertView = UIAlertController(title: "Game Replay", message: "Please select a video.", preferredStyle: .Alert)
            
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func pauseVideo() {
        player.pause()
        playButton.hidden = false
        pauseButton.hidden = true
        updateTimer.invalidate()
        stepBack.alpha = 1.0
        stepOne.alpha = 1.0
        ff.alpha = 1.0
        rewd.alpha = 1.0
        markPlayButton.alpha = 1.0
        isPlaying = false
    }
    
    // MARK: - Slider Change
    
   
    @IBAction func sliderChanged(sender: UISlider) {
        
        if(hasURL!){
        let progress = Float64(sender.value)
        let durationSeconds = CMTimeGetSeconds(self.playerItem.duration)
        let result = durationSeconds * progress
        let seekTime = CMTimeMakeWithSeconds(result, self.playerItem.currentTime().timescale)
        self.player.seekToTime(seekTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        } else {
            videoSlider.enabled = false
        }
        
    }
    
    
    /*These actions play the video in Slow-Motion forward one frame*/
    // MARK: - Actions
    
    
    @IBAction func stepOneInside(sender: AnyObject) {
        
        timer.invalidate()
    }
    
    
    @IBAction func stepOneDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("slowForward"), userInfo: nil, repeats: true)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        
    }
    
    
    @IBAction func stepOneOutside(sender: AnyObject) {
        
        timer.invalidate()
        
    }
    
    /*-----------------------------------------------------------------*/
    
    
    /*These actions play the video in Slow-Motion backward one frame*/
    
    
    @IBAction func stepBackInside(sender: AnyObject) {
        
        timer.invalidate()
    }
    
    
    @IBAction func stepBackDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("slowBack"), userInfo: nil, repeats: true)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func stepBackOutside(sender: AnyObject) {
        
        timer.invalidate()
        
    }
    
    /*-----------------------------------------------------------------*/
    
    
    
    /*These actions rewinds the video 10 frames*/
    
    
    @IBAction func rewindInside(sender: AnyObject) {
        
        timer.invalidate()
    }
    
    
    @IBAction func rewindDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("rewind"), userInfo: nil, repeats: true)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func rewindOutside(sender: AnyObject) {
        
        timer.invalidate()
        
    }
    
    
    /*-----------------------------------------------------------------*/
    
    
    /*These actions fast forwards the video 10 frames*/
    
    
    @IBAction func fastForwardInside(sender: AnyObject) {
        
        timer.invalidate()
    }
    

    @IBAction func fastForwardDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("fastForward"), userInfo: nil, repeats: true)
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func fastForwardOutside(sender: AnyObject) {
        
        timer.invalidate()
        
    }
    
    /*-----------------------------------------------------------------*/
    
    
    /*These functions perform the StepOne,StepBack,FastForward,Rewind actions*/

    
    func slowForward() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(1)
        })
    }
    
    func slowBack() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(-1)
        })
    }
    
    func rewind() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(-10)
        })
    }
    
    func fastForward() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(10)
        })
    }
    
    func clipRewind() {
        
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(-2)
        })

    }
    
    func clipFastForward() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(2)
        })
    }
    
    func clipRewindx2() {
        
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
        self.playerItem.stepByCount(-10)
        })
    }
    
    func clipFastForwardx2() {
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.playerItem.stepByCount(10)
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "mark"){
            print("Mark View")
            let secondScene = segue.destinationViewController as! MarkViewController
            
            if let name = gameName.text {
                
                secondScene.gameName = name
            }
        }
        
        if (segue.identifier == "stats"){
            print("Stats")
           
        }
        
        if (segue.identifier == "download"){
            print("Download")
        }
    
    
    
    
}
    
    
    
    
    

}
