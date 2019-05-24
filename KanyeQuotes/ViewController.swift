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
    
    override func viewWillAppear(_ animated: Bool) {
        changeQuoteButton.backgroundColor = UIColor(hexString: "#F2F2F2")
        changeQuoteButton.setTitleColor(UIColor(hexString: "#ABABAB"), for: .normal)
        shareButton.backgroundColor = UIColor(hexString: "#F2F2F2")
        shareButton.setTitleColor(UIColor(hexString: "#ABABAB"), for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                }
        }
    }
    
    
    func showShareSheet() {
        let buo = BranchUniversalObject.init(canonicalIdentifier: "kanyequote/\(NSUUID().uuidString)")
        buo.title = "My Favorite Kanye Quote"
        buo.contentDescription = "My Content Description"
        buo.imageUrl = "https://timedotcom.files.wordpress.com/2000/04/kanye-west-time-100-2015-titans.jpg?quality=85"
        buo.contentMetadata.customMetadata["quote"] = self.kanyeQuote
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "sms"
        lp.feature = "sharing"
        let message = "Peep this crazy thing Kanye said!"
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

