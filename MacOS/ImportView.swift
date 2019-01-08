import AppKit
import VelvetRoom

class ImportView:SheetView {
    private weak var drop:DropView!
    private weak var image:NSImageView!
    private weak var openButton:NSButton!
    private weak var message:NSTextField!
    
    override init() {
        super.init()
        
        let done = NSButton()
        done.target = self
        done.action = #selector(self.end)
        done.image = NSImage(named:"delete")
        done.imageScaling = .scaleNone
        done.translatesAutoresizingMaskIntoConstraints = false
        done.isBordered = false
        done.font = .systemFont(ofSize:16, weight:.bold)
        done.keyEquivalent = "\u{1b}"
        contentView!.addSubview(done)
        
        let mutable = NSMutableAttributedString()
        mutable.append(NSAttributedString(string:.local("ImportView.title"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.bold), .foregroundColor:NSColor.velvetBlue]))
        mutable.append(NSAttributedString(string:.local("ImportView.description"), attributes:
            [.font:NSFont.systemFont(ofSize:16, weight:.ultraLight), .foregroundColor:NSColor.white]))
        
        let title = NSTextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.backgroundColor = .clear
        title.isBezeled = false
        title.isEditable = false
        title.attributedStringValue = mutable
        contentView!.addSubview(title)
        
        let message = NSTextField()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.backgroundColor = .clear
        message.isBezeled = false
        message.isEditable = false
        message.font = .systemFont(ofSize:20, weight:.regular)
        message.textColor = .white
        message.alignment = .center
        contentView!.addSubview(message)
        self.message = message
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        image.image = NSImage(named:"dropOff")
        contentView!.addSubview(image)
        self.image = image
        
        let drop = DropView(image)
        drop.selected = selected
        contentView!.addSubview(drop)
        self.drop = drop
        
        let openButton = NSButton()
        openButton.image = NSImage(named:"button")
        openButton.target = self
        openButton.action = #selector(open)
        openButton.setButtonType(.momentaryChange)
        openButton.imageScaling = .scaleNone
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.isBordered = false
        openButton.attributedTitle = NSAttributedString(string:.local("ImportView.open"), attributes:
            [.font:NSFont.systemFont(ofSize:15, weight:.medium), .foregroundColor:NSColor.black])
        openButton.keyEquivalent = "\r"
        contentView!.addSubview(openButton)
        self.openButton = openButton
        
        drop.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        drop.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        drop.widthAnchor.constraint(equalToConstant:120).isActive = true
        drop.heightAnchor.constraint(equalToConstant:120).isActive = true
        
        image.topAnchor.constraint(equalTo:drop.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo:drop.bottomAnchor).isActive = true
        image.leftAnchor.constraint(equalTo:drop.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo:drop.rightAnchor).isActive = true
        
        message.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        message.centerYAnchor.constraint(equalTo:contentView!.centerYAnchor).isActive = true
        
        done.topAnchor.constraint(equalTo:contentView!.topAnchor, constant:20).isActive = true
        done.leftAnchor.constraint(equalTo:contentView!.leftAnchor, constant:20).isActive = true
        done.widthAnchor.constraint(equalToConstant:24).isActive = true
        done.heightAnchor.constraint(equalToConstant:18).isActive = true
        
        title.leftAnchor.constraint(equalTo:done.rightAnchor, constant:10).isActive = true
        title.topAnchor.constraint(equalTo:done.topAnchor).isActive = true
        
        openButton.centerXAnchor.constraint(equalTo:contentView!.centerXAnchor).isActive = true
        openButton.bottomAnchor.constraint(equalTo:contentView!.bottomAnchor, constant:-20).isActive = true
        openButton.widthAnchor.constraint(equalToConstant:92).isActive = true
        openButton.heightAnchor.constraint(equalToConstant:34).isActive = true
    }
    
    private func selected(_ url:URL) {
        image.isHidden = true
        openButton.isHidden = true
        drop.isHidden = true
        if let image = NSImage(byReferencing:url).cgImage(forProposedRect:nil, context:nil, hints:nil),
            let id = try? Sharer.load(image) {
            
            end()
        } else {
            message.stringValue = .local("ImportView.error")
        }
    }
    
    @objc private func open() {
        let browser = NSOpenPanel()
        browser.message = .local("ImportView.qr")
        browser.allowedFileTypes = ["png"]
        browser.begin { [weak self] result in
            if result == .OK {
                self?.selected(browser.url!)
            }
        }
    }
}