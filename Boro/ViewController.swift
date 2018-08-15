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

        //Setup UI
        let rect = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 200))
        label = UILabel(frame: rect)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 30)
        addConstraints()
        
        //Start Locationhandler model
        locationHandler = Locator()
        locationHandler.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func addConstraints(){
        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    }

    func locationUpdated(_ locator: Locator) {
         label.text = locator.getBorough().getString()
    }
    
    func locatorError(errorMsg: String) {
        label.text = "Error"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        locationHandler.doUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // locationHandler.doUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

