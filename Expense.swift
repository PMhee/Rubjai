//
//  Expense.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/11/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class Expense:RLMObject{
    dynamic var type : String = ""
    dynamic var money : Double = 0.0
    dynamic var text : String = ""
    dynamic var date : Int = 0
    dynamic var id : Int = 0
    dynamic var sort_date : Int = 0
}