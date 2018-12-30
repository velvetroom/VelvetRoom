import UIKit

class EditView:ItemView, UITextViewDelegate {
    private(set) weak var text:TextView!
    private weak var dragGesture:UIPanGestureRecognizer!
    private weak var longGesture:UILongPressGestureRecognizer!
    private var dragX:CGFloat!
    private var dragY:CGFloat!
    
    override init() {
        super.init()
        layer.cornerRadius = 6
        
        let dragGesture = UIPanGestureRecognizer(target:self, action:#selector(drag(_:)))
        addGestureRecognizer(dragGesture)
        self.dragGesture = dragGesture
        
        let longGesture = UILongPressGestureRecognizer(target:self, action:#selector(long(_:)))
        longGesture.minimumPressDuration = 1
        addGestureRecognizer(longGesture)
        self.longGesture = longGesture
        
        let text = TextView()
        text.delegate = self
        addSubview(text)
        self.text = text
        
        text.topAnchor.constraint(equalTo:topAnchor, constant:10).isActive = true
        text.bottomAnchor.constraint(equalTo:bottomAnchor, constant:-10).isActive = true
        text.rightAnchor.constraint(equalTo:rightAnchor, constant:-10).isActive = true
        text.leftAnchor.constraint(equalTo:leftAnchor, constant:14).isActive = true
        text.widthAnchor.constraint(lessThanOrEqualToConstant:250).isActive = true
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
//    override func mouseDown(with event:NSEvent) {
//        if event.clickCount == 2 {
//            beginEditing()
//        }
//    }
//
//    override func mouseDragged(with event:NSEvent) {
//        if !text.isEditable {
//            if dragging {
//                drag(deltaX:event.deltaX, deltaY:event.deltaY)
//                NSCursor.pointingHand.set()
//            } else {
//                dragging = true
//                Application.shared.view.makeFirstResponder(nil)
//            }
//        }
//    }
//
//    override func mouseUp(with:NSEvent) {
//        if dragging {
//            dragging = false
//        }
//    }
    
    func textViewDidChange(_:UITextView) {
        Application.view.canvasChanged(0)
    }
    
    func textViewDidEndEditing(_ textView:UITextView) {
        dragGesture.isEnabled = true
        text.isUserInteractionEnabled = false
        Application.view.canvasChanged()
        Application.view.scheduleUpdate()
    }
    
    func beginEditing() {
        dragGesture.isEnabled = false
        text.isUserInteractionEnabled = true
        text.becomeFirstResponder()
    }
    
    func beginDrag() {
        UIApplication.shared.keyWindow!.endEditing(true)
        dragX = 0
        dragY = 0
        longGesture.isEnabled = false
        superview!.bringSubviewToFront(self)
        backgroundColor = .velvetShade
    }
    
    func endDrag() {
        longGesture.isEnabled = true
        backgroundColor = .clear
    }
    
    func drag(deltaX:CGFloat, deltaY:CGFloat) {
        left.constant += deltaX
        top.constant += deltaY
    }
    
    @objc private func drag(_ gesture:UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: beginDrag()
        case .cancelled, .ended, .failed: endDrag()
        case .possible, .changed:
            let point = gesture.translation(in:superview)
            drag(deltaX:point.x - dragX, deltaY:point.y - dragY)
            dragX = point.x
            dragY = point.y
            
        }
    }
    
    @objc private func long(_ gesture:UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        beginEditing()
    }
}
