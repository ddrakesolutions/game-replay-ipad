//
//  TendancyView.swift
//  Game Replay
//
//  Created by Daniel Drake on 9/17/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit
import CoreData

class TendancyView: UIView, UITextFieldDelegate {

    @IBOutlet weak var tendancyTextField: UITextField!
    @IBOutlet weak var positionSegment: UISegmentedControl!
    
    
    var view: UIView!
    var tendancyData = ""
    var position = "0"
    
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
        positionSegment.selectedSegmentIndex = -1
        tendancyTextField.delegate = self
        tendancyTextField.keyboardType = UIKeyboardType.ASCIICapable
        tendancyTextField.returnKeyType = .Done
        tendancyTextField.autocapitalizationType = .Sentences
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "TendancyView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    @IBAction func dismissView(sender: UIButton) {

        tendancyTextField.resignFirstResponder()
        tendancyTextField.text = ""
        positionSegment.selectedSegmentIndex = -1
        position = "0"
        
        UIView.animateWithDuration(0.2,
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

    }

    @IBAction func markTendancy(sender: UIButton) {
      
        if (position == "0"){
            positionSegment.tintColor = UIColor ( red: 0.9801, green: 0.0, blue: 0.2995, alpha: 1.0 )
            return
        }
        
        if(tendancyTextField.text! == ""){
            
            UIView.animateWithDuration(0.3,
                delay: 0,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.tendancyTextField.transform = CGAffineTransformMakeScale(1.3, 1.3)
                }, completion: nil)
            UIView.animateWithDuration(0.4,
                delay: 0.1,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.5,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.tendancyTextField.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
          
        
        }else{
    
        tendancyData = tendancyTextField.text!

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let en = NSEntityDescription.entityForName("PlayInfo", inManagedObjectContext: context)
        let play = PlayData(entity: en!, insertIntoManagedObjectContext: context)
        
        let randomID = randomStringWithLength(8)
        
        play.play = position + "+" + tendancyData + "+" + gameFile + "+" + "\(currentTimeForData.seconds)" + "+" + "T" + "+" + "\(0)" + "+" + "\(0)" + "+" +  "\(0)" + "+" + (randomID as String)
        
        do{
            try context.save()
        }
        catch{
            print("Could not save info to the database!")
        }
            
            tendancyTextField.resignFirstResponder()
            tendancyTextField.text = ""
            positionSegment.selectedSegmentIndex = -1
            position = "0"
            
        UIView.animateWithDuration(0.2,
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
        
        
        }
        
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    @IBAction func pickPosition(sender: UISegmentedControl) {
        
        positionSegment.tintColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        
        switch sender.selectedSegmentIndex{
            
        case 0:
            position = "TRAIL"
            
        case 1:
            position = "CENTER"
            
        case 2:
            position = "LEAD"
            
        default:
            break
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
