//
//  MarkView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/19/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class MarkView: UIView, UITextFieldDelegate {
    
    @IBOutlet weak var commentsTextField: UITextField!
    @IBOutlet weak var textFieldBGBlur: UIVisualEffectView!
    @IBOutlet weak var playTypeSegment1: UISegmentedControl!
    @IBOutlet weak var playTypeSegment2: UISegmentedControl!
    @IBOutlet weak var playTypeSegment3: UISegmentedControl!
    @IBOutlet weak var positionSegment: UISegmentedControl!
    @IBOutlet weak var playOccurrenceSegment: UISegmentedControl!
    @IBOutlet weak var callTypeSegment: UISegmentedControl!
    @IBOutlet weak var wasItCorrectSegment: UISegmentedControl!
    
    var view: UIView!
    
    var position = "0"
    var playType = "0"
    var callType = "0"
    var playOccurrence = "0"
    var wasItCorrect = "0"
    var comments = "0"
    var gameName = "0"
    var mainView = MainViewController()
    
    let playData = ["BALLHANDLER/DRIBBLER", "POST PLAY", "OUT OF BOUNDS", "REBOUNDING", "TRANSITION", "BLOCK/CHARGE", "SCREEN", "TRAVEL", "BACK COURT", "FREE THROW"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        view.backgroundColor = UIColor.clearColor()
        commentsTextField.delegate = self
        commentsTextField.keyboardType = UIKeyboardType.ASCIICapable
        commentsTextField.returnKeyType = .Done
        textFieldBGBlur.hidden = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MarkView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
}
    

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 5.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.commentsTextField.frame.origin.y -= 400
                self.textFieldBGBlur.hidden = false
            }, completion: nil)

        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        comments = commentsTextField.text!
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 5.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.commentsTextField.frame.origin.y += 400
                self.textFieldBGBlur.hidden = true
            }, completion: nil)
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func playTypeSelect(sender: UISegmentedControl) {
    
        switch sender.tag{
        
        case 1:
          position = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
          positionSegment.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            
        case 2:
            playOccurrence = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            playOccurrenceSegment.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            
        case 3:
            callType = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            callTypeSegment.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        
        case 4:
            playTypeSegment1.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment2.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment3.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playType = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            playTypeSegment2.selectedSegmentIndex = -1
            playTypeSegment3.selectedSegmentIndex = -1
            
        case 5:
            playTypeSegment1.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment2.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment3.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playType = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            playTypeSegment1.selectedSegmentIndex = -1
            playTypeSegment3.selectedSegmentIndex = -1
            
        case 6:
            playTypeSegment1.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment2.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playTypeSegment3.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            playType = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            playTypeSegment1.selectedSegmentIndex = -1
            playTypeSegment2.selectedSegmentIndex = -1
            
        case 7:
            wasItCorrectSegment.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            wasItCorrect = "\(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)"
            
        default:
        break
        }
        
    }
    
    @IBAction func dismissView(sender: UIButton) {
        
        UIView.animateWithDuration(0.3,
            delay: 0,
            usingSpringWithDamping: 5.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.transform = CGAffineTransformMakeScale(0.001,0.001)
            }, completion: {
                [unowned self] finished in
                self.hidden = true
                })
        
        resetMarkView()
        mainView.awakeFromNib()
    }
    
    
    
   @IBAction func saveData() {
        
    if (position == "0"){
        positionSegment.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
    }
    
    if (playOccurrence == "0"){
        playOccurrenceSegment.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
    }
    
    if (callType == "0"){
        callTypeSegment.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
    }
    
    if (playType == "0"){
        playTypeSegment1.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
        playTypeSegment2.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
        playTypeSegment3.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
    }
    
    if (wasItCorrect == "0"){
        wasItCorrectSegment.tintColor = UIColor ( red: 0.9854, green: 0.0, blue: 0.0862, alpha: 1.0 )
    }
    
    if (position == "0" || playOccurrence == "0" || callType == "0" || playType == "0" || wasItCorrect == "0"){
        return
    }
    
    
    
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let en = NSEntityDescription.entityForName("PlayInfo", inManagedObjectContext: context)
        let play = PlayData(entity: en!, insertIntoManagedObjectContext: context)
         print(gameFile)
        play.play = "\(position)" + "+" + "\(playOccurrence)" + "+" + "\(callType)" + "+" + "\(playType)" + "+" + "\(wasItCorrect)" + "+" + "\(comments)" + "+" + "\(gameFile)" + "+" + "\(currentTimeForData.seconds)"
    
        do{
            try context.save()
        }
        catch{
            print("Could not save info to the database!")
        }
    
    UIView.animateWithDuration(0.3,
        delay: 0,
        usingSpringWithDamping: 5.7,
        initialSpringVelocity: 0.5,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { [unowned self] in
            self.transform = CGAffineTransformMakeScale(0.001,0.001)
        }, completion: {
            [unowned self] finished in
            self.hidden = true
        })
    
        resetMarkView()
    
    
    }
  
 
    
    
    func resetMarkView() {
        
        gameName = "0"
        position = "0"
        playType = "0"
        callType = "0"
        playOccurrence = "0"
        wasItCorrect = "0"
        comments = "0"
        playTypeSegment1.selectedSegmentIndex = -1
        playTypeSegment2.selectedSegmentIndex = -1
        playTypeSegment3.selectedSegmentIndex = -1
        positionSegment.selectedSegmentIndex = -1
        playOccurrenceSegment.selectedSegmentIndex = -1
        callTypeSegment.selectedSegmentIndex = -1
        wasItCorrectSegment.selectedSegmentIndex = -1
        commentsTextField.text = ""
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    
    

}