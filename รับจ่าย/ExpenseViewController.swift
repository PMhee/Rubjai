//
//  ExpenseViewController.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class ExpenseViewController: UIViewController,UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    var expense_type : String = ""
    var edit = false
    var edit_expense = Income()
    var expenseArray = [Income]()
    var in_work = false
    @IBAction func btn_back_action(sender: UIButton) {
        if edit{
            performSegueWithIdentifier("back_to_history", sender: self)
        }else{
            performSegueWithIdentifier("back_to_main", sender: self)
        }
    }
    @IBAction func btn_back_action1(sender: UIButton) {
        if edit{
            performSegueWithIdentifier("back_to_history", sender: self)
        }else{
            performSegueWithIdentifier("back_to_main", sender: self)
        }
    }
    @IBAction func confirm(sender: UIButton) {
        let realm = RLMRealm.defaultRealm()
        let expense = Income()
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
                edit_expense.money = Double(tf_money.text!)!
                edit_expense.text = tf_note.text!
                edit_expense.type = expense_type
                try! realm.commitWriteTransaction()
                performSegueWithIdentifier("confirm_edit", sender: self)
            }
        }else{
            
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
                expense.sorted_date = self.createSortDate(dateFormat.stringFromDate(NSDate()))
                expense.money = Double(tf_money.text!)!
                expense.type = expense_type
                let account = Account.allObjects()
                expense.account_id = (account[0] as! Account).account_id
                let dateFormats = NSDateFormatter()
                dateFormats.dateStyle = NSDateFormatterStyle.FullStyle
                dateFormats.timeStyle = NSDateFormatterStyle.ShortStyle
                expense.saved_date = dateFormats.stringFromDate(NSDate())
                expense.money_type = "expense"
                if tf_note.text! == "จดบันทึก..."{
                    expense.text = ""
                }else{
                    expense.text = tf_note.text!
                }
                if expenseArray.count < 1 {
                    expense.id = 0
                }else{
                    expense.id = (expenseArray[expenseArray.count-1].id)+1
                }
                expense.date = createSortDate(dateFormat.stringFromDate(NSDate()))
                if expense_type == "" || tf_money.text! == "" || tf_money.text! == "0" {
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
                    realm.addObject(expense)
                    try! realm.commitWriteTransaction()
                    performSegueWithIdentifier("confirm", sender: self)
                }
            }
        }
    }
    @IBOutlet weak var scroll_view: UIScrollView!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var tf_note: UITextField!
    @IBOutlet weak var btn_transport: UIButton!
    @IBOutlet weak var btn_food: UIButton!
    @IBOutlet weak var btn_shirt: UIButton!
    @IBOutlet weak var btn_movie: UIButton!
    @IBOutlet weak var btn_health: UIButton!
    @IBOutlet weak var btn_love: UIButton!
    @IBOutlet weak var btn_party: UIButton!
    @IBOutlet weak var btn_gift: UIButton!
    @IBOutlet weak var btn_electric: UIButton!
    @IBOutlet weak var btn_water: UIButton!
    @IBOutlet weak var btn_phone: UIButton!
    @IBOutlet weak var btn_pet: UIButton!
    @IBOutlet weak var btn_sport: UIButton!
    @IBOutlet weak var btn_family: UIButton!
    @IBOutlet weak var btn_hotel: UIButton!
    @IBOutlet weak var btn_travel: UIButton!
    @IBOutlet weak var btn_other: UIButton!
    @IBOutlet weak var btn_electronic: UIButton!
    @IBOutlet weak var btn_shop: UIButton!
    @IBAction func btn_transport_action(sender: UIButton) {
        setBorderButtonType(btn_transport)
        expense_type = "เดินทาง"
    }
    @IBAction func btn_food_action(sender: UIButton) {
        setBorderButtonType(btn_food)
        expense_type = "อาหาร"
    }
    @IBAction func btn_shirt_action(sender: UIButton) {
        setBorderButtonType(btn_shirt)
        expense_type = "เสื้อผ้า"
    }
    @IBAction func btn_movie_action(sender: UIButton) {
        setBorderButtonType(btn_movie)
        expense_type = "ดูหนัง"
    }
    @IBAction func btn_health_action(sender: UIButton) {
        setBorderButtonType(btn_health)
        expense_type = "รักษา"
    }
    @IBAction func btn_love_action(sender: UIButton) {
        setBorderButtonType(btn_love)
        expense_type = "คนรัก"
    }
    @IBAction func btn_party_action(sender: UIButton) {
        setBorderButtonType(btn_party)
        expense_type = "ปาร์ตี้"
    }
    @IBAction func btn_shop_action(sender: UIButton) {
        setBorderButtonType(btn_shop)
        expense_type = "ชอปปิ้ง"
    }
    @IBAction func btn_gift_action(sender: UIButton) {
        setBorderButtonType(btn_gift)
        expense_type = "ค่าของขวัญ"
    }
    @IBAction func btn_water_action(sender: UIButton) {
        setBorderButtonType(btn_water)
        expense_type = "ค่าน้ำ"
    }
    @IBAction func btn_phone_action(sender: UIButton) {
        setBorderButtonType(btn_phone)
        expense_type = "โทรศัพท์"
    }
    @IBAction func btn_pet_action(sender: UIButton) {
        setBorderButtonType(btn_pet)
        expense_type = "สัตว์เลี้ยง"
    }
    @IBAction func btn_electrict_action(sender: UIButton) {
        setBorderButtonType(btn_electric)
        expense_type = "ไฟฟ้า"
    }
    @IBAction func btn_sport_action(sender: UIButton) {
        setBorderButtonType(btn_sport)
        expense_type = "กีฬา"
    }
    @IBAction func btn_family_action(sender: UIButton) {
        setBorderButtonType(btn_family)
        expense_type = "ครอบครัว"
    }
    @IBAction func btn_hotel_action(sender: UIButton) {
        setBorderButtonType(btn_hotel)
        expense_type = "ที่พัก"
    }
    @IBAction func btn_travel_action(sender: UIButton) {
        setBorderButtonType(btn_travel)
        expense_type = "ท่องเที่ยว"
    }
    @IBAction func btn_electronic_action(sender: UIButton) {
        setBorderButtonType(btn_electronic)
        expense_type = "อิเล็กทรอนิกส์"
    }
    @IBAction func btn_other_action(sender: UIButton) {
        setBorderButtonType(btn_other)
        expense_type = "รายจ่ายอื่นๆ"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gatherAllData()
        scroll_view.delegate = self
        tf_money.delegate = self
        tf_note.font = UIFont(name: "WRTishKid", size: 23)
        tf_note.delegate = self
        tf_money.keyboardType = UIKeyboardType.NumberPad
        self.tap_gesture.delegate = self
        if edit{
            tf_money.text = String(edit_expense.money)
            tf_note.text = edit_expense.text
            expense_type = edit_expense.type
            switch edit_expense.type {
            case "เดินทาง":
                setBorderButtonType(btn_transport)
            case "อาหาร":
                setBorderButtonType(btn_food)
            case "เสื้อผ้า":
                setBorderButtonType(btn_shirt)
            case "ดูหนัง":
                setBorderButtonType(btn_movie)
            case "รักษา":
                setBorderButtonType(btn_health)
            case "คนรัก":
                setBorderButtonType(btn_love)
            case "ปาร์ตี้":
                setBorderButtonType(btn_party)
            case "ชอปปิ้ง":
                setBorderButtonType(btn_shop)
            case "ค่าของขวัญ":
                setBorderButtonType(btn_gift)
            case "ค่าน้ำ":
                setBorderButtonType(btn_water)
            case "โทรศัพท์":
                setBorderButtonType(btn_phone)
            case "สัตว์เลี้ยง":
                setBorderButtonType(btn_pet)
            case "ไฟฟ้า":
                setBorderButtonType(btn_electric)
            case "กีฬา":
                setBorderButtonType(btn_sport)
            case "ครอบครัว":
                setBorderButtonType(btn_family)
            case "ที่พัก":
                setBorderButtonType(btn_hotel)
            case "ท่องเที่ยว":
                setBorderButtonType(btn_travel)
            case "อิเล็กทรอนิกส์":
                setBorderButtonType(btn_electronic)
            case "รายจ่ายอื่นๆ":
                setBorderButtonType(btn_other)
            default:
                print("")
            }
        }
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.text = ""
        in_work = true
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        in_work = false
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setBorderButtonType(button:UIButton){
        btn_transport.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_transport.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_food.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_food.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_shirt.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_shirt.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_movie.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_movie.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_health.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_health.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_love.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_love.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_party.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_party.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_shop.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_shop.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_gift.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_gift.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_water.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_water.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_phone.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_phone.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_pet.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_pet.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_electric.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_electric.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_sport.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_sport.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_family.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_family.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_hotel.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_hotel.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_travel.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_travel.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_electronic.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_electronic.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        btn_other.setTitleColor(UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0), forState: .Normal)
        btn_other.titleLabel?.font = UIFont(name: "WRTishKid", size: 20)
        button.setTitleColor(UIColor(red:134/255,green:135/255,blue:137/255,alpha:1.0), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "WRTishKid", size: 25)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        if (scrollView.contentOffset.y != 0) {
        //            var offset:CGPoint = scrollView.contentOffset
        //            offset.y = 0
        //            scrollView.contentOffset = offset
        //        }
        var offset:CGPoint = scrollView.contentOffset
        
        if (scrollView.contentOffset.y == -64){
            offset.y = 0
            scrollView.contentOffset = offset
        }
        if (scrollView.contentOffset.x != 0) {
            
            offset.x = 0
            scrollView.contentOffset = offset        }
    }
    func gatherAllData(){
        let expense = Expense.allObjects()
        for i in 0..<expense.count {
            expenseArray.append(expense[i] as! Income)
        }
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if in_work{
            tf_note.resignFirstResponder()
            tf_money.resignFirstResponder()
            return true
        }else{
            return false
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
