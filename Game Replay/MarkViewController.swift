//
//  MarkViewController.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/3/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class MarkViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var playPicker: UIPickerView!
    
    var hasClicked = false
    var playType = ""
    var wasItCorrect = ""
    var thPosition = ""
    var gameName = ""

    
    
    let pickerData = ["-----------------------", "Ballhandler/Dribbler", "Post Play", "Rebounding", "Transition", "Block/Charge", "Screen", "Travel", "Back Court", "Transition", "Free Throw", "Block/Charge"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        scrollView.contentSize = CGSizeMake(2076, 600)
        
        scrollView.delegate = self
        let pageControl = UIPageControl(frame:CGRectMake(0, 90, scrollView.frame.size.width, 20))
        pageControl.numberOfPages = Int(scrollView.contentSize.width / scrollView.frame.size.width)
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
    
        
        playPicker.dataSource = self
        playPicker.delegate = self
        
        hasClicked = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back(sender: AnyObject) {
        
        scrollView.userInteractionEnabled = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) -> () {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 30.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        let myTitle2 = NSAttributedString(string:  pickerData[0], attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 35.0)!,NSForegroundColorAttributeName:UIColor.grayColor()])
        if (titleData == "-----------------------"){
        pickerLabel.attributedText = myTitle2
        }else {
            pickerLabel.attributedText = myTitle
        }
        pickerLabel.textAlignment = .Center
        return pickerLabel
    }

    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 400
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value = pickerData[row]
        playType = value
        
    }
    
    
    
    @IBAction func markPosition(sender: UIButton) {
        
        if (!hasClicked) {
        let position = sender.titleLabel?.text
        thPosition = position!
        hasClicked = true
        } else {
            print("You have already clicked")
        }
    }
    

    @IBAction func markIsCallCorrect(sender: UIButton) {
        
        wasItCorrect = (sender.titleLabel?.text)!
        
        addData()
        
    }
    
    
    func addData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let en = NSEntityDescription.entityForName("PlayInfo", inManagedObjectContext: context)
    
        let play = PlayData(entity: en!, insertIntoManagedObjectContext: context)
        
        play.position = thPosition
        play.playType = playType
        play.wasItCorrect = wasItCorrect
        play.gameName = gameName
        do{
            try context.save()
        }
        catch{
            print("Could not save info to the database!")
        }
        
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
