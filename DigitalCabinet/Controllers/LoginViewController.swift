//
//  ViewController.swift
//  DigitalCabinet
//
//  Created by admin on 15.04.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accentColorBackground: UILabel!
    
    @IBOutlet weak var leftAccentColorBackground: UILabel!
    
    @IBOutlet weak var shapeLabel: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBOutlet weak var frontView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTxt.text, let password = passTxt.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = e.localizedDescription
                } else{
                    self.performSegue(withIdentifier: K.Segues.loginSegue, sender: self)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = true
        errorLbl.isHidden = true
        shapeLabel.setCorners(corner1: .layerMaxXMinYCorner, corner2: .layerMaxXMaxYCorner, radius: 50)
        frontLabel.setCorners(corner1: .layerMinXMaxYCorner, corner2: .layerMinXMinYCorner,radius: 50)
        
        loginBtn.setCorners(radius: 27)
        
        emailTxt.setPlaceholder(name: "    Email")
        passTxt.setPlaceholder(name: "    Password")
        
        passTxt.setCorners(radius: 27)
        emailTxt.setCorners(radius: 27)
        
        accentColorBackground.setCorners(corner1: .layerMinXMaxYCorner, corner2: .layerMinXMinYCorner, radius: 50)
        leftAccentColorBackground.setCorners(corner1: .layerMaxXMinYCorner, corner2: .layerMaxXMaxYCorner, radius: 50)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

extension UITextField {

    func useUnderline(){
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setPlaceholder(name: String){
        self.attributedPlaceholder = NSAttributedString(
            string: name,
            attributes: [
                .foregroundColor: #colorLiteral(red: 0.6039215686, green: 0.5058823529, blue: 0.4549019608, alpha: 1),
                .font: UIFont.systemFont(ofSize: 15.0)
            ]
        )
    }
}

extension UIView {
    
    func setCorners(corner1: CACornerMask, corner2: CACornerMask, radius: CGFloat ){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.maskedCorners =  [corner1, corner2]
        
    }
    
    func setCorners(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 20.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.masksToBounds = false
        
    }
}
