//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by Stanislav Starovoytov on 28.09.2020.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    

    
    
}

// MARK: - Account managment

extension DatabaseManager {
    
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                
                completion(false)
                return
            }
            
            completion(true)
            
        }
        
    }
    
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        
        ]) { (error, _) in
            guard error == nil else {
                print("Failed to write to database")
                completion(false)
                return
            }
            completion(true)
            
        }
        
    }
    
    
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    var safeEmail: String {
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        //starovoytov50-gmail-com-profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}
