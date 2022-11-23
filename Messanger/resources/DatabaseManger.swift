//
//  DatabaseManger.swift
//  Messanger
//
//  Created by mobin on 10/30/22.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager {
    static var db = DatabaseManager()
    var database = Database.database().reference()
}

extension DatabaseManager {
    
    public func userExists(with  email: String , completion: @escaping((Bool) -> Void) ) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-", options: .literal, range: nil)
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-", options: .literal, range: nil)

        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            guard snapShot.value as? String  != nil  else {
                completion(false)
                return
            }
            
            completion(true)
        }
        }
    
    // insert new user to the database
    public func insertUser (user : ChatAppUserModel ) {

        database.child(user.safeEmail).setValue([
            "firstName": user.firstName,
            "last_name": user.lastName
            
        ])
     }
}



struct ChatAppUserModel{
    let firstName : String
    let lastName : String
    let emailAddress: String
    
    var safeEmail : String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail
            .replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    
}
    




