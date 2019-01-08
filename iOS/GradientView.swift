import UIKit

class GradientView:UIView {
    override class var layerClass:AnyClass { return CAGradientLayer.self }
    
    init() {
        super.init(frame:.zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        (layer as! CAGradientLayer).startPoint = CGPoint(x:0.5, y:0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x:0.5, y:1)
        (layer as! CAGradientLayer).locations = [0, 1]
        (layer as! CAGradientLayer).colors = [UIColor(white:0, alpha:0.95).cgColor, UIColor.clear.cgColor]
    }
    
    required init?(coder:NSCoder) { return nil }
}
