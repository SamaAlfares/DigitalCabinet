//
//  RegisterViewController.swift
//  DigitalCabinet
//
//  Created by admin on 16.04.2023.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var rightBackroundView: UIView!
    
    @IBOutlet weak var rightBackground: UILabel!
    
    @IBOutlet weak var rightAccentColorBackground: UILabel!
    
    @IBOutlet weak var AccentColorBackground: UILabel!
    
    @IBOutlet weak var registerbackground: UILabel!
    
    @IBOutlet weak var registerBackgroundView: UIView!
    
    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    @IBOutlet weak var signupBtn: UIButton!

    @IBOutlet weak var errorLbl: UILabel!
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        if let username = userNameTxt.text, let email = emailTxt.text, let password = passTxt.text { Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = e.localizedDescription
                } else {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges { error in
                        if let e = error{
                            print(e.localizedDescription)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLbl.isHidden = true
        
        rightBackground.setCorners(corner1: .layerMinXMaxYCorner, corner2: .layerMinXMinYCorner, radius: 50)
        //rightBackroundView.setShadow()
        registerbackground.setCorners(corner1: .layerMaxXMinYCorner, corner2: .layerMaxXMaxYCorner, radius: 50)
        //registerBackgroundView.setShadow()
        AccentColorBackground.setCorners(corner1: .layerMaxXMinYCorner, corner2: .layerMaxXMaxYCorner, radius: 50)
        rightAccentColorBackground.setCorners(corner1: .layerMinXMaxYCorner, corner2: .layerMinXMinYCorner, radius: 50)
        userNameTxt.setCorners(radius: 27)
        emailTxt.setCorners(radius: 27)
        passTxt.setCorners(radius: 27)
        signupBtn.setCorners(radius: 27)
        emailTxt.setPlaceholder(name: "    Email")
        userNameTxt.setPlaceholder(name: "   Username")
        passTxt.setPlaceholder(name: "    Password")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
