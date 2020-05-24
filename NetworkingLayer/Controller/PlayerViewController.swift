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

public let ScreenWidth = UIScreen.main.bounds.width
public let ScreenHeight = UIScreen.main.bounds.height
var layer: PDPlayer!
var appDelegate = UIApplication.shared.delegate as! AppDelegate

class PlayerViewController: UIViewController {
    
    var filePath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange;
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissVC));
        self.navigationController?.navigationBar.isTranslucent = true;
        
        appDelegate.allowRotation = true;
        
        layer = PDPlayer(frame: CGRect(x:30, y: 100, width: ScreenWidth - 60, height: 200), superVC: self);
        layer.fileURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!;
        view.addSubview(layer);
        
    }
    
    @objc func dismissVC() {
        layer.removeObserver();
        self.dismiss(animated: true, completion: nil);
    }
    
    func setupUI(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bird"), for: .normal);
        button.setImage(UIImage(systemName: "pencil.circle"), for: .selected);
        button.adjustsImageWhenHighlighted = false;
        view.addSubview(button);
        
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

}

