//
//  IncomeViewController.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class IncomeViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var income_type : String = ""
    var edit = false
    var edit_income = Income()
    var incomeArray = [Income]()
    var in_work = false
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    @IBOutlet weak var tf_note: UITextField!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var btn_parent: UIButton!
    @IBOutlet weak var btn_salary: UIButton!
    @IBOutlet weak var btn_gift: UIButton!
    @IBOutlet weak var btn_debt: UIButton!
    @IBOutlet weak var btn_sale: UIButton!
    @IBOutlet weak var btn_freelance: UIButton!
    @IBOutlet weak var btn_stock: UIButton!
    @IBOutlet weak var btn_other: UIButton!
    @IBAction func btn_confirm(sender: UIButton) {
        let realm = RLMRealm.defaultRealm()
        if edit{
            if Double(tf_money.text!) == nil {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
                    kTextFont: UIFont(name: "WRTishKid", size: 16)!,
                    kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                    showCloseButton: true
                )
                let alert = SCLAlertView(appearance:appearance)
                alert.showError("ผิดพลาด", subTitle: "กรุณาระบุจำนวนเงินให้ถูกต้อง")
            }else{
            realm.beginWriteTransaction()
            edit_income.money = Double(tf_money.text!)!
            edit_income.text = tf_note.text!
            edit_income.type = income_type
            try! realm.commitWriteTransaction()
            performSegueWithIdentifier("confirm_edit", sender: self)
            }
        }else{
            let income = Income()
            if Double(tf_money.text!) == nil {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
                    kTextFont: UIFont(name: "WRTishKid", size: 16)!,
                    kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                    showCloseButton: true
                )
                let alert = SCLAlertView(appearance:appearance)
                alert.showError("ผิดพลาด", subTitle: "กรุณาระบุจำนวนเงินให้ถูกต้อง")
            }else{
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            income.sorted_date = self.createSortDate(dateFormat.stringFromDate(NSDate()))
            income.money = Double(tf_money.text!)!
            income.type = income_type
            income.money_type = "income"
            let account = Account.allObjects()
            income.account_id = (account[0] as! Account).account_id
            let dateFormats = NSDateFormatter()
            dateFormats.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormats.timeStyle = NSDateFormatterStyle.ShortStyle
            income.saved_date = dateFormats.stringFromDate(NSDate())
            if tf_note.text! == "จดบันทึก..."{
                income.text = ""
            }else{
                income.text = tf_note.text!
            }
            if incomeArray.count < 1 {
                income.id = 0
            }else{
                income.id = (incomeArray[incomeArray.count-1].id)+1
            }
            income.date = createSortDate(dateFormat.stringFromDate(NSDate()))
            if income_type == "" || tf_money.text! == "" || tf_money.text! == "0" {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
                    kTextFont: UIFont(name: "WRTishKid", size: 16)!,
                    kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                    showCloseButton: true
                )
                let alert = SCLAlertView(appearance:appearance)
                alert.showError("ผิดพลาด", subTitle: "กรุณาระบุประเภท และ จำนวนเงินให้ถูกต้อง")
            }else{
                realm.beginWriteTransaction()
                realm.addObject(income)
                try! realm.commitWriteTransaction()
                performSegueWithIdentifier("confirm", sender: self)
            }
        }
        }
    }
    
    @IBAction func btn_parent_action(sender: UIButton) {
        setBorderType(btn_parent)
        income_type = "พ่อแม่"
    }
    @IBAction func btn_salary_action(sender: UIButton) {
        setBorderType(btn_salary)
        income_type = "เงินเดือน"
    }
    @IBAction func btn_gift_action(sender: UIButton) {
        setBorderType(btn_gift)
        income_type = "ของขวัญ"
    }
    @IBAction func btn_debt_action(sender: UIButton) {
        setBorderType(btn_debt)
        income_type = "ยืม"
    }
    @IBAction func btn_sale_action(sender: UIButton) {
        setBorderType(btn_sale)
        income_type = "ขายของ"
    }
    @IBAction func btn_freelance_action(sender: UIButton) {
        setBorderType(btn_freelance)
        income_type = "ฟรีแลนซ์"
    }
    @IBAction func btn_stock_action(sender: UIButton) {
        setBorderType(btn_stock)
        income_type = "หุ้น"
    }
    @IBAction func btn_other_action(sender: UIButton) {
        setBorderType(btn_other)
        income_type = "รายได้อื่นๆ"
    }
    @IBAction func btn_back_to_main(sender: UIButton) {
        if edit{
            performSegueWithIdentifier("back_to_table", sender: self)
        }else{
            performSegueWithIdentifier("back_to_main", sender: self)
        }
    }
    @IBAction func btn_back_to_main1(sender: UIButton) {
        if edit{
            performSegueWithIdentifier("back_to_table", sender: self)
        }else{
            performSegueWithIdentifier("back_to_main", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherAllData()
        tf_note.delegate = self
        tf_note.font = UIFont(name: "WRTishKid", size: 23)
        tf_money.delegate = self
        tf_money.keyboardType = UIKeyboardType.NumberPad
        self.tap_gesture.delegate = self
        if edit{
            tf_money.text = String(edit_income.money)
            tf_note.text = edit_income.text
            income_type = edit_income.type
            switch edit_income.type {
            case "พ่อแม่":
                setBorderType(btn_parent)
            case "เงินเดือน":
                setBorderType(btn_salary)
            case "ของขวัญ":
                setBorderType(btn_gift)
            case "ยืม" :
                setBorderType(btn_debt)
            case "ขายของ":
                setBorderType(btn_sale)
            case "ฟรีแลนซ์":
                setBorderType(btn_freelance)
            case "หุ้น":
                setBorderType(btn_stock)
            case "รายได้อื่นๆ":
                setBorderType(btn_other)
            default:
                print("")
            }
        }
        // Do any additional setup after loading the view.
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if in_work{
            tf_money.resignFirstResponder()
            tf_note.resignFirstResponder()
            return true
        }else{
            return false
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        in_work = true
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        in_work = false
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setBorderType(button:UIButton){
        btn_parent.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_parent.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_salary.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_salary.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_gift.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_gift.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_debt.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_debt.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_sale.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_sale.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_freelance.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_freelance.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_stock.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_stock.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_other.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        btn_other.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        button.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "WRTishKid", size: 25)
    }
    func gatherAllData(){
        let income = Income.allObjects()
        for i in 0..<income.count {
            incomeArray.append(income[i] as! Income)
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
