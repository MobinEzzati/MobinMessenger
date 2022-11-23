//
//  ChatUsersModel.swift
//  Messanger
//
//  Created by mobin on 10/30/22.
//

import Foundation


struct ChatUsersModel {
    let firstName : String
    let email : String
    {
        var safeEmali = email.replacingOccurrences(of: <#T##StringProtocol#>, with: <#T##StringProtocol#>)
    }
    let password: String
    let profilePicture: String
    
}
