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

class RightViewController: UIViewController {
//    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var likesView: UIStackView!
    @IBOutlet weak var matchesView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadData()
        loadMatches()
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
    
    func createMatchCell(user1: String, user2: String) -> (UIStackView){
        let stackView  = UIStackView()
        
        let borderColor = UIColor(red: 85.0/255.0, green: 214.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        
        // API call to get data for user1
        
        // API call to get data for user2
        
        // placeholder for img for user1
        let imageStackView = UIStackView()
        imageStackView.axis  = NSLayoutConstraint.Axis.horizontal
        imageStackView.distribution  = UIStackView.Distribution.equalSpacing
        imageStackView.alignment = UIStackView.Alignment.center
        imageStackView.spacing   = 5.0

        let image1 = UIImageView()
        image1.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        image1.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        image1.layer.cornerRadius = image1.frame.size.height / 2

        let url = URL(string: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")
        image1.kf.setImage(with: url)
        
        let image2 = UIImageView()
        image2.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        image2.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        image2.layer.cornerRadius = image2.frame.size.height / 2
        image2.layer.masksToBounds = true
        image2.layer.borderWidth = 0
        image2.contentMode = UIView.ContentMode.scaleAspectFill
        
//        UIViewContentModeScaleAspectFill
        let url2 = URL(string: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")
        image2.kf.setImage(with: url2)
        
        imageStackView.addArrangedSubview(image1)
        imageStackView.addArrangedSubview(image2)
        
        let name1 = UILabel()
        name1.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        name1.text  = "Lina" // name of user 1 goes here
        name1.textAlignment = .center
        
        let name2 = UILabel()
        name2.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        name2.text  = "You" // name of user 2 goes here
        name2.textAlignment = .center
        
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
        stackView.addArrangedSubview(imageStackView)
        stackView.addArrangedSubview(name1)
        stackView.addArrangedSubview(name2)
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
        
        let data = [["32","2"],["2","37"]] // each array is uuid, uuid of match
        for match in data{
            print(match)
            // pull data for both uuids
            var cell = self.createMatchCell(user1: match[0], user2: match[1])
            matchesView.addSubview(cell)

        }
    }
    

}

