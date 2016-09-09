//
//  Accounts.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 9/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Accounts:RLMObject{
    dynamic var account_id : String = ""
    dynamic var account_name : String = ""
    dynamic var currentMoney : Double = 0.0
}