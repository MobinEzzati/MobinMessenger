//
//  RegisterViewController.swift
//  Messanger
//
//  Created by mobin on 10/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    private let imageView: UIImageView =  {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.circle")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.lightGray.cgColor 
        
        return image
    }()
    
    @objc private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("register", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.layer.fillMode = .both
        button.layer.masksToBounds = true
        
       
        return button
    }()
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocorrectionType =  .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.textColor = .black
        field.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "FirstName"
        return field
        
    }()

    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType =  .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.textColor = .black
        field.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        field.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "Email"
        return field
        
    }()
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocorrectionType =  .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.isSecureTextEntry = true
        field.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 20))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.layer.borderColor = UIColor.black.cgColor
        field.attributedPlaceholder = NSAttributedString(string: "Placeholder Text", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        field.layer.borderColor = UIColor.black.cgColor
        field.placeholder = "password"
        
        return field
        
    }()
    
    private let scrollView: UIScrollView  = {
        let scrollView = UIScrollView()
        scrollView.contentMode = .scaleAspectFit
        scrollView.clipsToBounds = true

        return scrollView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
    
        view.backgroundColor = .white
//        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
//        navigationController?.navigationBar.titleTextAttributes = textAttributes
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
//                                                            style: .plain,
//                                                            target: self,
//                                                            action: #selector(didTapRegister))
            
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(registerButton)
        registerButton.addTarget(self,
                              action: #selector(registerButtonTapped),
                              for: .touchUpInside)
        passwordField.delegate = self
        emailField.delegate = self
        
        scrollView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        
     presentActionSheet()
    }
        
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 4
        
        imageView.frame = CGRect(x: (scrollView.width - size) / 2   ,
                                 y: 30,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width / 2.0
        
        firstNameField.frame = CGRect(x: 30,
                                 y: imageView.buttom + 20,
                                 width: scrollView.width - 80,
                                 height: 40)
        
        emailField.frame = CGRect(x: 30,
                                  y: firstNameField.buttom + 10,
                                  width: scrollView.width - 80,
                                  height: 40)
        
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.buttom + 10,
                                  width: scrollView.width - 80,
                                  height: 40)
        
        registerButton.frame = CGRect(x: (scrollView.width - size ) / 2.7 , y: passwordField.buttom + 20, width:( scrollView.width - 80)/2 , height: 40)
    }
    
    @objc private func registerButtonTapped(){
        
        guard let email = emailField.text,
              let firstName = firstNameField.text,
                let password = passwordField.text,
                !email.isEmpty,
                !password.isEmpty,
               !firstName.isEmpty,
                password.count >= 6 else {
            alertUserLoginError()
            return
        }
 
        DatabaseManager.db.userExists( with: email
        ) {[weak self] exists in
            guard let strongSelf = self else {
                return
            }

            guard !exists else {
                strongSelf.alertUserLoginError(message: "looks like that we have this Email already exists")
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { [weak self ]result, error in
                guard let strongSelf = self else {
                    return 
                }
                guard let authResult = result , error == nil else {
                    print("message:\(error)")
                    print("password:\(result?.description)")
                    return
                }
                DatabaseManager.db.insertUser(user: ChatAppUserModel(firstName: firstName, lastName: password, emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
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


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
            
        }else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
    
}


extension RegisterViewController : UIImagePickerControllerDelegate {
    
    func presentActionSheet(){
        
        let actinSheet = UIAlertController(title: "Profile Picture",
                                           message: "how would like to see",
                                           preferredStyle: .actionSheet)
        actinSheet.addAction(UIAlertAction(title: "Cancel",
                                           style: .cancel,
                                           handler: nil ))
        actinSheet.addAction(UIAlertAction(title: "Take Photo",
                                           style: .default,
                                           handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actinSheet.addAction(UIAlertAction(title: "Choose Photo",
                                           style: .destructive,
                                           handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        
        present(actinSheet, animated: true)
    }
    
    func presentCamera(){
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard  let pickImage = info[UIImagePickerController.InfoKey.originalImage] else {
            return
        }
        self.imageView.image = pickImage as? UIImage
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
}
    
