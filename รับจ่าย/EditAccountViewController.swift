//
//  EditAccountViewController.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 9/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController {

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func save(sender: AnyObject) {
    }
    @IBAction func save2(sender: AnyObject) {
    }
    @IBOutlet weak var nameAccount: UITextField!
    @IBOutlet weak var moneyAccount: UITextField!
    
    var accountName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAccount.text = accountName

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
