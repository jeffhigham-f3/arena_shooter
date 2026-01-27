import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    
    // Set window properties for game
    self.title = "Game1"
    self.setContentSize(NSSize(width: 900, height: 700))
    self.center()
    self.styleMask.insert(.resizable)
    self.minSize = NSSize(width: 400, height: 300)
  }
}
