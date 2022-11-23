//
//  ViewController.swift
//  Messanger
//
//  Created by mobin on 10/3/22.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth() 
    }

    
    func validateAuth(){
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController ()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle
            = .fullScreen
            present(nav, animated: true)
        }
    }

}

