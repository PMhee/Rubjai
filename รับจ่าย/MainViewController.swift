//
//  MainViewController.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import iAd
import Realm
import SCLAlertView

class MainViewController: UIViewController,UITextFieldDelegate,ADBannerViewDelegate {
    var incomeArray = [Income]()
    var sortedDate = [Int]()
    var today = NSDate()
    //@IBOutlet weak var tf_start_money: UITextField!
    //@IBOutlet weak var iAdBanner: ADBannerView!
//    @IBOutlet weak var alert_setting: UIView!
//    @IBOutlet weak var tf_input_money: UITextField!
    @IBOutlet var banner: ADBannerView!
    
    @IBOutlet weak var lb_today_money: UILabel!
    @IBOutlet weak var lb_all_money: UILabel!
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var btn_account: UIButton!
//    @IBAction func btn_reset_action(sender: UIButton) {
//        let realm = RLMRealm.defaultRealm()
//        realm.beginWriteTransaction()
//        realm.deleteAllObjects()
//        try! realm.commitWriteTransaction()
//        alert_setting.hidden = true
//        if let tag = main_view.viewWithTag(1) {
//            tag.removeFromSuperview()
//        }
//        incomeArray.removeAll()
//        gatherAll()
//    }
//    @IBAction func confirm_alert_setting(sender: UIButton) {
//        alert_setting.hidden = true
//        if let tag = main_view.viewWithTag(1) {
//            tag.removeFromSuperview()
//        }
//        
//    }
    @IBAction func btn_switch_account(sender: UIButton) {
        let account = Account.allObjects()
        let setting = Setting.allObjects()
        let acc = account[0] as! Account
        var count = 0
        if setting.count == 1 {
            
        }else{
            count = acc.count
            count += 1
            if UInt(count) >= setting.count{
                count = 0
            }
            btn_account.setTitle((setting[UInt(count)] as! Setting).account_id, forState: .Normal)
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let a = account[0] as! Account
            a.count = count
            a.account_id = setting[UInt(count)].account_id
            try! realm.commitWriteTransaction()
            gatherAll()
        }
    }
    @IBAction func add_account(sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
            kTextFont: UIFont(name: "WRTishKid", size: 16)!,
            kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance:appearance)
        let txt = alert.addTextField("ใส่ชื่อบัญชี")
        
        alert.addButton("ตกลง", action: {
            let set = Setting()
            let realm  = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            set.account_id = txt.text!
            realm.addObject(set)
            try! realm.commitWriteTransaction()
            let account = Account.allObjects()
            let setting = Setting.allObjects()
            let acc = account[0] as! Account
            var count = 0
            if setting.count == 1 {
                
            }else{
                count = acc.count
                count += 1
                if UInt(count) >= setting.count{
                    count = 0
                }
                self.btn_account.setTitle((setting[UInt(count)] as! Setting).account_id, forState: .Normal)
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                let a = account[0] as! Account
                a.count = count
                a.account_id = setting[UInt(count)].account_id
                try! realm.commitWriteTransaction()
                self.gatherAll()
            }

        })
        alert.addButton("ยกเลิก", action: {
        })
        alert.showEdit("เพิ่มบัญชี", subTitle: "กรุณาระบุชื่อบัญชี")
        

    }
//    @IBAction func btn_confirm(sender: UIButton) {
//        if tf_start_money.text != ""{
//            let realm = RLMRealm.defaultRealm()
//            realm.beginWriteTransaction()
//            let income = Income()
//            income.money = Double(tf_start_money.text!)!
//            income.type = "เงินเริ่มต้น"
//            realm.addObject(income)
//            try! realm.commitWriteTransaction()
//            alert_setting.hidden = true
//            if let tag = main_view.viewWithTag(1) {
//                tag.removeFromSuperview()
//            }
//            
//        }
//        gatherAll()
//    }
    @IBAction func btn_minus(sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
            kTextFont: UIFont(name: "WRTishKid", size: 16)!,
            kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance:appearance)
        alert.addButton("ตกลง", action: {
            let set = Setting()
            var setting = Setting.allObjects()
             let account = Account.allObjects()
            let acc = account[0] as! Account
            let realm  = RLMRealm.defaultRealm()
            if setting.count == 1 {
                
            }else{
            realm.beginWriteTransaction()
            let s = setting[UInt(acc.count)] as! Setting
            realm.deleteObject(s)
            try! realm.commitWriteTransaction()
            }
            var count = 0
            setting = Setting.allObjects()
            if setting.count == 1 {
                count = acc.count
                count -= 1
                if count == -1 {
                    count = 0
                }
                print(count)
                self.btn_account.setTitle((setting[UInt(count)] as! Setting).account_id, forState: .Normal)
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                let a = account[0] as! Account
                a.count = count
                a.account_id = setting[UInt(count)].account_id
                try! realm.commitWriteTransaction()
                self.gatherAll()

            }else{
                count = acc.count
                count -= 1
                if count == -1 {
                    count = 0
                }
                print(count)
                self.btn_account.setTitle((setting[UInt(count)] as! Setting).account_id, forState: .Normal)
                let realm = RLMRealm.defaultRealm()
                realm.beginWriteTransaction()
                let a = account[0] as! Account
                a.count = count
                a.account_id = setting[UInt(count)].account_id
                try! realm.commitWriteTransaction()
                self.gatherAll()
            }
        })
        alert.addButton("ยกเลิก", action: {
        })
        alert.showWarning("เตือน", subTitle: "ต้องการจะลบบัญชีใช่หรือไม่")
    }
