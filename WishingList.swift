//
//  WishingList.swift
//  รับจ่าย
//
//  Created by Peeranut Mahatham on 9/2/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Realm
class WishingList:RLMObject{
    dynamic var wishingList_id : String = ""
    dynamic var wishingList_name : String = ""
    dynamic var wishingList_price : Double = 0.0
    dynamic var wishingList_image : String = ""
    dynamic var wishingList_finalDate : String = ""
    dynamic var account_id : String = ""
    dynamic var wishingList_hasPaid : Bool = false

}