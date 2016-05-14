//
//  ManHuaReponse.swift
//  ManHuaRe
//
//  Created by 孙宇 on 16/3/30.
//  Copyright © 2016年 孙宇. All rights reserved.
//

import UIKit

class ManHuaReponse: NSObject {
    var success:Bool = false
    var message:String = "No message"
    init(success:Bool,message:String?) {
        super.init()
        self.success = success
        if let message = message{
            self.message = message
        }
    }
    init(success:Bool) {
        super.init()
        self.success = success
    }

}

class ManHuaValueResponse<T>: ManHuaReponse {
    var value:T?
    
    override init(success: Bool) {
        super.init(success: success)
    }
    
    override init(success:Bool,message:String?) {
        super.init(success:success)
        if let message = message {
            self.message = message
        }
    }
    convenience init(value:T,success:Bool) {
        self.init(success: success)
        self.value = value
    }
    convenience init(value:T,success:Bool,message:String?) {
        self.init(value:value,success:success)
        if let message = message {
            self.message = message
        }
    }
}