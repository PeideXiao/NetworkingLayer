//
//  PlayerViewController.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/21/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var filePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func setupUI(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bird"), for: .normal);
        button.setImage(UIImage(systemName: "pencil.circle"), for: .selected);
        button.adjustsImageWhenHighlighted = false;
        view.addSubview(button);
        button.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ]);
        
        let red = UIView()
        red.backgroundColor = UIColor.red;
        red.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(red);
        NSLayoutConstraint.activate([
            red.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            red.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            red.widthAnchor.constraint(equalToConstant: 100),
            red.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0)
        ])
    }
    
    func avplayer(){
        //        1
        //        let avset = AVURLAsset(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!);
        //        let item = AVPlayerItem(asset: avset);
        //        player = AVPlayer(playerItem: item);
        //        let layer = AVPlayerLayer(player: player);
        //        layer.frame = self.view.bounds;
        //        layer.videoGravity = .resizeAspect
        //        view.layer.addSublayer(layer);
        
        //        2.
        //        let vc = AVPlayerViewController()
        //        vc.player = player
        //        vc.view.frame = self.view.bounds
        //        addChild(vc)
        //        view.addSubview(vc.view);
        //        vc.didMove(toParent: self)

    }
    
    @objc func play(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}

