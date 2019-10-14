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
import FirebaseUI

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
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
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
    
    let schools = [
        "University of Michigan",
        "University of California, Berkeley",
        "Harvard University",
        "California Institute of Technology"
    ]
    
    let work = [
        "Apple",
        "Microsoft",
        "Google",
        "Uber",
        "Lyft",
        "Facebook",
        "Mcdonalds",
        "Independent"
    ]
    
    let image_array = [
        "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3040042/pexels-photo-3040042.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3045357/pexels-photo-3045357.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3065016/pexels-photo-3065016.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3037589/pexels-photo-3037589.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3046338/pexels-photo-3046338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3045570/pexels-photo-3045570.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/247878/pexels-photo-247878.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3061814/pexels-photo-3061814.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3039467/pexels-photo-3039467.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3037735/pexels-photo-3037735.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/2897883/pexels-photo-2897883.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3037549/pexels-photo-3037549.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3038287/pexels-photo-3038287.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/3047341/pexels-photo-3047341.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://images.pexels.com/photos/937481/pexels-photo-937481.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
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
                        print(json["Bio"].stringValue)
                        if(json["Bio"].stringValue == nil){
                            self.bioLabel.text = "New User"
                        }
                        else {
                            self.bioLabel.text = json["Bio"].stringValue
                        }
                        let chosen_school = self.schools.randomElement()
                        self.schoolLabel.text = "Studied at " + chosen_school!
                        
                        let chosen_work = self.work.randomElement()
                        self.workLabel.text = "Worked at " + chosen_work!
                        
                        var image_name = "person." + json["Data"]["Desired Team Size"].stringValue
                        print(image_name)
                        if(image_name == "person.4"){
                            image_name = "person.3"
                        }
                        
                        self.teamImage.image = UIImage(systemName: image_name)
                        //json["Data"]["Desired Team Size"]
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

        
        
        let chosen_url = self.image_array.randomElement()
        
        self.slideshow.setImageInputs([
            KingfisherSource(urlString: chosen_url!)!
        ])
//        let chosen_url = images.randomElement()
        let url = URL(string: chosen_url!)
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
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 75))
        imageView.contentMode = .scaleAspectFit

        let image = UIImage(#imageLiteral(resourceName: "smaller_logo"))
        imageView.image = image

        navigationItem.titleView = imageView
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated:true);
//        FUIAuth.defaultAuthUI()?.auth?.addStateDidChangeListener { auth, user in
//                  if user != nil {
//                    // User is signed in. Show home screen
//                    print("already signed in")
//                    self.showNew()
//                  } else {
//                    // No User is signed in. Show user the login screen
//                    print("not signed in")
//        //            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        //            self.navigationController?.popToRootViewController(animated: true)
//                    self.view.window?.rootViewController?.presentedViewController?.dismiss(animated: true, completion: nil)
//
//                    print("returned to root")
//
//                  }
//        }
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

extension ViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
    }
}

protocol ViewControllerDelegate {
  func toggleLeftPanel()
  func toggleRightPanel()
  func collapseSidePanels()
}
