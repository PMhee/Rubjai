//
//  AnalysisViewController.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/23/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Charts
import Realm
class AnalysisViewController: UIViewController,ChartViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var under_expense: UIView!
    @IBOutlet weak var under_income: UIView!
    var money_all = [Income]()
    var income_all = [Income]()
    var expense_all = [Income]()
    var count_income_type = [String:Double]()
    var count_expense_type = [String:Double]()
    var sort_count_income_type = [String]()
    var sort_count_income_money = [Double]()
    var sort_count_expense_type = [String]()
    var sort_count_expense_money = [Double]()
    var graph_type :String = "income"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lb_year: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    var income_color = [UIColor(red:118/255,green:193/255,blue:161/255,alpha:1.0),UIColor(red:84/255,green:208/255,blue:148/255,alpha:1.0),UIColor(red:169/255,green:208/255,blue:133/255,alpha:1.0),UIColor(red:184/255,green:216/255,blue:111/255,alpha:1.0),UIColor(red:176/255,green:201/255,blue:41/255,alpha:1.0)]
    var expense_color = [UIColor(red:234/255,green:76/255,blue:68/255,alpha:1.0),UIColor(red:255/255,green:120/255,blue:120/255,alpha:1.0),UIColor(red:255/255,green:153/255,blue:153/255,alpha:1.0),UIColor(red:255/255,green:181/255,blue:181/255,alpha:1.0),UIColor(red:255/255,green:204/255,blue:204/255,alpha:1.0)]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        under_expense.hidden = true
    }
    @IBAction func btn_right(sender: UIButton) {
        var tt = lb_year.text!
        tt = tt.substringWithRange(Range<String.Index>(start: tt.startIndex.advancedBy(12), end: tt.endIndex.advancedBy(0)))
        var t = Int(tt)!
        t += 1
        lb_year.text = "รายการประจำปี "+String(t)
        gatherAllData()
        sort_count_income_type = [String]()
        sort_count_income_money = [Double]()
        sort_count_expense_type = [String]()
        sort_count_expense_money = [Double]()
        for (k,v) in (Array(count_income_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_income_type.append(k)
            sort_count_income_money.append(v)
        }
        for (k,v) in (Array(count_expense_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_expense_type.append(k)
            sort_count_expense_money.append(v)
        }
                createGraph()
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        tableView.reloadData()
    }
    @IBAction func btn_left_action(sender: UIButton) {
        var tt = lb_year.text!
        tt = tt.substringWithRange(Range<String.Index>(start: tt.startIndex.advancedBy(12), end: tt.endIndex.advancedBy(0)))
        var t = Int(tt)!
        t -= 1
        lb_year.text = "รายการประจำปี "+String(t)
        gatherAllData()
        sort_count_income_type = [String]()
        sort_count_income_money = [Double]()
        sort_count_expense_type = [String]()
        sort_count_expense_money = [Double]()
        for (k,v) in (Array(count_income_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_income_type.append(k)
            sort_count_income_money.append(v)
        }
        for (k,v) in (Array(count_expense_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_expense_type.append(k)
            sort_count_expense_money.append(v)
        }
        createGraph()
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        tableView.reloadData()
    }
    @IBAction func btn_income_action(sender: UIButton) {
        sort_count_income_type = [String]()
        sort_count_income_money = [Double]()
        sort_count_expense_type = [String]()
        sort_count_expense_money = [Double]()
        for (k,v) in (Array(count_income_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_income_type.append(k)
            sort_count_income_money.append(v)
        }
        for (k,v) in (Array(count_expense_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_expense_type.append(k)
            sort_count_expense_money.append(v)
        }
        under_income.hidden = false
        under_expense.hidden = true
        
        graph_type = "income"
        createGraph()
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        tableView.reloadData()
    }
    @IBAction func btn_expense_action(sender: UIButton) {
        sort_count_income_type = [String]()
        sort_count_income_money = [Double]()
        sort_count_expense_type = [String]()
        sort_count_expense_money = [Double]()
        for (k,v) in (Array(count_income_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_income_type.append(k)
            sort_count_income_money.append(v)
        }
        for (k,v) in (Array(count_expense_type).sort {$0.1 > $1.1}) {
            print("\(k):\(v)")
            sort_count_expense_type.append(k)
            sort_count_expense_money.append(v)
        }
        under_income.hidden = true
        under_expense.hidden = false
        graph_type = "expense"
        createGraph()
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        sort_count_income_type = [String]()
        sort_count_income_money = [Double]()
        sort_count_expense_type = [String]()
        sort_count_expense_money = [Double]()
        gatherAllData()
        for (k,v) in (Array(count_income_type).sort {$0.1 > $1.1}) {
             print("\(k):\(v)")
            sort_count_income_type.append(k)
            sort_count_income_money.append(v)
        }
        for (k,v) in (Array(count_expense_type).sort {$0.1 > $1.1}) {
             print("\(k):\(v)")
            sort_count_expense_type.append(k)
            sort_count_expense_money.append(v)
        }
        createGraph()
        pieChart.descriptionText = ""
        pieChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        tableView.reloadData()
    }
    func createGraph(){
        var types = [String]()
        var value = [Double]()
        if graph_type == "income" {
            if sort_count_income_type.count > 5 {
                if graph_type == "income"{
                    for  i in 0..<4{
                        types.append(sort_count_income_type[i])
                        value.append(sort_count_income_money[i])
                    }
                    types.append("อื่นๆ")
                    value.append(0)
                    for i in 4..<count_income_type.count{
                        value[4] += sort_count_income_money[i]
                    }
                }
                
            }else{
                if graph_type == "income"{
                    for i in 0..<count_income_type.count{
                        types.append(sort_count_income_type[i])
                        value.append(sort_count_income_money[i])
                    }
                }
            }
        }else if graph_type == "expense"{
            if count_expense_type.count > 5 {
                if graph_type == "expense"{
                    for  i in 0..<4{
                        types.append(sort_count_expense_type[i])
                        value.append(sort_count_expense_money[i])

                    }
                    types.append("อื่นๆ")
                    value.append(0)
                    for i in 4..<count_expense_type.count{
                        value[4] += sort_count_expense_money[i]
                    }
                }
                
            }else{
                if graph_type == "expense"{
                    for i in 0..<count_expense_type.count{
                        types.append(sort_count_expense_type[i])
                        value.append(sort_count_expense_money[i])
                    }
                }
            }
        }
        setChart(types, values: value)
        
    }
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        pieChart.centerText = "รายรับ"
        if graph_type == "income"{
            pieChartDataSet.colors = income_color
        }else if graph_type == "expense" {
            pieChartDataSet.colors = expense_color
        }
        
    }
    func gatherAllData(){
        let money = Income.allObjects()
        money_all = [Income]()
        income_all = [Income]()
        expense_all = [Income]()
        count_income_type = [String:Double]()
        count_expense_type = [String:Double]()
        let account = Account.allObjects()
        for i in 0..<money.count{
            if (money[i] as! Income).account_id == (account[0] as! Account).account_id{
            money_all.append(money[i] as! Income)
            }
        }
        print(lb_year.text!)
        var tt = lb_year.text!
        tt = tt.substringWithRange(Range<String.Index>(start: tt.startIndex.advancedBy(12), end: tt.endIndex.advancedBy(0)))
        for i in 0..<money_all.count{
            let format = NSDateFormatter()
            format.dateStyle = NSDateFormatterStyle.FullStyle
            let calendar = NSCalendar.currentCalendar()
            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
            var components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: dateFormat.dateFromString(money_all[i].saved_date)!)
            var year = components.year
            if String(year) == tt{
                if money_all[i].money_type == "income"{
                    if count_income_type[money_all[i].type] == nil {
                        count_income_type[money_all[i].type] = money_all[i].money
                    }else{
                        count_income_type[money_all[i].type]! += money_all[i].money
                    }
                    income_all.append(money_all[i])
                }else{
                    if count_expense_type[money_all[i].type] == nil {
                        count_expense_type[money_all[i].type] = money_all[i].money
                    }else{
                        count_expense_type[money_all[i].type]! += money_all[i].money
                    }
                    expense_all.append(money_all[i])
                }
            }
        }
        
    }
    func sortIncomeType(){
        count_income_type.keysSortedByValue(<)
    }
    func sortExpenseType(){
        count_expense_type.keysSortedByValue(<)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if graph_type == "income"{
            print(sort_count_income_type.count)
            return sort_count_income_type.count
        }else{
            return sort_count_expense_type.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if graph_type == "income"{
            let pic = cell.viewWithTag(1) as! UIImageView
            pic.image = UIImage(named: sort_count_income_type[indexPath.row])
            let money = cell.viewWithTag(2) as! UILabel
            let numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = "THB "
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            money.text = numberFormatter.stringFromNumber(sort_count_income_money[indexPath.row] as NSNumber)
            let v = cell.viewWithTag(3)
            if indexPath.row >= 5{
            v?.backgroundColor = income_color[4]
            }else{
            v?.backgroundColor = income_color[indexPath.row]
            }
            v?.layer.cornerRadius = 12
            v?.layer.masksToBounds = true
            return cell
        }else{
            let pic = cell.viewWithTag(1) as! UIImageView
            pic.image = UIImage(named: sort_count_expense_type[indexPath.row])
            let money = cell.viewWithTag(2) as! UILabel
            let numberFormatter = NSNumberFormatter()
            numberFormatter.internationalCurrencySymbol = "THB "
            numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyISOCodeStyle
            money.text = numberFormatter.stringFromNumber(sort_count_expense_money[indexPath.row] as NSNumber)
            let v = cell.viewWithTag(3)
            if indexPath.row >= 5{
                v?.backgroundColor = expense_color[4]
            }else{
                v?.backgroundColor = expense_color[indexPath.row]
            }
            v?.layer.cornerRadius = 12
            v?.layer.masksToBounds = true
            return cell

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

extension Dictionary {
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        return Array(self.keys).sort(isOrderedBefore)
    }
    
    // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return sortedKeys {
            isOrderedBefore(self[$0]!, self[$1]!)
        }
    }
    
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sort() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}
