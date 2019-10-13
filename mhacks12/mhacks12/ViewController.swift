//
//  ViewController.swift
//  mhacks12
//
//  Created by Eric Zhong on 10/11/19.
//  Copyright © 2019 ericzhong. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow
import FirebaseDatabase
import Alamofire
import Firebase
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
//    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var skillsView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var showMenuBtn: UIButton!
    @IBOutlet weak var menu: UIView!
    
    var delegate: ViewControllerDelegate?
    
    var ref: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var prospective = ""

    var languagesRef = [
        "1": "C++",
        "2": "Python",
        "3": "JS",
        "4": "React",
        "5": "Ruby",
        "6": "HTML/CSS",
        "7": "C#",
        "8": "Swift",
        "9": "Java",
        "10": "PHP"
    ]

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
    
    func translate(){
        let offset = CGFloat(self.view.frame.width)
        UIView.animate(withDuration: 0.25, animations: {
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: -offset, y: 0)
//            t = t.rotated(by: CGFloat.pi / -4)
            // ... add as many as you want, then apply it to to the view
            self.card.transform = t
//            self.card.transform = CGAffineTransform(translationX: -500, y: 0) // TODO: change to length of screen
        }) { (completed) in
            self.card.transform = CGAffineTransform(translationX: offset, y: 0)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                self.card.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
        }
    }
    
    func translateRight(){
        let offset = CGFloat(self.view.frame.width)
            UIView.animate(withDuration: 0.25, animations: {
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: offset, y: 0)
//                t = t.rotated(by: CGFloat.pi / 4)
                // ... add as many as you want, then apply it to to the view
                self.card.transform = t
    //            self.card.transform = CGAffineTransform(translationX: -500, y: 0) // TODO: change to length of screen
            }) { (completed) in
                self.card.transform = CGAffineTransform(translationX: -offset, y: 0)
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                    self.card.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            }
        }
    
    func reset(){
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No blur view to remove")
        }
