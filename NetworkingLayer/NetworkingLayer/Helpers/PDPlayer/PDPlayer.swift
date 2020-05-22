//
//  PDPlayerView.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/22/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PDPlayer: UIView {
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var fullSizeBtn: UIButton!
    @IBOutlet weak var loadProgressView: UIProgressView!
    
    var fileURL: URL! {
        didSet {

        }
    }
    
   
    override init(frame: CGRect) {
        
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
