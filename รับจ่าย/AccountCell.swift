//
//  AccountCell.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 8/16/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import FoldingCell

class AccountCell: FoldingCell {

    
    //@IBOutlet weak var goToPortButton: UIButton!
    
    @IBOutlet weak var accountMoney: UILabel!
    @IBOutlet weak var accountMoney2: UILabel!
    
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountName2: UILabel!
    
    @IBOutlet weak var moneyFixedLabel: UILabel!
    @IBOutlet weak var moneyFixedLabel2: UILabel!
    
    @IBOutlet weak var nameFixedLabel: UILabel!
    
        
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var goToAccountButton: UIButton!
    
    
    //WishingList
    @IBOutlet weak var wlImage: UIImageView!
    @IBOutlet weak var wlName: UILabel!
    @IBOutlet weak var wlPrice: UILabel!
    @IBOutlet weak var wlFinalDate: UILabel!
    @IBOutlet weak var wlRemainingDate: UILabel!
    @IBOutlet weak var wlCurrentPrice: UILabel!
    @IBOutlet weak var wlPrice2: UILabel!
    @IBOutlet weak var wlPercent: UILabel!
    @IBOutlet weak var wlPage: UIPageControl!
    @IBOutlet weak var noWL: UILabel!
    @IBOutlet weak var wlProgressBar: UIProgressView!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var avgPrice: UILabel!

    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        accountMoney.adjustsFontSizeToFitWidth = true
        accountMoney2.adjustsFontSizeToFitWidth = true
        accountName.adjustsFontSizeToFitWidth = true
        accountName2.adjustsFontSizeToFitWidth = true
        moneyFixedLabel.adjustsFontSizeToFitWidth = true
        moneyFixedLabel2.adjustsFontSizeToFitWidth = true
        nameFixedLabel.adjustsFontSizeToFitWidth = true
        
        //WishingList
        wlName.adjustsFontSizeToFitWidth = true
        wlPrice.adjustsFontSizeToFitWidth = true
        wlFinalDate.adjustsFontSizeToFitWidth = true
        wlRemainingDate.adjustsFontSizeToFitWidth = true
        wlCurrentPrice.adjustsFontSizeToFitWidth = true
        wlPrice2.adjustsFontSizeToFitWidth = true
        wlPercent.adjustsFontSizeToFitWidth = true
        avgLabel.adjustsFontSizeToFitWidth = true
        avgPrice.adjustsFontSizeToFitWidth = true


        super.awakeFromNib()
        
        
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
        
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    

}
