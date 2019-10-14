//
//  LeftViewController.swift
//  mhacks12
//
//  Created by Eric Zhong on 10/12/19.
//  Copyright © 2019 ericzhong. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseAuth
import Firebase
import Alamofire
import SwiftyJSON

class LeftViewController: UIViewController {
//    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var skillsView: UIStackView!
    @IBOutlet weak var bioField: UITextView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    
//    func makeRequest(endpoint: String, data: [String: String]) -> NSDictionary {
//        AF.request("http://3.92.77.227/" + endpoint, method: .post, parameters: data, encoder: JSONParameterEncoder.default).responseJSON { response in
//                print("Response JSON: \(response.value)")
//                return response.value
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
//        let userID = Auth.auth().currentUser?.uid
//        if(userID != nil) { // user is signed in
//            print("user id is")
//            print(userID!)
//            let parameters: [String: String] = [
//                "UID":userID!
//            ]
//
//            AF.request("http://3.92.77.227/get_profile", method: .post, parameters: parameters, encoding: JSONEncoding.default)
//                        .responseJSON { response in
////                            print(response)
//            //to get status code
////                            if let status = response.response?.statusCode {
////                                switch(status){
////                                case 201:
////                                    print("example success")
////                                default:
////                                    print("error with response status: \(status)")
////                                }
////                            }
//            //to get JSON return value
//                        if let result = response.value {
//                            let json = JSON(result as! NSDictionary)
//                            print(json)
//                            self.nameLabel.text = json["Data"]["Name"].stringValue
//                        }
//                }
//        }
//        else {
//            // kick back to login
//        }
    }
    
    // MARK: Helper functions
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func createSkill(skill: String) -> (UILabel){
        // skill and corresponding color fetched from database
        let borderColor = UIColor(red: 85.0/255.0, green: 214.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        let skillLabel = UILabel()
        skillLabel.backgroundColor =  hexStringToUIColor(hex: "#F9F4FA")
        skillLabel.textColor = hexStringToUIColor(hex: "2D3142")
        skillLabel.layer.borderColor = borderColor.cgColor
        skillLabel.layer.borderWidth = 3.0
        skillLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        skillLabel.text  = skill
        skillLabel.layer.masksToBounds = true
        skillLabel.layer.cornerRadius = 20
        skillLabel.textAlignment = .center
        return skillLabel
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func loadData(){
//        avatarImage.layer.borderWidth = 1
//        avatarImage.layer.masksToBounds = false
//        avatarImage.layer.borderColor = UIColor.black.cgColor
//        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
//        avatarImage.clipsToBounds = true
        
        // MARK: Avatar Image
        // TODO: get current UID from firebase auth, request all data from server
        let url = URL(string: "https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=900&q=60")
        self.avatarImage.kf.setImage(with: url)
        self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height / 2
        
        let skills = ["Python", "C++", "Javascript", "React", "Ruby", "HTML/CSS", "C#", "Swift", "Java", "PHP"]
        for _ in 1...4 {
            self.skillsView.addArrangedSubview(createSkill(skill: skills.randomElement() ?? "Code"))
            
        }

    }
}

