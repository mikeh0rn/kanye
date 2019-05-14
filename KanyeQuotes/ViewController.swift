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
                    self.kanyeQuoteLabel.text = self.kanyeQuote
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

