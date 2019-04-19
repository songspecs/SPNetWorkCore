//
//  Reg.swift
//  NetWorkCore
//
//  Created by 宋璞 on 2019/4/19.
//  Copyright © 2019 宋璞. All rights reserved.
//

import UIKit
import SwiftyJSON
import SPModelProtocol

public class Reg: ModelProtocol {
    var status: Int!
    var message: String!
    var data: JSON
    required public init?(json:JSON) {
        self.status = json[NetWorkCore.statusKey].intValue
        self.message = json[NetWorkCore.messageKey].string
        self.data = json[NetWorkCore.dataKey]
    }
}
