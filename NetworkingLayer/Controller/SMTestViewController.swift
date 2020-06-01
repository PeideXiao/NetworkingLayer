//
//  SMTestViewController.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

class SMTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = LanguageManager.shared;
        manager.getLanguages { (languages, error) in
            if let err = error { print(err.localizedDescription); return }
            print(languages!);
        }
    }
}
