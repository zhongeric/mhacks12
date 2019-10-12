import UIKit

class AnimalCell: UITableViewCell {
  @IBOutlet weak var animalImageView: UIImageView!
  @IBOutlet weak var imageNameLabel: UILabel!
  @IBOutlet weak var imageCreatorLabel: UILabel!
  
  func configureForAnimal(_ animal: Animal) {
    animalImageView.image = animal.image
    imageNameLabel.text = animal.title
    imageCreatorLabel.text = animal.creator
  }
}