//        self.skillsView.removeArrangedSubview(<#T##view: UIView##UIView#>)
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
    
    // MARK: API Calls
    
    func getProfile(userID: String) -> NSDictionary {
        let parameters: [String: String] = [
            "UID":userID
        ]
        var place_holder_dict = NSDictionary()
        AF.request("http://3.92.77.227/get_profile", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                                .responseJSON { response in
        //                            print(response)
                    //to get status code
        //                            if let status = response.response?.statusCode {
        //                                switch(status){
        //                                case 201:
        //                                    print("example success")
        //                                default:
        //                                    print("error with response status: \(status)")
        //                                }
        //                            }
                    //to get JSON return value
                    if let result = response.value {
//                        let JSON = result as! NSDictionary
//                        print(JSON)
                        let json = JSON(result as! NSDictionary)

                        print(json["Data"]["Name"])
                        self.nameLabel.text = json["Data"]["Name"].stringValue
                        self.bioLabel.text = json["Data"]["Bio"].stringValue
//                        place_holder_dict = JSON
                        
                        if(self.skillsView.arrangedSubviews.count > 1){
                            for _ in 0...2 {
                                print(self.skillsView.arrangedSubviews)
                                self.skillsView.arrangedSubviews[0].removeFromSuperview()
                            }
                        }
                        
                        for x in 0...2 {
//                            print(json["Data"]["Languages"][x])
                            var skill = self.languagesRef[json["Data"]["Languages"][x].stringValue]
                            self.skillsView.addArrangedSubview(self.createSkill(skill: skill ?? "Code"))
//                            self.skillsView.tag = 101

                        }
                        

                }
        }
        return place_holder_dict
    }
    
    func swipeNo(userID: String) -> NSDictionary {
            let parameters: [String: String] = [
                "UID":userID
            ]
            var place_holder_dict = NSDictionary()
            AF.request("http://3.92.77.227/swipe_no", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in

                        //to get JSON return value
                        if let result = response.value {
    //                        let JSON = result as! NSDictionary
    //                        print(JSON)
                            let json = JSON(result as! NSDictionary)

                            print(json["Status"])
                    }
            }
            return place_holder_dict
        }
    
    func swipeYes(swiper: String, swiped: String) -> NSDictionary {
            let parameters: [String: String] = [
                "Swiper":swiper,
                "Swiped":swiped
            ]
            var place_holder_dict = NSDictionary()
            AF.request("http://3.92.77.227/swipe_yes", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                        .responseJSON { response in

                        //to get JSON return value
                        if let result = response.value {
    //                        let JSON = result as! NSDictionary
    //                        print(JSON)
                            let json = JSON(result as! NSDictionary)

                            print(json["Status"])
                    }
            }
            return place_holder_dict
        }
    
    func showNew(){
        // populate,  add segue to it
        ref = Database.database().reference()
        
        print(self.userID!)
        ref.child("UserBase").child(self.userID!).child("Actions").child("Current Queue").observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
//            print(snapshot.value)
            let value = snapshot.value as? [String]
//                let current_queue = value as? [String]
            
            print(value![0]) // TODO: add error handling bc queue can hit 0
            self.prospective = value![0]
            
            // call get_profile endpoint to geet all data on that user
            var profile_data = self.getProfile(userID: value![0])
//            print(profile_data)
//            print(profile_data["Data"])
//            print(profile_data["Name"] as? String)
            
            
            
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }

        
        let names = ["Frodo", "Sam", "Wise", "Gamgee", "John", "Sarah", "Jacob", "Melinda"]
        let newValue = names.randomElement()
        print(newValue!)
        nameLabel.text = newValue
//        print(self.slideshow)
        self.slideshow.setImageInputs([
          KingfisherSource(urlString: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")!,
          KingfisherSource(urlString: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")!,
          KingfisherSource(urlString: "https://media.bizj.us/view/img/11292173/bizwomenkendalljenner*320xx2879-4319-103-0.jpg")!,
          KingfisherSource(urlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqehJus4336hYJ2oJEZvfew_MriOnt1MhBaKf0Wilr2o_5Wf8jCw&s")!
        ])
//        let chosen_url = images.randomElement()
        let url = URL(string: "https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902")
//        mainImage.kf.setImage(with: url)
        self.backgroundImage.kf.setImage(with: url)
//        self.sendSubviewToBack(view: self.backgroundImage)

        reset()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 100
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImage.addSubview(blurEffectView)
        
        // Skills Population
//        let sView = UIView()
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading th
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        
        self.slideshow.layer.cornerRadius = 30
//        self.mainImage.layer.cornerRadius = 30
 
        self.descriptionView.layer.cornerRadius = 35
        self.card.layer.cornerRadius = 25
//        self.mainImage.layer.cornerRadius = 10
        
        // MARK: Slideshow
        
        self.slideshow.slideshowInterval = 5.0
        self.slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        self.slideshow.pageIndicator = pageControl

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        self.slideshow.activityIndicator = DefaultActivityIndicator()
        self.slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
//        slideshow.setImageInputs(localSource)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        self.slideshow.addGestureRecognizer(recognizer)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    // MARK: IBActions
    @IBAction func swipeLeft(_ sender: Any) {
        print("Left")
               
        // move to left
        translate()
        showNew()
        swipeNo(userID: self.userID!)
    }

    @IBAction func swipeRight(_ sender: Any) {
        print("Right")
        
        // move to left
        translateRight()
        showNew()
        swipeYes(swiper: self.userID!, swiped: self.prospective)
        
    }
    @IBAction func showMenu(_ sender: Any) {
        print("Show menu tapped")
//        delegate?.toggleLeftPanel() // only if delegate has a value
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}

extension ViewController: SidePanelViewControllerDelegate {
  func didSelectAnimal(_ animal: Animal) {
//    imageView.image = animal.image
//    titleLabel.text = animal.title
//    creatorLabel.text = animal.creator
//
    delegate?.collapseSidePanels()
  }
}

extension ViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
    }
}

protocol ViewControllerDelegate {
  func toggleLeftPanel()
  func toggleRightPanel()
  func collapseSidePanels()
}
