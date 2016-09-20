//
//  AddAccountViewController.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 8/30/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm

class AddAccountViewController: UIViewController {

    @IBOutlet weak var nameAccount: UITextField!
    @IBOutlet weak var startMoney: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func create(sender: AnyObject) {
        
        if(nameAccount.text!.isEmpty){
            let alert = UIAlertController(title: "Alert", message: "โปรดใส่ชื่อบัญชี", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let account = Accounts()
            account.account_id = nameAccount.text!
            account.account_name = nameAccount.text!
            
            let income = Income()
            income.account_id = nameAccount.text!
            income.money = Double(startMoney.text!)!
            realm.addObject(account)
            realm.addObject(income)
            try! realm.commitWriteTransaction()
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    @IBAction func create2(sender: AnyObject) {
        if(nameAccount.text!.isEmpty){
            let alert = UIAlertController(title: "Alert", message: "โปรดใส่ชื่อบัญชี", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            let account = Accounts()
            account.account_id = nameAccount.text!
            account.account_name = nameAccount.text!
            
            let income = Income()
            income.account_id = nameAccount.text!
            income.money = Double(startMoney.text!)!
            realm.addObject(account)
            realm.addObject(income)
            try! realm.commitWriteTransaction()
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        //nameAccount.delegate = self
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        nameAccount.resignFirstResponder()
        startMoney.resignFirstResponder()
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
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
