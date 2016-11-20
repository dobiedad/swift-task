import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setUserName(string:String){
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        label.center = CGPoint(x: width/2, y: height/2)
        label.textAlignment = .center
        label.text = string
        self.view.addSubview(label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
