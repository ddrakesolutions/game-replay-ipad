//
//  MarkView.swift
//  Game Replay
//
//  Created by Daniel Drake on 8/19/15.
//  Copyright © 2015 Daniel Drake. All rights reserved.
//

import UIKit

class MarkView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playPicker: UIPickerView!
    
    var view: UIView!
    var playType = ""
    
    let pickerData = ["-----------------------", "BALLHANDLER/DRIBBLER", "POST PLAY", "REBOUNDING", "TRANSITION", "BLOCK/CHARGE", "SCREEN", "TRAVEL", "BACK COURT", "FREE THROW"]
    
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
        scrollView.contentSize = CGSize(width: 4096, height: 679)
        playPicker.dataSource = self
        playPicker.delegate = self
//        trailButton.layer.cornerRadius = 10
//        trailButton.layer.borderWidth = 1
//        trailButton.layer.borderColor = UIColor.blackColor().CGColor
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MarkView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
}
    
    @IBAction func closeMarkView(sender: AnyObject) {
        
        
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { [unowned self] in
                self.frame.origin.y = 900
            }, completion: nil)
        
    }

    @IBAction func positionClick(sender: UIButton) {
        
        var frame: CGRect = scrollView.frame
        frame.origin.x = 0
        frame.origin.y = frame.size.height * 1
        scrollView.scrollRectToVisible(frame, animated: true)
        
        
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
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 30.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        let myTitle2 = NSAttributedString(string:  pickerData[0], attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 35.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
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
        return 70.0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value = pickerData[row]
        playType = value
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}