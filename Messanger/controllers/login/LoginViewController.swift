//
//  LoginViewController.swift
//  Messanger
//
//  Created by mobin on 10/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FacebookLogin

class LoginViewController: UIViewController  {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        <#code#>
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        <#code#>
    }
    
    let userDefault_login = UserDefaults.standard
    private let imageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @objc private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.backgroundColor = .link
        button.layer.cornerRadius = 12
        button.layer.fillMode = .both
        button.layer.masksToBounds = true
        
       
        return button
    }()
    private let facebookLoginButton = FBLoginButton()

    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocorrectionType =  .no
        emailField.autocapitalizationType = .none
        emailField.returnKeyType = .continue
        emailField.textColor = .black
        emailField.backgroundColor = .white
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        emailField.leftViewMode = .always
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        emailField.layer.borderColor = UIColor.black.cgColor
        emailField.placeholder = "email"
        return emailField
        
    }()
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocorrectionType =  .no
        passwordField.autocapitalizationType = .none
        passwordField.returnKeyType = .continue
        passwordField.textColor = .black
        passwordField.backgroundColor = .white
        passwordField.layer.cornerRadius = 12
        passwordField.layer.borderWidth = 1
        passwordField.isSecureTextEntry = true 
        passwordField.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        passwordField.leftViewMode = .always
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.placeholder = "password"
        return passwordField
        
    }()
    
    private let scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.contentMode = .scaleAspectFit
        scrollView.clipsToBounds = true

        return scrollView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapRegister))
       
        
        view.backgroundColor = .white
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(facebookLoginButton)
        facebookLoginButton.layer.cornerRadius = 12
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.delegate = self
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        passwordField.delegate = self
        emailField.delegate = self
        
    
           loginButton.center = view.center
           scrollView.addSubview(loginButton)
        
        

    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2   ,
                                 y: 30,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: 30,
                                  y: imageView.buttom + 10,
                                  width: scrollView.width - 80,
                                  height: 40)
    
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.buttom + 10,
                                  width: scrollView.width - 80,
                                  height: 40)
        
        loginButton.frame = CGRect(x: (scrollView.width - size ) / 3 ,
                                   y: passwordField.buttom + 20,
                                   width:( scrollView.width)/2 ,
                                   height: 40)
       
        facebookLoginButton.frame = CGRect(x: (scrollView.width - size ) / 3 ,
                                           y: loginButton.buttom + 10,
                                           width:( scrollView.width)/2  ,
                                           height: 40)
        
    }
    
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        
       

        Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            
            guard let result = authResult , error == nil else {
                print(error)
                return
                
            }
            
            
            if let user = authResult?.user {
                print("loggin with this userName :\(user.uid)")
                self!.userDefault_login.set(true, forKey: "logged_in")

            }
            self!.userDefault_login.set(false, forKey: "logged_in")
            
            
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }

        
    }
    
    func alertUserLoginError(message : String  = "Kos nanae sarina "){
        let alert = UIAlertController(title: "We have problem",
                                      message: "Please enter all information to log in"
                                      , preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
        
    }
    
    
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Creat Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
            
        }else if textField == passwordField {
            loginButtonTapped()
        }
        return true
    }
}


extension LoginViewController: LoginButtonDelegate {
    
    
}

