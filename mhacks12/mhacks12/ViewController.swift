//
//  ViewController.swift
//  mhacks12
//
//  Created by Eric Zhong on 10/11/19.
//  Copyright © 2019 ericzhong. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var skillsView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var showMenuBtn: UIButton!
    @IBOutlet weak var menu: UIView!
    
    var delegate: ViewControllerDelegate?
    
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
        UIView.animate(withDuration: 0.5, animations: {
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: -500, y: 0)
            t = t.rotated(by: CGFloat.pi / -4)
            // ... add as many as you want, then apply it to to the view
            self.card.transform = t
//            self.card.transform = CGAffineTransform(translationX: -500, y: 0) // TODO: change to length of screen
        }) { (completed) in
            self.card.transform = CGAffineTransform(translationX: 500, y: 0)
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
    
    func showNew(){
        // populate,  add segue to it
        let names = ["Frodo", "Sam", "Wise", "Gamgee", "John", "Sarah", "Jacob", "Melinda"]
        let newValue = names.randomElement()
        print(newValue!)
        nameLabel.text = newValue
        let images = ["https://media.glamour.com/photos/5c41e410b3ec153a69d6cbf9/6:7/w_2309,h_2694,c_limit/GettyImages-902", "https://media.bizj.us/view/img/11292173/bizwomenkendalljenner*320xx2879-4319-103-0.jpg", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqehJus4336hYJ2oJEZvfew_MriOnt1MhBaKf0Wilr2o_5Wf8jCw&s"]
        let chosen_url = images.randomElement()
        let url = URL(string: chosen_url!)
        mainImage.kf.setImage(with: url)
        self.backgroundImage.kf.setImage(with: url)
//        self.sendSubviewToBack(view: self.backgroundImage)

        reset()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.tag = 100
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundImage.addSubview(blurEffectView)
        
        // Skills Population
//        let sView = UIView()
        
        self.skillsView.addArrangedSubview(createSkill(skill: "Python"))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading th
        self.mainImageView.layer.cornerRadius = 30
        self.mainImage.layer.cornerRadius = 30
 
        self.descriptionView.layer.cornerRadius = 35
//        self.mainImage.layer.cornerRadius = 10

        // MARK: Skills View



    }
    
    // MARK: IBActions
    
    @IBAction func siwpeLeft(sender: Any) {
        print("Left")
        
        // move to left
        translate()
        showNew()
        
        
    }
    
    @IBAction func showMenu(_ sender: Any) {
        print("Show menu tapped")
        delegate?.toggleLeftPanel() // only if delegate has a value
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

protocol ViewControllerDelegate {
  func toggleLeftPanel()
  func toggleRightPanel()
  func collapseSidePanels()
}
