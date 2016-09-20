//
//  EditAccountViewController.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 9/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView


class EditAccountViewController: UIViewController {

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: AnyObject) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        account.account_name = nameAccount.text!
        try! realm.commitWriteTransaction()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func save2(sender: AnyObject) {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        account.account_name = nameAccount.text!
        try! realm.commitWriteTransaction()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteAccount(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
//                        kTitleFont: UIFont(name: "WRTishKid", size: 20)!,
//                        kTextFont: UIFont(name: "WRTishKid", size: 16)!,
//                        kButtonFont: UIFont(name: "WRTishKid", size: 16)!,
                        showCloseButton: false
                    )
        let alert = SCLAlertView(appearance:appearance)
        alert.addButton("ลบ", action: {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            let income = Income.allObjects()
            print(income.count)
            
            var tmp = [Int]()
            var j = 0
            
            for i in 0..<income.count{
                if ((income[i] as! Income).account_id == self.account.account_id){
                    tmp.append(Int(i) - j)
                    j += 1
                }
            }
            
            for i in 0..<tmp.count{
                realm.deleteObject(income[UInt(tmp[i])] as! Income)
            }
            
            let acc = Accounts.allObjects()
            for i in 0..<acc.count{
                if ((acc[i] as! Accounts).account_id == self.account.account_id){
                    realm.deleteObject(acc[i] as! Accounts)
                    break
                }
            }
            
            try! realm.commitWriteTransaction()
            
            self.performSegueWithIdentifier("backHome", sender: self)
            
        })
        
        alert.addButton("ไม่ลบ", action: {})
        alert.showEdit("ลบบัญชีใช่หรือไม่", subTitle: "")
        

    
    }

    
    @IBOutlet weak var nameAccount: UITextField!
    
    var account = Accounts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAccount.text = account.account_name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
