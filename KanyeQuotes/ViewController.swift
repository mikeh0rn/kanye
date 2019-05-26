//
//  ViewController.swift
//  KanyeQuotes
//
//  Created by Michael Horn on 5/10/19.
//  Copyright © 2019 Mike Horn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Branch


class ViewController: UIViewController {
    
    private var kanyeQuote = ""
    
    @IBOutlet weak var kanyeQuoteLabel: UILabel!
    @IBOutlet weak var changeQuoteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        shareButton.isEnabled = false
        changeQuoteButton.backgroundColor = UIColor(hexString: "#F2F2F2")
        changeQuoteButton.setTitleColor(UIColor(hexString: "#ABABAB"), for: .normal)
        shareButton.backgroundColor = UIColor(hexString: "#F2F2F2")
        shareButton.setTitleColor(UIColor(hexString: "#ABABAB"), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        loadUpKanyeQuote()
    }
    
    
    var headers: HTTPHeaders {
        get {
            return [
                "Accept": "application/json"
            ]
        }
    }
    
    func loadUpKanyeQuote() {
        
        let url = "https://api.kanye.rest"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if let data: Data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    self.kanyeQuote = json["quote"].stringValue
                    self.kanyeQuoteLabel.text = self.kanyeQuote.uppercased()
                    self.shareButton.isEnabled = true
                    
                }else{
                    self.activityIndicator.stopAnimating()
                }
                
        }
    }
    
    func randomImage() -> String {
        let images = ["https://studybreaks.com/wp-content/uploads/2018/06/Kanye-West.jpg", "https://static.spin.com/files/2018/05/kanye-west-charlamagne-interview-video-1525193800-640x427.png", "https://www.rollingstone.com/wp-content/uploads/2019/01/shutterstock_10010937aj.jpg", "https://www.billboard.com/files/media/kanye-west-top-five-premiere-2014-billboard-1548.jpg","https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Kanye_West_at_the_2009_Tribeca_Film_Festival.jpg/220px-Kanye_West_at_the_2009_Tribeca_Film_Festival.jpg","https://images.complex.com/complex/images/c_limit,w_680/fl_lossy,pg_1,q_auto/g0htb15qwwxb6k4cacqm/kanye-west-getty-bertrand-rindoff-petroff","https://s2.r29static.com//bin/entry/06f/720x864,85/2166680/yeezus-walks-kanye-west-brings-2166680.webp","https://www.rollingstone.com/wp-content/uploads/2018/09/shutterstock_9876703de.jpg?crop=900:600&width=300","https://www.rollingstone.com/wp-content/uploads/2018/12/kanye-west-wants-to-work-with-bob-dylan-tweet-2018.jpg?crop=900:600&width=440","https://ksassets.timeincuk.net/wp/uploads/sites/55/2018/10/Kanye-West-Yandhi-920x584.jpg","https://m.media-amazon.com/images/M/MV5BMTM0Nzc5ODkyM15BMl5BanBnXkFtZTcwOTczMTgxNw@@._V1_UY317_CR0,0,214,317_AL_.jpg","https://cdn.theatlantic.com/assets/media/img/mt/2018/10/RTX6EQR9/lead_720_405.jpg?mod=1539615178","https://image.redbull.com/rbcom/010/2016-05-24/1331796764191_2/0012/0/0/0/2747/4120/1500/1/kanye-west.jpg","https://thenypost.files.wordpress.com/2018/10/gettyimages-1051894586.jpg?quality=90&strip=all&w=618&h=410&crop=1","https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Kanyewestdec2008.jpg/180px-Kanyewestdec2008.jpg"]
        return images.randomElement()!
    }
    
    
    func showShareSheet() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "kanyequote/\(NSUUID().uuidString)")
        buo.title = kanyeQuote
        buo.contentDescription = "My Content Description"
        buo.imageUrl = randomImage()
        buo.contentMetadata.customMetadata["quote"] = self.kanyeQuote
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "sms"
        lp.feature = "sharing"
        let message = "Peep this Quote:"
        buo.showShareSheet(with: lp, andShareText: message, from: self) { (activityType, completed) in
            print(activityType ?? "")
        }
    }
    
    @IBAction func changeKanyeQuote(sender: UIButton) {
        loadUpKanyeQuote()
    }
    
    @IBAction func shareWithFriends(sender: UIButton) {
        showShareSheet()
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

