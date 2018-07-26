//
//  LoginViewController.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/20/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit
import Material
import Motion
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    let Variables = VARS();
    let Save = UserDefaults.standard;
    let ApiUrl = VARS().getApiUrl();
    var UsuarioSesion: NSDictionary!
    
    @IBOutlet weak var TopViewConstrait: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var button: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Textfields configurations
        usernameTextField.placeholder = "Username"
        usernameTextField.textColor = Color.white
        usernameTextField.placeholderNormalColor = Color.white
        usernameTextField.placeholderActiveColor = Color.white
        usernameTextField.dividerNormalColor = Color.white
        usernameTextField.dividerActiveColor = Color.white

        passwordTextField.placeholder = "Password"
        passwordTextField.textColor = Color.white
        passwordTextField.placeholderNormalColor = Color.white
        passwordTextField.placeholderActiveColor = Color.white
        passwordTextField.dividerNormalColor = Color.white
        passwordTextField.dividerActiveColor = Color.white
        
        button.title = "Login"
        button.titleColor = UIColor.white
        button.backgroundColor = self.Variables.PrimaryRed;
        button.pulseColor = .white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.KeyboardDidHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.KeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        
    }
    
    func login() {
        self.DismissKeyboard();
        
        if(self.usernameTextField.text != "" && self.passwordTextField.text != "") {
            
            let AuthUrl = Variables.getApiUrl() + "/authenticate";
            let status = Reach().connectionStatus();
            
            switch status {
            case .online(.wwan), .online(.wiFi):
                
                let DatatoSend: Parameters = [
                    "username": self.usernameTextField.text!,
                    "password": self.passwordTextField.text!
                ];
                
                Alamofire.request(AuthUrl, method: .post, parameters: DatatoSend, encoding: JSONEncoding.default).responseJSON { response in
                    
                    if response.result.isSuccess {
                        let data = JSON(data: response.data!);
                        if(data["success"] == true){
                            //save the user and dissmiss the view
                            var SaveObj = [String : String]();
                            
                            SaveObj["token"] = data["token"].stringValue;
                            SaveObj["_id"] = data["user"]["_id"].stringValue;
                            SaveObj["email"] = data["user"]["email"].stringValue;
                            SaveObj["name"] = data["user"]["name"].stringValue;
                            SaveObj["username"] = data["user"]["username"].stringValue;
                            SaveObj["phone"] = data["user"]["phone"].stringValue;
                            SaveObj["rol"] = data["user"]["rol"].stringValue;
                            SaveObj["account_id"] = data["user"]["account_id"].stringValue;

                            self.Save.set(SaveObj, forKey: "UserSession")
                            self.Save.synchronize();
                            
                            self.dismiss(animated: true, completion: nil);
                            
                        }else{
                            self.alerta("Oops!", Mensaje: data["message"].stringValue );
                        }
                    }else{
                        self.alerta("Oops!", Mensaje: (response.result.error?.localizedDescription)!);
                    }
                }
                
            case .unknown, .offline:
                self.alerta("Oops!", Mensaje: "No internet connection.");
            }
            
        }else{
            self.alerta("Oops!", Mensaje: "Empty values.");
        }
    }
    
    @IBAction func doLogin(_ sender: Any) {
        self.login();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.tag == 1) {
            self.login();
        }else{
            self.passwordTextField.becomeFirstResponder();
        }
        return true;
    }
    
    @objc func KeyboardDidShow(){
        self.TopViewConstrait.constant = self.Variables.MaxToTopConstrait;
        UIView.animate(withDuration: 0.7, animations: {
            self.view.layoutIfNeeded()
        })
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func KeyboardDidHidden(){
        self.TopViewConstrait.constant = self.Variables.MinToTopConstrait;
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
        if let recognizers = self.view.gestureRecognizers {
            for recognizer in recognizers {
                self.view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc func DismissKeyboard(){
        usernameTextField.resignFirstResponder();
        passwordTextField.resignFirstResponder();
        self.TopViewConstrait.constant = 0;
    }
    
    //HIDE STATUS BAR:
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool{
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait;
    }
    
    func alerta(_ Titulo:String,Mensaje:String){
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithCloseView(_ Titulo:String,Mensaje:String){
        let alertController = UIAlertController(title: Titulo, message:
            Mensaje, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil);
        }
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    
    //    func isValidEmail(_ testStr:String) -> Bool {
    //        let emailExpression = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    //        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailExpression);
    //        return emailTest.evaluate(with: testStr);
    //    }

}
