//
//  ProfileViewController.swift
//  Messanger
//
//  Created by mobin on 11/10/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet var tableView : UITableView!
    let data = ["logOut"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text  = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "log out",
                                      style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do{
                
                try Auth.auth().signOut()
                
                let vc = LoginViewController ()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle
                = .fullScreen
                strongSelf.present(nav, animated: true)
                
            }catch{
                print("failed to logout")
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil
                                     ))
        
        present(alert, animated: true, completion: nil)
        

    }
}
