import UIKit

@IBDesignable class RatingControl: UIStackView {
    //Mark: initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    
    //var
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updatedButtonSelectionState()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 30.0, height: 30.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    private func setupButtons() {
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        
        updatedButtonSelectionState()
    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else {
                fatalError("")
        }
        let selectedRating = index+1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    private func updatedButtonSelectionState() {
        for(index, button)  in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
   
}
