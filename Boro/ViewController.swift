//
//  ViewController.swift
//  Boro
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LocatorProtocol {

    var locationHandler:Locator!
    var label:UILabel!
    
    override func loadView() {
        view = UIView(frame: (UIApplication.shared.delegate?.window!?.frame)!)
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationHandler = Locator()
        locationHandler.delegate = self
        let rect = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 200))
        label = UILabel(frame: rect)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 30)
        addConstraints()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func addConstraints(){
        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }

    func locationUpdated(_ location: String) {
        
        guard let isNYCBorough = Borough.checkBorough(location) else {
            print("guess that's not in NYC")
            label.text = "guess that's not in NHC"
            return
        }
        
        print(isNYCBorough)
        label.text = location
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

