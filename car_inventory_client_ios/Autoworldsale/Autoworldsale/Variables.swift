//
//  Variables.swift
//  
//
//  Created by Jose De Jesus Garfias Lopez on 21/12/15.
//  Copyright © 2015 Jose De Jesus Garfias Lopez. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON

class VARS {
    
    let MaxToTopConstrait = CGFloat(-141);
    let MinToTopConstrait = CGFloat(16);
    
    let PrimaryRed = UIColor(red: 255/255, green: 65/255, blue: 129/255, alpha: 100);
    let PrimaryBlue = UIColor(red: 34/255, green: 148/255, blue: 199/255, alpha: 0.60);
    
    func getApiUrl() -> String {
        // Servidor:
        return "http://165.227.35.203:3100";
        
        
        // LOCAL:
        //return "https://aqngdgzbok.localtunnel.me";
        //return "http://10.255.36.222:3100";
        // return "http://10.10.10.3:3100";
    }
    
    func getEnterprise() -> String {
        return "5a5bf93f72ac690e7b1824c7";
    }
    
    func getCars() -> [String] {
        
        return ["audi","acura","bmw","chevrolet","chrysler","dodge","ford","gmc","hyundai","honda","infinity","jaguar","jeep","kia","mazda","mercedesbenz","mini","nissan","pontiac","saturn","toyota","volkswagen"];
    }
}

struct Session {
    
    var _id:String = "";
    var token:String = "";
    var phone:String = "";
    var name:String = "";
    var username:String = "";
    var email:String = "";
    var rol:String = "";
    var account_id:String = "";

    init(){
        
        if let UsuarioRecover = UserDefaults.standard.dictionary(forKey: "UserSession") {
            if let value = UsuarioRecover["_id"] as? NSString {
                _id = value as String;
            }
            if let value = UsuarioRecover["token"] as? NSString {
                token = value as String;
            }
            if let value = UsuarioRecover["phone"] as? NSString {
                phone = value as String;
            }
            if let value = UsuarioRecover["name"] as? NSString {
                name = value as String;
            }
            if let value = UsuarioRecover["username"] as? NSString {
                username = value as String;
            }
            if let value = UsuarioRecover["email"] as? NSString {
                email = value as String;
            }
            if let value = UsuarioRecover["rol"] as? NSString {
                rol = value as String;
            }
            if let value = UsuarioRecover["account_id"] as? NSString {
                account_id = value as String;
            }
        }
    }
}

