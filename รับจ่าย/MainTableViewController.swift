import UIKit
import FoldingCell
import Realm

class MainTableViewController: UITableViewController {
    
    let kCloseCellHeight: CGFloat = 164
    let kOpenCellHeight: CGFloat = 464
    
    let kRowsCount = 10
    
    var cellHeights = [CGFloat]()
    
    var incomeArray = [Income]()
    var sortedDate = [Int]()
    var today = NSDate()
    
    var accountToEdit = Int()
    
    @IBOutlet weak var portButtton: UIButton!
    
    var accountArr = [Account]()
    var accountMoneyArr = [String:Double]()
    
    let cell = [AccountCell]()
    
    @IBOutlet weak var setting: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createCellHeightsArray()
        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let button = UIButton()
        button.setImage(UIImage(named:"settings"), forState: UIControlState.Normal)
        button.frame = CGRectMake(0, 0, 30,30)
        
        
        setting.customView = button
        print(setting)
        self.navigationItem.leftBarButtonItem = setting
        //Realm
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let account = Account.allObjects()
        accountArr = [Account]()
        for i in 0..<account.count {
            accountArr.append(account[i] as! Account)
        }
        print(account.count)
        self.tableView.reloadData()
    }
    
    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountArr.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard case let cell as AccountCell = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.clearColor()
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath) as! AccountCell
        cell.accountName.text = accountArr[indexPath.row].account_id
        cell.accountName2.text = accountArr[indexPath.row].account_id
        
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editAccount(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        var wl = indexPath.row
        
        if(wl==0){
            cell.wlName.hidden = true
            cell.wlPrice.hidden = true
            cell.wlFinalDate.hidden = true
            cell.wlRemainingDate.hidden = true
            cell.wlCurrentPrice.hidden = true
            cell.wlPrice2.hidden = true
            cell.wlPercent.hidden = true
            cell.wlImage.hidden = true
            cell.wlProgressBar.hidden = true
            cell.avgPrice.hidden = true
            cell.avgLabel.hidden = true
            
        }else{
            cell.noWL.hidden = true
            cell.wlPrice.text = "\(indexPath.row)"
    
            
        }
        
        return cell
    }
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    // MARK: Table vie delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)
        
        
    }
    
    func editAccount(sender: UIButton) {
        print(sender.tag)
        accountToEdit = sender.tag
        self.performSegueWithIdentifier("editAccount", sender: self)
    }
    
    func nextWl(cell: String) {
        print(cell)
//        cell.index = 2
//        cell.wlPrice.text = "\(cell.index)"
        
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editAccount"){
            
            let nav = segue.destinationViewController as! UINavigationController
            let destinationController = nav.topViewController as! EditAccountViewController
            //let destinationController = segue.destinationViewController as! EditAccountViewController
            print(accountArr[accountToEdit].account_id)
            destinationController.accountName = accountArr[accountToEdit].account_id
        }
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
//        self.lb_all_money.text = numberFormatter.stringFromNumber(sumAll as NSNumber)
//        self.lb_today_money.text = numberFormatter.stringFromNumber(sum_day as NSNumber)
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



}
