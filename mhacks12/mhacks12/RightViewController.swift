//
//  RightViewController.swift
//  
//
//  Created by Eric Zhong on 10/12/19.
//
import Foundation
import UIKit
import Kingfisher
import FirebaseAuth
import Firebase
import Alamofire
import SwiftyJSON

class RightViewController: UIViewController {
//    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var likesView: UIStackView!
    @IBOutlet weak var matchesView: UIStackView!
    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var lastMatch: UIImageView!
    @IBOutlet weak var unknownMatch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadData()
        loadMatches()
    }
    
    var swipes = NSDictionary() // [String]()
    var matches = [Any]()
    
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
    
    func createMatchCell(user1: String) -> (UIStackView){
        let stackView  = UIStackView()
        
        let borderColor = UIColor(red: 85.0/255.0, green: 214.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        
        // API call to get data for user1
        let parameters: [String: String] = [
            "UID":user1
        ]
        
        // API call to get data for user2
        
        // placeholder for img for user1
        let image1 = UIImageView()
        image1.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        image1.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        image1.layer.cornerRadius = image1.frame.size.height / 2

        let url = URL(string: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")
        image1.kf.setImage(with: url)
    
        let name1 = UILabel()
        name1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//        name1.text  = "Lina" // name of user 1 goes here
        name1.textAlignment = .center
        
        AF.request("http://3.92.77.227/get_profile", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                        .responseJSON { response in

                            if let result = response.value {
        //                        let JSON = result as! NSDictionary
        //                        print(JSON)
                                let json = JSON(result as! NSDictionary)

                                print(json["Data"]["Name"])
                                name1.text = json["Data"]["Name"].stringValue
        //                        place_holder_dict = JSON
                        
                                

                        }
                }
        
        let messageBtn = UIButton()
        messageBtn.titleLabel?.text = "Message"
        messageBtn.layer.cornerRadius = 35
        messageBtn.titleLabel?.textColor = hexStringToUIColor(hex: "2D3142")
        messageBtn.layer.borderColor = borderColor.cgColor
        messageBtn.layer.borderWidth = 3.0
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(image1)
        stackView.addArrangedSubview(name1)
        stackView.addArrangedSubview(messageBtn)

        return stackView
    }
    
    func createLikeCell(user: String) -> (UIStackView){
        let stackView = UIStackView()
        return stackView
    }
    
    func loadLikes(){
        // load all matches and populate vertical stack
        
        // initialize view with horizontal stack inside with two images
        // loop through this view to populate
        
        let data = ["45","78","92"] // with uuids of people you have liked
        
        for user in data{
            print(user)
            // pull data for both uuids
            var cell = self.createLikeCell(user: user)
            matchesView.addSubview(cell)

        }
    }
    
    func loadMatches(){
        // load all matches and populate vertical stack
        
        // initialize view with horizontal stack inside with two images
        // loop through this view to populate
        let userID = Auth.auth().currentUser?.uid
                let parameters: [String: String] = [
                    "UID":userID!
                ]
                AF.request("http://3.92.77.227/get_profile", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                        .responseJSON { response in

                                        if let result = response.value {
                                            let json = JSON(result as! NSDictionary)
                                            print(json)
                                            if(json["Actions"]["Matches"].count > 0){
                                                for match in json["Actions"]["Matches"] {
                                                    print(match.1)
                                                    var user = match.1.stringValue

                                                    // For reference
                                                    self.matches.append(match)
                                                    var cell = self.createMatchCell(user1: user)
                                                    let url = URL(string: "https://images.unsplash.com/photo-1528892952291-009c663ce843?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=900&q=60")
                                                    self.lastMatch.kf.setImage(with: url)
                                                    self.lastMatch.layer.cornerRadius = self.lastMatch.frame.size.height / 2
                                                    self.matchesView.addSubview(cell)

                                                }
                                            }
        //                                    self.matches = json["Actions"]["Matches"]
        //                                    self.matches = json["Actions"]["Matches"]

                                        }
        }
    }
    

}

