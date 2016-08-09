//
//  HistoryViewController.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/11/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
import Realm
import CVCalendar
class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var cal_time: UIButton!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    var sum_day = 0.0
    var dateInTable = [Int]()
    var calTime : Int = 0
    var calType : String = "day"
    var dayCount : Int = 1
    var transaction_day = [Int:Int]()
    @IBAction func btn_left_day(sender: UIButton) {
        if calType == "day" {
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
           lb_date.text = format.stringFromDate(format.dateFromString((lb_date.text)!)!.dateByAddingTimeInterval(-60*60*24))
            gatherAllData()
            calculateDay(lb_date.text!)
            tableview.reloadData()
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        }else if calType == "week"{
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            lb_date.text = format.stringFromDate(format.dateFromString((lb_date.text)!)!.dateByAddingTimeInterval(-60*60*24*7))
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<wd{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(wd-i))))
            }
            for i in wd..<8{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-wd))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
            tableview.reloadData()
        }else{
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            if month == 1 {
            dateComponents.month = 12
            dateComponents.year = year-1
            }else{
            dateComponents.month = month-1
            }
            dateComponents.day = day
            lb_date.text = dateFormat.stringFromDate(calendar.dateFromComponents(dateComponents)!)
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<day{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(day-i))))
            }
            for i in day..<dayCount{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-day))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
            tableview.reloadData()
        }
    }
    @IBAction func btn_right_day(sender: UIButton) {
        if calType == "day" {
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            lb_date.text = format.stringFromDate(format.dateFromString((lb_date.text)!)!.dateByAddingTimeInterval(60*60*24))
            gatherAllData()
            calculateDay(lb_date.text!)
            tableview.reloadData()
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        }else if calType == "week"{
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            lb_date.text = format.stringFromDate(format.dateFromString((lb_date.text)!)!.dateByAddingTimeInterval(60*60*24*7))
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<wd{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(wd-i))))
            }
            for i in wd..<8{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-wd))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
            tableview.reloadData()
        }else{
            sum_day = 0.0
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            if month == 12 {
                dateComponents.month = 1
                dateComponents.year = year+1
            }else{
                dateComponents.month = month+1
            }
            dateComponents.day = day
            lb_date.text = dateFormat.stringFromDate(calendar.dateFromComponents(dateComponents)!)
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<day{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(day-i))))
            }
            for i in day..<dayCount{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-day))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
            tableview.reloadData()
        }

    }
    @IBAction func btn_calendar_action(sender: UIButton) {
        if calTime == 0 {
            sum_day = 0.0
            cal_time.setTitle("รายสัปดาห์", forState: .Normal)
            calType = "week"
            dayCount = 7
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<wd{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(wd-i))))
            }
            for i in wd..<8{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-wd))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        }else if calTime == 1 {
            sum_day = 0.0
            cal_time.setTitle("รายเดือน", forState: .Normal)
            calType = "month"
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(self.lb_date.text!)!)
            var day = components.day
            var month = components.month
            var year = components.year
            var wd = components.weekday
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            let dat = calendar.dateFromComponents(dateComponents)!
            let rge = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: dat)
            dayCount = rge.length
            income_day = [Income]()
            transaction_day = [Int:Int]()
            sortIncome()
            for i in 1..<day{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(-60*60*24*Double(day-i))))
            }
            for i in day..<dayCount{
                calculateDay(dateFormat.stringFromDate(dateFormat.dateFromString(self.lb_date.text!)!.dateByAddingTimeInterval(60*60*24*Double(i-day))))
            }
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        }else{
            sum_day = 0.0
            calType = "day"
            cal_time.setTitle("รายวัน", forState: .Normal)
            dayCount = 1
            income_day = [Income]()
            calculateDay(lb_date.text!)
            var numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = ""
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        }
        calTime += 1
        if calTime == 3 {
            calTime = 0
        }
        tableview.reloadData()
    }
    @IBAction func btn_back_action(sender: UIButton) {
    }
    @IBOutlet weak var tableview: UITableView!
    var income_day = [Income]()
    var incomeArray = [Income]()
    var sortedIncome = [Int]()
    var sortedExpense = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        lb_date.text = dateFormat.stringFromDate(NSDate())
        gatherAllData()
        calculateDay(lb_date.text!)
        tableview.delegate = self
        tableview.reloadData()
        self.view.layoutIfNeeded()
        var numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        lb_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
        // Do any additional setup after loading the view.
    }
    func presentationMode() -> CalendarMode {
        return CalendarMode.MonthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.Monday
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return income_day.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let type = cell.viewWithTag(1) as! UILabel
            type.text = income_day[indexPath.row].type
        let note = cell.viewWithTag(2) as! UILabel
            note.text = income_day[indexPath.row].text
        let img = cell.viewWithTag(3) as! UIImageView
            img.image = UIImage(named: income_day[indexPath.row].type)
        var numberFormatter = NSNumberFormatter()
        numberFormatter.internationalCurrencySymbol = ""
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
        let money = cell.viewWithTag(4) as! UILabel
            money.text = numberFormatter.stringFromNumber(income_day[indexPath.row].money as NSNumber)
            if income_day[indexPath.row].money_type == "income"{
            money.textColor = UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0)
            }else{
            money.textColor = UIColor(red: 232/255, green: 81/255, blue: 83/255, alpha: 1.0)
        }
        let date = cell.viewWithTag(5) as! UILabel
        date.text = income_day[indexPath.row].saved_date
        return cell
    }
    func gatherAllData(){
        incomeArray = [Income]()
        income_day = [Income]()
        sortedIncome = [Int]()
        sortedExpense = [Int]()
        transaction_day = [Int:Int]()
        let account = Account.allObjects()
        let income = Income.allObjects()
        for i in 0..<income.count {
            
            if (income[i] as! Income).account_id == (account[0] as! Account).account_id{
            incomeArray.append(income[i] as! Income)
            }
        }
        sortIncome()
        for i in 0..<incomeArray.count{
            sortedIncome.append(incomeArray[i].date)
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
    func sortIncome(){
        incomeArray.sortInPlace({$0.sorted_date < $1.sorted_date})
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
    func calculateDay(date:String){
        var calculate_date = createSortDate(date)
        let calendar = NSCalendar.currentCalendar()
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(date)!)
        var day = components.day
        var idx = -1
        if incomeArray.count > 0 {
            idx = binarySearch(sortedIncome, searchItem: calculate_date)
            
            if idx == -1 {
                
            }else{
                dateInTable.append(day)
                for i in idx..<incomeArray.count{
                    if calculate_date == incomeArray[i].date{
                        if incomeArray[i].money_type == "income"{
                        sum_day += incomeArray[i].money
                        }else{
                            sum_day -= incomeArray[i].money
                        }
                        income_day.append(incomeArray[i])
                        if transaction_day[day] == nil {
                            transaction_day[day] = 1
                        }else{
                            transaction_day[day]! += 1
                        }
                    }
                }
            }
        }
    }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete", handler: {_,_ in
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
                kTextFont: UIFont(name: "WRTishKid", size: 16)!,
                kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance:appearance)
            alert.addButton("ลบ", action: {
                
                if indexPath.row < self.income_day.count{
                    for i in 0..<self.incomeArray.count{
                        if self.incomeArray[i].id == self.income_day[indexPath.row].id {
                            let realm = RLMRealm.defaultRealm()
                            realm.beginWriteTransaction()
                            realm.deleteObject(self.incomeArray[i])
                            try! realm.commitWriteTransaction()
                            self.incomeArray.removeAtIndex(i)
                            self.income_day.removeAtIndex(indexPath.row)
                            self.gatherAllData()
                            self.calculateDay(self.lb_date.text!)
                            self.tableview.reloadData()
                            break
                        }
                    }
                }
                
                
            })
            alert.addButton("ไม่", action: {})
            alert.showError("เตือน", subTitle: "คุณต้องการจะลบใช่หรือไม่")
        })
        delete.backgroundColor = UIColor(red:232/255,green:81/255,blue:83/255,alpha:1.0)
        let edit = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "edit", handler: {_,_ in
            if indexPath.row < self.income_day.count{
                self.performSegueWithIdentifier("edit_income", sender: indexPath)
            }else{
                self.performSegueWithIdentifier("edit_expense", sender: indexPath)
            }
        })
        edit.backgroundColor = UIColor(red: 120/255, green: 183/255, blue: 189/255, alpha: 1.0)
        return [delete,edit]
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableview.indexPathForSelectedRow
        if segue.identifier == "edit_income"{
            if let des = segue.destinationViewController as? IncomeViewController{
                des.edit = true
                let indexPath = sender as! NSIndexPath
                des.edit_income = self.income_day[indexPath.row]
            }
        }else if segue.identifier == "edit_expense"{
            if let des = segue.destinationViewController as? ExpenseViewController{
                des.edit = true
                let indexPath = sender as! NSIndexPath
                des.edit_expense = self.income_day[indexPath.row]
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 105
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
