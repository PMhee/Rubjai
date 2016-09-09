//
//  Income.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Income:RLMObject{
    dynamic var account_id : String = "" //id
    dynamic var type : String = "" //type of source
    dynamic var money : Double = 0.0
    dynamic var text : String = ""
    dynamic var date : Int = 0
    dynamic var id : Int = 0
    dynamic var saved_date : String = ""
    dynamic var sorted_date : Int = 0
    dynamic var money_type : String = "" //income or expense
}