//    @IBAction func btn_setting_action(sender: UIButton) {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let blur = UIVisualEffectView(effect: blurEffect)
//        blur.frame = self.view.bounds
//        blur.tag = 1
//        main_view.addSubview(blur)
//        alert_setting.hidden = false
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //tf_start_money.delegate = self
        let account = Account.allObjects()
        if account.count > 0 {
            btn_account.setTitle((account[0] as! Account).account_id, forState: .Normal)
        }
        self.canDisplayBannerAds = true
        self.banner?.delegate = self
        self.banner?.hidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let setting = Setting.allObjects()
        if setting.count == 0 {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
                kTextFont: UIFont(name: "WRTishKid", size: 16)!,
                kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance:appearance)
            let txt = alert.addTextField("ใส่ชื่อบัญชี")
            alert.addButton("ตกลง", action: {
                let setting = Setting()
                let account = Account()
                let realm  = RLMRealm.defaultRealm()
                setting.account_id = txt.text!
                account.account_id = txt.text!
                account.count = 0
                realm.beginWriteTransaction()
                realm.addObject(setting)
                realm.addObject(account)
                try! realm.commitWriteTransaction()
                let acc = Account.allObjects()
                self.btn_account.setTitle((acc[0] as! Account).account_id, forState: .Normal)
            })
            alert.showEdit("เพิ่มบัญชี", subTitle: "กรุณาระบุชื่อบัญชี")
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///Banner
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
        
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        
        self.banner?.hidden = false
    }
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
        
    }
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherAll()
    }
    func gatherAll(){
        let income = Income.allObjects()
        incomeArray = [Income]()
        var sumAll = 0.0
        let account = Account.allObjects()
        sortedDate = [Int]()
        if account.count > 0 {
        for i in 0..<income.count{
            if (income[i] as! Income).account_id == (account[0] as! Account).account_id{
            incomeArray.append(income[i] as! Income)
            if (income[i] as! Income).money_type == "income"{
            sumAll += (income[i] as! Income).money
            }else{
                sumAll -= (income[i] as! Income).money
            }
            }
        }
        }else{
            for i in 0..<income.count{
               
                    incomeArray.append(income[i] as! Income)
                    if incomeArray[Int(i)].money_type == "income"{
                        sumAll += incomeArray[Int(i)].money
                    }else{
                        sumAll -= incomeArray[Int(i)].money
                    }

            }

        }
        self.sortIncome()
        for i in 0..<incomeArray.count {
            sortedDate.append(incomeArray[i].date)
        }
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
        var day = components.day
        var month = components.month
        var year = components.year
        var dateToday = createSortDate(dateFormat.stringFromDate(NSDate()))
        var sum_day : Double  = 0.0
        if incomeArray.count > 0 {
            var idx = binarySearch(sortedDate, searchItem: dateToday)
            
            if idx == -1 {
                
            }else{
                print(idx)
                print(incomeArray.count)
                for i in idx..<incomeArray.count{
                    if dateToday == incomeArray[i].date{
                        if incomeArray[i].money_type == "income"{
                        sum_day += incomeArray[i].money
                        }else{
                        sum_day -= incomeArray[i].money
                        }
                    }
                }
            }
        }
        var numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        self.lb_all_money.text = numberFormatter.stringFromNumber(sumAll as NSNumber)
        self.lb_today_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sortIncome(){
        incomeArray.sortInPlace({$0.date < $1.date})
    }
    func binarySearch<T:Comparable>(inputArr:Array<T>, searchItem: T)->Int{
        var lowerIndex = 0
        var upperIndex = inputArr.count - 1
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                if currentIndex != 0 {
                    if inputArr[currentIndex-1] == searchItem{
                        upperIndex = currentIndex - 1
                    }else{
                        return currentIndex
                    }
                }else{
                    return 0
                }
            } else if (lowerIndex > upperIndex) {
                return -1
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    func createSortDate(date:String)->Int{
        let dateFormatt = NSDateFormatter()
        dateFormatt.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatt.dateFromString(date)
        let formatt = NSDateFormatter()
        formatt.dateStyle = NSDateFormatterStyle.ShortStyle
        var d = formatt.stringFromDate(dateFormatt.dateFromString(date)!)
        var range = d.rangeOfString("/")!
        var index = d.startIndex.distanceTo(range.startIndex)
        var month = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        d = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        range = d.rangeOfString("/")!
        index = d.startIndex.distanceTo(range.startIndex)
        if month.characters.count == 1 {
            month = "0"+month
        }
        var day = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(0), end: d.startIndex.advancedBy(index)))
        if day.characters.count == 1 {
            day = "0"+day
        }
        var year = d.substringWithRange(Range<String.Index>(start: d.startIndex.advancedBy(index+1), end: d.endIndex.advancedBy(0)))
        if year.characters.count > 4 {
        var range: Range<String.Index> = year.rangeOfString(" ")!
        var index: Int = year.startIndex.distanceTo(range.startIndex)
        year = year.substringWithRange(Range<String.Index>(start: year.startIndex.advancedBy(0), end: year.startIndex.advancedBy(index)))
        }
        return Int(year+month+day)!
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
