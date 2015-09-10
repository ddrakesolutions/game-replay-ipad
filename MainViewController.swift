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

var gameNameForData = "0"
var gameFile = "0"
var gameForInsert = ""
var currentTimeForData: Float64 = 0.0

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var viewContainerScrollView: UIScrollView!
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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var importButton: UIButton!
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
    @IBOutlet weak var markView: MarkView!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var noVideoImage: UIImageView!
    @IBOutlet weak var noVideoMessage: UILabel!
    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var drawView: UIView!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var clockView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var clockButton: UIButton!
    @IBOutlet weak var clockHeader: UILabel!
    @IBOutlet weak var doubleTapReset: UILabel!
    @IBOutlet weak var clockMessage: UILabel!
    @IBOutlet weak var startMarked: UIView!
    @IBOutlet weak var clipButton: UIButton!
    @IBOutlet weak var clipTableView: UITableView!
    @IBOutlet weak var clipView: UIView!
    
    
    
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
    var resetClock = UITapGestureRecognizer()
    let checkTime : CMTime = CMTime()
    var isPlaying = false
    let prefs = NSUserDefaults.standardUserDefaults()
    let titlePrefs = NSUserDefaults.standardUserDefaults()
    let timeResume = NSUserDefaults.standardUserDefaults()
    var originNum : CGFloat = 0
    var views = [UIView]()
    var numOfViews : CGFloat = 1
    var games = [String]()
    var bgImages = [UIImage]()
    var gameTitles = [String]()
    var tempTitle = ""
    var tempFile = ""
    var timeForResume : Float64 = 0.0
    var tag = 0
    var timerForClock = NSTimer()
    var timeForShotclock = 30
    var timeForThrowIn = 5
    var timeForBackCourt = 10
    var changeClockRight = UIPanGestureRecognizer()
    var changeClockLeft = UIPanGestureRecognizer()
    var clockType = [String]()
    var timeForClock = 30
    var nextClockType = 0
    var data = [Float64]()
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markView.layer.cornerRadius = 10
        markView.backgroundColor = UIColor.clearColor()
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
        videoSlider.setThumbImage(UIImage(named: "scrubber-normal.png"), forState: .Normal)
        videoSlider.setThumbImage(UIImage(named: "scrubber-highlight.png"), forState: .Highlighted)
        videoSlider.setMaximumTrackImage(UIImage(named: "bar-front.png"), forState: .Normal)
        videoSlider.setMinimumTrackImage(UIImage(named: "bar-back.png"), forState: .Normal)
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
        resetClock = UITapGestureRecognizer(target: self, action: Selector("resetForClock"))
        resetClock.numberOfTapsRequired = 2
        changeClockRight = UIPanGestureRecognizer(target: self, action: Selector("changeClock:"))
        changeClockLeft = UIPanGestureRecognizer(target: self, action: Selector("changeClock:"))
        changeClockRight.minimumNumberOfTouches = 1
        changeClockLeft.minimumNumberOfTouches = 1
        visualForEdit.hidden = true
        startOver.hidden = true
        emailClip.hidden = true
        saveClip.hidden = true
        saveAndEmail.hidden = true
        bottomView.layer.masksToBounds = true
        actionView.hidden = true
        actionView.layer.masksToBounds = true
        actionView.layer.cornerRadius = 10.0
        gameScrollView.delegate = self
        gameScrollView.scrollEnabled = true
        gameScrollView.hidden = true
        markView.transform = CGAffineTransformMakeScale(0.0,0.0)
        markView.hidden = true
        importButton.enabled = false
        drawView.hidden = true
        timeLabel.text = "\(timeForClock)"
        clockView.hidden = true
        clockView.addGestureRecognizer(resetClock)
        clockView.addGestureRecognizer(changeClockLeft)
        clockView.addGestureRecognizer(changeClockRight)
        clockType = ["Shot Clock", "Throw In", "Back Court"]
        clockHeader.text = "Shot Clock"
        doubleTapReset.hidden = true
        clockView.layer.masksToBounds = true
        clockView.layer.cornerRadius = 5
        clockMessage.hidden = true
        startMarked.hidden = true
        clipTableView.delegate = self
        clipTableView.backgroundView = UIImageView(image: UIImage(named: "basketball-bg.jpg"))
        
        
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
                let gameTitle = UITextField()
                let dimView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
                
                games.append(gameName)
                
                importButton.backgroundColor = UIColor.clearColor();
                importButton.tag = Int(numOfViews)
                importButton.addTarget(self, action: Selector("insertVideoToView:"), forControlEvents: UIControlEvents.TouchUpInside)
                importButton.setTitle("Select Video", forState: .Normal)
                importButton.layer.cornerRadius = 10
                importButton.layer.borderWidth = 1
                importButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                importButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                importButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
                importButton.backgroundColor = UIColor.clearColor()
                
                deleteButton.frame = CGRectMake(965, 90, 45, 50)
                deleteButton.backgroundColor = UIColor.clearColor()
                deleteButton.tag = Int(numOfViews)
                deleteButton.addTarget(self, action: Selector("deleteVideo:"), forControlEvents: UIControlEvents.TouchUpInside)
                deleteButton.setTitle("Delete Video", forState: .Normal)
                deleteButton.setImage(UIImage(named: "delete.jpg"), forState: .Normal)
                
                gameTitle.frame = CGRectMake(0, 0, 1024, 80)
                gameTitle.backgroundColor = UIColor.clearColor();
                gameTitle.tag = Int(numOfViews)
                gameTitle.textAlignment = .Center
                gameTitle.placeholder = "Enter Game Title. - Example: Florida vs Tennessee"
                gameTitle.delegate = self
                gameTitle.returnKeyType = .Done
                gameTitle.font = UIFont(name: "HelveticaNeue-Light", size: 35)
                gameTitle.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
                gameTitle.setValue(UIColor.blackColor().colorWithAlphaComponent(0.52), forKeyPath: "_placeholderLabel.textColor")
                
                
                imageView.frame = CGRectMake(0, 75, 1024, 562)
                v.frame = CGRectMake(originNum, -75, 1024, 700)
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir = dirPaths[0] as String
                
                url = NSURL(fileURLWithPath: "\(docsDir)/\(file)")
                let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
                asset = AVURLAsset(URL: url, options: options)
                do{
                    let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    let time: CMTime = CMTimeMakeWithSeconds(0, asset.duration.timescale)
                    let img : CGImageRef = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
                    
                    let frameImg : UIImage = UIImage(CGImage: img)
                    
                    imageView.image = frameImg
                    
                    bgImages.append(frameImg)
                    
                } catch{}
                
                let imgBg = imageView
                
                imgBg.layer.masksToBounds = true
                imgBg.layer.cornerRadius = 10
                imageView.layer.masksToBounds = true
                imageView.layer.cornerRadius = 10
                dimView.layer.masksToBounds = true
                dimView.layer.cornerRadius = 10
            
                importButton.frame = imgBg.frame
                
                dimView.frame = imgBg.frame
                dimView.backgroundColor = UIColor.whiteColor();
                dimView.alpha = 0.90
                

                if(timeResume.objectForKey("\(gameName)time") == nil) {
                    timeResume.setValue(0, forKey: "\(gameName)time")
                }
                
                timeResume.setValue(timeResume.objectForKey("\(gameName)time"), forKey: "\(gameName)time")
                
                if let time = timeResume.objectForKey("\(gameName)time") {
                    if(time as! Float == 0){
                        importButton.setTitle("Select Video", forState: .Normal)
                    }else
                    {
                        importButton.setTitle("Resume Video", forState: .Normal)
                    }
                }
                
                v.tag = Int(numOfViews)
                numOfViews++
                views.append(v)
                playerScrollViewVisualEffectContainer.addSubview(imageView)
                playerScrollViewVisualEffectContainer.addSubview(v)
                v.addSubview(imageView)
                v.addSubview(dimView)
                v.addSubview(importButton)
                v.addSubview(deleteButton)
                v.addSubview(gameTitle)
                self.originNum += 1024
                
                gameTitle.text = titlePrefs.objectForKey("\(gameName)") as? String
                if(gameTitle.text == ""){
                    gameTitles.append(gameTitle.placeholder!)
                }else{
                    gameTitles.append(gameTitle.text!)
                }
                
                
                
            }
        }
        
        selectVideo()
        downLoadButton.enabled = true
        
        if(games.isEmpty){
            print("NO MORE VIDEOS")
            importButton.enabled = false
            noVideoImage.hidden = false
            noVideoMessage.hidden = false
        }else
        {
            noVideoImage.hidden = true
            noVideoMessage.hidden = true
        }
        
        
    }
    
    
    
    @IBAction func showStatView(sender: AnyObject) {
        
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                
                self.statView.frame.origin.y = 0
                self.statView.awakeFromNib()
                
            }, completion: nil)
        
    }
    
    
    
    @IBAction func showMarkView(sender: AnyObject) {
        
        markView.awakeFromNib()
        markView.hidden = false
        
        currentTimeForData = currentTime
        print(currentTimeForData)
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                
            self.markView.transform = CGAffineTransformMakeScale(1.0,1.0)
                
            }, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func selectVideo() {
    
        timeResume.setValue(timeForResume, forKey: "\(tempFile)time")
        
        for view in self.playerScrollViewVisualEffectContainer.subviews {
            
            for field in view.subviews {
                if let button = field.viewWithTag(Int(tag)) as? UIButton {
                    print(button)
                    if(button.titleLabel?.text == "Select Video" || button.titleLabel?.text == "Resume Video"){
                        print("Select video found")
                        if let time = timeResume.objectForKey("\(tempFile)time") {
                            if(time as! Float == 0){
                                button.setTitle("Select Video", forState: .Normal)
                            }else
                            {
                                button.setTitle("Resume Video", forState: .Normal)
                            }
                        }
                    }
                    
                }
            }
        }
        clockView.hidden = true
        drawButton.enabled = false
        clockMessage.hidden = true
        clockButton.enabled = false
        downLoadButton.enabled = false
        importButton.enabled = false
        statsButton.enabled = false
        editButton.enabled = false
        videoSlider.enabled = false
        currentTimeLabel.enabled = false
        totalTimeLabel.enabled = false
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
                    view.transform = CGAffineTransformMakeScale(0.7, 0.7)
                }
                self.viewContainerScrollView.contentSize = CGSizeMake(1024 * (self.numOfViews-1), 562)
                if(self.numOfViews == 1){
                    print("NO MORE VIDEOS")
                    self.backVisualEffect.frame.size = CGSizeMake(1024, 562)
                }else
                {
                    self.backVisualEffect.frame.size = CGSizeMake(1024 * (self.numOfViews-1), 562)
                    self.viewContainerScrollView.scrollEnabled = true
                }
                
            }, completion: nil)
       
    }
    
    
    func insertVideoToView(sender: UIButton) {
        
        
        let gameTag = sender.tag
        
        tag = sender.tag
        
        tempTitle = gameTitles[gameTag-1]
        tempFile = games[gameTag-1]
        
        if let time = timeResume.objectForKey("\(tempFile)time") {
            timeForResume = time as! Float64
        }
        
        if(tempTitle == "Enter Game Title. - Example: Florida vs Tennessee"){
            
            for view in self.playerScrollViewVisualEffectContainer.subviews {
                
                for field in view.subviews {
                    
                    if let tField = field.viewWithTag(sender.tag) as? UITextField {
                        UIView.animateWithDuration(0.3,
                            delay: 0,
                            usingSpringWithDamping: 0.3,
                            initialSpringVelocity: 0.5,
                            options: UIViewAnimationOptions.CurveEaseInOut,
                            animations: {
                                tField.transform = CGAffineTransformMakeScale(1.2, 1.2)
                            }, completion: nil)
                        UIView.animateWithDuration(0.4,
                            delay: 0.1,
                            usingSpringWithDamping: 0.3,
                            initialSpringVelocity: 0.5,
                            options: UIViewAnimationOptions.CurveEaseInOut,
                            animations: {
                                tField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            }, completion: nil)
                        
                    }
                }
            }
            
            return
        }
        
        
        UIView.animateWithDuration(0.1,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                for view in self.views {
                    
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                }
            }, completion: nil)
    
        gameScrollView.alpha = 0.0
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                
                self.gameScrollView.hidden = false
                self.gameScrollView.alpha = 1.0
                
            }, completion: nil)
        
        clockButton.enabled = true
        drawButton.enabled = true
        downLoadButton.enabled = true
        importButton.enabled = true
        editButton.enabled = true
        statsButton.enabled = true
        currentTimeLabel.enabled = true
        totalTimeLabel.enabled = true
        stepBack.hidden = false
        stepOne.hidden = false
        ff.hidden = false
        rewd.hidden = false
        markPlayButton.hidden = false
        playButton.hidden = false
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
        videoSlider.enabled = true
        viewContainerScrollView.scrollEnabled = false
        gameNameForData = tempTitle
        statView.awakeFromNib()
        durationTime = CMTimeGetSeconds(asset.duration) / 60
        let duration = NSString(format: "%.2f", durationTime)
        totalTimeLabel.text = duration as String
        gameFile = "\(games[gameTag-1])"
        let progress = Float64(timeForResume)
        let durationSeconds = CMTimeGetSeconds(self.asset.duration)
        let result = durationSeconds * progress
        let seekTime = CMTimeMakeWithSeconds(result, asset.duration.timescale)
        player.seekToTime(seekTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
        let currentMinString = NSString(format: "%.2f", self.currentTime)
        currentTimeLabel.text = currentMinString as String
        let time = Float(CMTimeGetSeconds(self.playerItem.currentTime())/CMTimeGetSeconds(self.asset.duration))
        videoSlider.value = time
        timeResume.setValue(Float(timeForResume), forKey: "\(tempFile)time")
    }
    
    func deleteVideo(sender: UIButton) {
        
        let alertView = UIAlertController(title: "Game Replay", message: "Are you sure you want to delete game? Game data will not be delete.", preferredStyle: .Alert)
        
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {[unowned self] handler in
            
            self.currentTimeLabel.text = "0.00"
            self.totalTimeLabel.text = "0.00"
            self.videoSlider.value = 0
            
            UIView.animateWithDuration(0.15,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { [unowned self] in
                    
                    self.playerScrollViewVisualEffectContainer.viewWithTag(sender.tag)?.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
                    
                }, completion: { [unowned self] finished in
                    
                    
                    var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let documentsDirectory = paths[0] as String
                    let filemanager:NSFileManager = NSFileManager()
                    let files = filemanager.enumeratorAtPath(documentsDirectory)
                    
                    print("\(documentsDirectory)/\(self.games[sender.tag-1])")
                    self.originNum = 0
                    self.numOfViews = 1
                    
                    
                    do{
                        try filemanager.removeItemAtPath("\(documentsDirectory)/\(self.games[sender.tag-1])")
                        print("Remove successful")
                    }
                    catch{print("Remove failed.")}
                    
                    self.titlePrefs.setValue(nil, forKey: "\(self.games[sender.tag-1])")
                    self.timeResume.setValue(nil, forKey: "\(self.games[sender.tag-1])time")
                    
                    for view in self.playerScrollViewVisualEffectContainer.subviews {
                        
                        
                        view.removeFromSuperview()
                        self.views.removeAll()
                        self.games.removeAll()
                        self.bgImages.removeAll()
                        self.gameTitles.removeAll()
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
                            let gameTitle = UITextField()
                            let dimView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light)) as UIVisualEffectView
                            
                            self.games.append(gameName)
                            
                            importButton.backgroundColor = UIColor.clearColor();
                            importButton.tag = Int(self.numOfViews)
                            importButton.addTarget(self, action: Selector("insertVideoToView:"), forControlEvents: UIControlEvents.TouchUpInside)
                            importButton.setTitle("Select Video", forState: .Normal)
                            importButton.layer.cornerRadius = 10
                            importButton.layer.borderWidth = 1
                            importButton.layer.borderColor = UIColor.lightGrayColor().CGColor
                            importButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                            importButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 60)
                            importButton.backgroundColor = UIColor.clearColor()
                            
                            deleteButton.frame = CGRectMake(965, 90, 45, 50)
                            deleteButton.backgroundColor = UIColor.clearColor()
                            deleteButton.tag = Int(self.numOfViews)
                            deleteButton.addTarget(self, action: Selector("deleteVideo:"), forControlEvents: UIControlEvents.TouchUpInside)
                            deleteButton.setTitle("Delete Video", forState: .Normal)
                            deleteButton.setImage(UIImage(named: "delete.jpg"), forState: .Normal)
                            
                            gameTitle.frame = CGRectMake(0, 0, 1024, 80)
                            gameTitle.backgroundColor = UIColor.clearColor();
                            gameTitle.tag = Int(self.numOfViews)
                            gameTitle.textAlignment = .Center
                            gameTitle.placeholder = "Enter Game Title. - Example: Florida vs Tennessee"
                            gameTitle.delegate = self
                            gameTitle.returnKeyType = .Done
                            gameTitle.font = UIFont(name: "HelveticaNeue-Light", size: 35)
                            gameTitle.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
                            gameTitle.setValue(UIColor.blackColor().colorWithAlphaComponent(0.52), forKeyPath: "_placeholderLabel.textColor")
                            
                            
                            imageView.frame = CGRectMake(0, 75, 1024, 562)
                            v.frame = CGRectMake(self.originNum, -75, 1024, 700)
                            
                            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                            let docsDir = dirPaths[0] as String
                            
                            url = NSURL(fileURLWithPath: "\(docsDir)/\(file)")
                            let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
                            asset = AVURLAsset(URL: url, options: options)
                            do{
                                let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                                assetImgGenerate.appliesPreferredTrackTransform = true
                                let time: CMTime = CMTimeMakeWithSeconds(0, 1)
                                let img : CGImageRef = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
                                
                                let frameImg : UIImage = UIImage(CGImage: img)
                                
                                imageView.image = frameImg
                                
                                self.bgImages.append(frameImg)
                                
                            } catch{}
                            
                            let imgBg = imageView
                            
                            imgBg.layer.masksToBounds = true
                            imgBg.layer.cornerRadius = 10
                            imageView.layer.masksToBounds = true
                            imageView.layer.cornerRadius = 10
                            dimView.layer.masksToBounds = true
                            dimView.layer.cornerRadius = 10
                            
                            importButton.frame = imgBg.frame
                            
                            dimView.frame = imgBg.frame
                            dimView.backgroundColor = UIColor.whiteColor();
                            dimView.alpha = 0.90
                            
                            print(self.timeResume.objectForKey("\(gameName)time"))
                            if(self.timeResume.objectForKey("\(gameName)time") == nil) {
                                self.timeResume.setValue(0, forKey: "\(gameName)time")
                            }
                            
                            self.timeResume.setValue(self.timeResume.objectForKey("\(gameName)time"), forKey: "\(gameName)time")
                            
                            if let time = self.timeResume.objectForKey("\(gameName)time") {
                                if(time as! Float == 0){
                                    importButton.setTitle("Select Video", forState: .Normal)
                                }else
                                {
                                    importButton.setTitle("Resume Video", forState: .Normal)
                                }
                            }
                            
                            v.tag = Int(self.numOfViews)
                            self.numOfViews++
                            self.views.append(v)
                            self.playerScrollViewVisualEffectContainer.addSubview(imageView)
                            self.playerScrollViewVisualEffectContainer.addSubview(v)
                            v.addSubview(imageView)
                            v.addSubview(dimView)
                            v.addSubview(importButton)
                            v.addSubview(deleteButton)
                            v.addSubview(gameTitle)
                            self.originNum += 1024
                            
                            gameTitle.text = self.titlePrefs.objectForKey("\(gameName)") as? String
                            if(gameTitle.text == ""){
                                self.gameTitles.append(gameTitle.placeholder!)
                            }else{
                                self.gameTitles.append(gameTitle.text!)
                            }
                            
                            
                            
                        }
                    }
                    
                    for view in self.views {
                        view.transform = CGAffineTransformMakeScale(0.0, 0.0)
                    }
                    
                    self.viewContainerScrollView.contentSize = CGSizeMake(1024 * (self.numOfViews-1), 562)
                    
                    UIView.animateWithDuration(0.3,
                        delay: 0,
                        usingSpringWithDamping: 1.3,
                        initialSpringVelocity: 0.7,
                        options: UIViewAnimationOptions.CurveEaseInOut,
                        animations: {
                            for view in self.views {
                                view.transform = CGAffineTransformMakeScale(0.7, 0.7)
                            }
                        
                            
                            if(self.numOfViews == 1){
                                print("NO MORE VIDEOS")
                                self.backVisualEffect.frame.size = CGSizeMake(1024, 562)
                            }else
                            {
                                self.backVisualEffect.frame.size = CGSizeMake(1024 * (self.numOfViews-1), 562)
                                self.viewContainerScrollView.scrollEnabled = true
                            }
                            
                        }, completion: nil)
                    
                    self.downLoadButton.enabled = true
                    
                    if(self.games.isEmpty){
                        print("NO MORE VIDEOS")
                        self.importButton.enabled = false
                        self.noVideoImage.hidden = false
                        self.noVideoMessage.hidden = false
                    }else
                    {
                        self.noVideoImage.hidden = true
                        self.noVideoMessage.hidden = true
                    }
                    
            })
            
            
            
            
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { handler in
            return
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
    /*-----------------------------------------------------------------*/
    
    // MARK: - Update Timer
    
    func updateTime(){
        
        currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
        let currentMinString = NSString(format: "%.2f", self.currentTime)
        currentTimeLabel.text = currentMinString as String
        let time = Float(CMTimeGetSeconds(self.playerItem.currentTime())/CMTimeGetSeconds(self.asset.duration))
        videoSlider.value = time
        timeForResume = CMTimeGetSeconds(self.playerItem.currentTime())/CMTimeGetSeconds(self.asset.duration)
        timeResume.setFloat(Float(timeForResume), forKey: "\(tempFile)time")
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
        
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.actionView.frame.origin.x = -65
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.actionView.frame.origin.x = -280
            }, completion: { finished in
                self.actionView.hidden = true
                
        })
        
        
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
         
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.actionView.frame.origin.x = -65
                }, completion: nil)
            
            
            UIView.animateWithDuration(1.0,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 5.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.actionView.frame.origin.x = -280
                }, completion: { finished in
                    self.actionView.hidden = true
                    
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
            self.importButton.enabled = true
            self.statsButton.enabled = true
            self.downLoadButton.enabled = true
            
            self.actionView.hidden = true
            
            
            self.playerView.removeGestureRecognizer(self.leftSwipe)
            self.playerView.removeGestureRecognizer(self.rightSwipe)
            self.playerView.removeGestureRecognizer(self.leftSwipeFast)
            self.playerView.removeGestureRecognizer(self.rightSwipeFast)
            self.playerView.removeGestureRecognizer(self.doubleTapGesture)
            self.inEditMode = false
            self.isMarked = false
            self.visualForEdit.hidden = true
            self.gameScrollView.minimumZoomScale = 1.0
            self.gameScrollView.maximumZoomScale = 3.0
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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForward"), userInfo: nil, repeats: false)
                    })
                }
                else
                {
                    
                    let checkTime = CMTimeGetSeconds(self.playerItem.currentTime())
                    
                    if (checkTime <= markEdit){
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewind"), userInfo: nil, repeats: false)
                    })
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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForwardx2"), userInfo: nil, repeats: false)
                    })
                }
                else
                {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewindx2"), userInfo: nil, repeats: false)
                    })
                }
            }
            
            
            
        } else {
            
            if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                    
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipFastForwardx2"), userInfo: nil, repeats: false)
                    })
                }
                else
                {
                    
                    let checkTime = CMTimeGetSeconds(self.playerItem.currentTime())
                    
                    if (checkTime <= markEdit){
                        return
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.currentTime = CMTimeGetSeconds(self.playerItem.currentTime()) / 60
                        let currentMinString = NSString(format: "%.2f", self.currentTime)
                        self.currentTimeLabel.text = currentMinString as String
                        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("clipRewindx2"), userInfo: nil, repeats: false)
                    })
                }
            }
            
        }
        
        
    }
    
    
    @IBAction func editVideo(sender: UIButton) {
        
        
        if(!inEditMode){
            
            downLoadButton.enabled = false
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
                        self.importButton.enabled = false
                        self.statsButton.enabled = false
                        self.downLoadButton.enabled = false
                        }, completion:nil)
                    
                }else {UIView.animateWithDuration(0.2, animations:{
                    self.editButton.setTitleColor(UIColor(red: 158/255, green: 66/255, blue: 66/255, alpha: 1), forState: .Normal)
                    self.importButton.enabled = false
                    self.statsButton.enabled = false
                    self.downLoadButton.enabled = false
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
                    self.importButton.enabled = false
                    self.statsButton.enabled = false
                    self.downLoadButton.enabled = false
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
            gameScrollView.minimumZoomScale = 0.0
            gameScrollView.maximumZoomScale = 0.0
            
            
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
            
            self.importButton.enabled = true
            self.statsButton.enabled = true
            downLoadButton.enabled = true
            videoSlider.enabled = true
            print("turning off editing")
            self.visualForEdit.hidden = true
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
            gameScrollView.minimumZoomScale = 1.0
            gameScrollView.maximumZoomScale = 3.0
            
        }
    }
    
    func markForEdit(){
        
        if (!isMarked){
            
            markEdit = CMTimeGetSeconds(self.playerItem.currentTime())
            isMarked = true
            
            self.startMarked.transform = CGAffineTransformMakeScale(0.0, 0.0)
            self.startMarked.hidden = false
            
            UIView.animateWithDuration(0.2,
                delay: 0,
                usingSpringWithDamping: 3.3,
                initialSpringVelocity: 3.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { [unowned self] in
                    self.startMarked.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
            
            UIView.animateWithDuration(0.3,
                delay: 1.0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.startMarked.transform = CGAffineTransformMakeScale(0.001, 0.001)
                }, completion: {finished in
                    self.startMarked.hidden = true
            
            })
            
            
            
            
        }else {
            
            endEdit = CMTimeGetSeconds(self.playerItem.currentTime())
            
            self.actionView.frame.origin.x = -280
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

                
                }, completion:nil)
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: { [unowned self] in
                    self.actionView.frame.origin.x = -80
                }, completion: nil)
            
        }
        
        
    }
    
    
    // MARK: - Zoom View
    
    func viewForZoomingInScrollView(scrollView : UIScrollView) -> UIView? {
        return playerView
    }
    
    
    // MARK: - Play/Pause
    
    @IBAction func playVideo() {
        
        if(hasURL!){
            
            if(!clockView.hidden){
                
            startTimeCountdown()
                
            }
            
            
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
        
        if(!clockView.hidden){
            
            stopTimeCountdown()
            
        }
        
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
            let seekTime = CMTimeMakeWithSeconds(result, asset.duration.timescale)
            player.seekToTime(seekTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
            
        } else {
            videoSlider.enabled = false
        }
        
    }
    
    
    /*These actions play the video in Slow-Motion forward one frame*/
    // MARK: - Actions
    
    
    @IBAction func stepOneInside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        
    }
    
    
    @IBAction func stepOneDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("slowForward"), userInfo: nil, repeats: true)
        
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        })
    }
    
    
    @IBAction func stepOneOutside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    /*-----------------------------------------------------------------*/
    
    
    /*These actions play the video in Slow-Motion backward one frame*/
    
    
    @IBAction func stepBackInside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func stepBackDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("slowBack"), userInfo: nil, repeats: true)
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        })
    }
    
    
    @IBAction func stepBackOutside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    /*-----------------------------------------------------------------*/
    
    
    
    /*These actions rewinds the video 10 frames*/
    
    
    @IBAction func rewindInside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func rewindDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("rewind"), userInfo: nil, repeats: true)
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        })
    }
    
    
    @IBAction func rewindOutside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        
    }
    
    
    /*-----------------------------------------------------------------*/
    
    
    /*These actions fast forwards the video 10 frames*/
    
    
    @IBAction func fastForwardInside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func fastForwardDown(sender: AnyObject) {
        
        pauseVideo()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("fastForward"), userInfo: nil, repeats: true)
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        })
    }
    
    
    @IBAction func fastForwardOutside(sender: AnyObject) {
        
        timer.invalidate()
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(1/10000000000, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: false)
        
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
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if(textField.text! == ""){
            gameTitles[textField.tag-1] = "Enter Game Title. - Example: Florida vs Tennessee"
            titlePrefs.setValue(textField.text!, forKey: "\(games[textField.tag-1])")
        }else {
            gameTitles[textField.tag-1] = textField.text!
            titlePrefs.setValue(textField.text!, forKey: "\(games[textField.tag-1])")
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField.text! == ""){
            gameTitles[textField.tag-1] = "Enter Game Title. - Example: Florida vs Tennessee"
            titlePrefs.setValue(textField.text!, forKey: "\(games[textField.tag-1])")
            textField.text! == ""
            
        }else {
            
            gameTitles[textField.tag-1] = textField.text!
            print(games[textField.tag-1])
            titlePrefs.setValue(textField.text!, forKey: "\(games[textField.tag-1])")
        }
        textField.resignFirstResponder()
        return true
    }
    
  
    @IBAction func showHideDrawView(sender: UIButton) {
        
        if(drawView.hidden){
            
            drawView.awakeFromNib()
            drawView.hidden = false
            importButton.enabled = false
            editButton.enabled = false
            statsButton.enabled = false
            clockButton.enabled = false
            downLoadButton.enabled = false
            
        }else
        {
            importButton.enabled = true
            editButton.enabled = true
            statsButton.enabled = true
            drawView.hidden = true
            clockButton.enabled = true
            downLoadButton.enabled = true
        }
        
    }
    
    @IBAction func showHideClockView(sender: UIButton) {
        
        if(clockView.hidden){
            
            clockView.hidden = false
            clockMessage.hidden = false
            
        }else
        {
            resetForClock()
            clockView.hidden = true
            doubleTapReset.hidden = true
            clockMessage.hidden = true
            
        }
        
    }
    
    
    func startTimeCountdown() {
        clockMessage.hidden = true
        timerForClock = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateClockTimer"), userInfo: nil, repeats: true)
    }
    
    func stopTimeCountdown() {
        clockMessage.hidden = false
        timerForClock.invalidate()
    }
    
    func updateClockTimer() {
        
        if(timeForClock == 1){
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.timeLabel.transform = CGAffineTransformMakeScale(1.3, 1.3)
                }, completion: nil)
            UIView.animateWithDuration(0.4,
                delay: 0.1,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
            //clockView.backgroundColor = UIColor(red: 222/255, green: 111/255, blue: 111/255, alpha: 1)
            pauseVideo()
            timerForClock.invalidate()
            doubleTapReset.hidden = false
            timeLabel.transform = CGAffineTransformMakeScale(0.7, 0.7)
            timeLabel.frame.origin.y = 30
        }
    
        if(timeForClock > 0){
            timeForClock--
            timeLabel.text = "\(timeForClock)"
        }
        
        
    }
    
    func resetForClock() {
        
        let clock = clockType[nextClockType]
        
        switch clock {
            
        case "Shot Clock":
           timeForClock = 30
        case "Throw In":
            timeForClock = 5
        case "Back Court":
            timeForClock = 10
        default:
            break
        }
        
        timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
        timeLabel.frame.origin.y = 26
        timeLabel.text = "\(timeForClock)"
        doubleTapReset.hidden = true
        clockView.backgroundColor = UIColor.clearColor()
    }
    
    func changeClock(gestureRecognizer: UIPanGestureRecognizer) {
     
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
                
                let velocity: CGPoint = gestureRecognizer.velocityInView(self.view)
                
                if(velocity.x > 0)
                {
                   let clock = clockType[nextClockType]
                    
                    switch clock {
                        
                    case "Shot Clock":
                        timeForClock = timeForThrowIn
                        clockHeader.text = "Throw In"
                        timeLabel.text = "\(timeForClock)"
                        doubleTapReset.hidden = true
                        timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        timeLabel.frame.origin.y = 26
                        nextClockType++
                        
                    case "Throw In":
                        timeForClock = timeForBackCourt
                        clockHeader.text = "Back Court"
                        timeLabel.text = "\(timeForClock)"
                        doubleTapReset.hidden = true
                        timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        timeLabel.frame.origin.y = 26
                        nextClockType++
                        
                    default:
                        break
                    }
                }
                    
                else
                {
                    let clock = clockType[nextClockType]
                    
                    switch clock {
                        
                    
                    case "Throw In":
                        timeForClock = timeForShotclock
                        clockHeader.text = "Shot Clock"
                        timeLabel.text = "\(timeForClock)"
                        doubleTapReset.hidden = true
                        timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        timeLabel.frame.origin.y = 26
                        nextClockType--
                        
                    case "Back Court":
                        timeForClock = timeForThrowIn
                        clockHeader.text = "Throw In"
                        timeLabel.text = "\(timeForClock)"
                        doubleTapReset.hidden = true
                        timeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        timeLabel.frame.origin.y = 26
                        nextClockType--
                        
                    default:
                        break
                    }
                   
                }
            
        }
    }
    
    @IBAction func insertClip(sender: UIButton) {
        
        if(clipView.frame.origin.x == -350){
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.clipView.frame.origin.x = -30
                }, completion: nil)
            
            
            UIView.animateWithDuration(1.0,
                delay: 0.1,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 5.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.clipView.frame.origin.x = -45
                }, completion:nil)
            
            var locations  = [PlayData]()
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context : NSManagedObjectContext = appDelegate.managedObjectContext
            
            let fetchRequest = NSFetchRequest(entityName: "PlayInfo")
            do{
                locations = try context.executeFetchRequest(fetchRequest) as! [PlayData]
            } catch{}
            
            for location in locations {
                
                if(location.play.componentsSeparatedByString("+")[6] == gameFile) {
                   var t = Float64(location.play.componentsSeparatedByString("+")[7])
                    data.append(t!)
                }
                clipTableView.reloadData()
            }
            
        }else{
        
            
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.clipView.frame.origin.x = -20
            }, completion: nil)
        
        
        UIView.animateWithDuration(1.0,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 5.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                self.clipView.frame.origin.x = -350
            }, completion:nil)
            data.removeAll()
            
        }
        
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
        
        cell.textLabel?.text = "\(data[indexPath.row])"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tmSc = asset.duration.timescale
        let seekTime = CMTimeMakeWithSeconds(data[indexPath.row], tmSc)
        print(seekTime)
        player.seekToTime(seekTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    

    
    
}