//
//  UIImage+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension UIImage {
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    // size 以 bit 为单位， 比如，想要压缩到120KB 则size=120*1024
    func quality(_ quality:JPEGQuality) -> UIImage? {
        guard let imageData = self.jpegData(compressionQuality: quality.rawValue) else { return nil }
        return UIImage(data: imageData);
    }
    
    static func compress(_ image: UIImage, _ quality:JPEGQuality) -> UIImage? {
        return image.quality(quality);
    }
    
    // return like 0.5MB, 1000KB
    func sizeString(imageData: Data) -> String {
        let byteCount = imageData.count;
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(byteCount));
    }
    
    /**
     将当前图片缩放到指定大小
     targetWidth -> 目标宽度，高度等比缩放
     备注：等比缩放
     */
    
    func compressWidth(to targetWidth: CGFloat) -> UIImage? {
        let rate = self.size.width/self.size.height
        let targetHeight = targetWidth/rate;
       return self.compressSize(to: CGSize(width: targetWidth, height: targetHeight));
    }
    
    // 指定的高度
    func compressHeight(to targetHeight: CGFloat) -> UIImage? {
           let rate = self.size.width/self.size.height
           let targetWidth = targetHeight * rate;
          return self.compressSize(to: CGSize(width: targetWidth, height: targetHeight));
       }
    
    
    func compressSize(to targetSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(targetSize);
        self.draw(in:CGRect(origin: .zero, size: targetSize));
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    
    
    // screenshot
    static func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    /**
    根据颜色和大小生成一张纯色图片
    */
    static func createColorImage(with color: UIColor) -> UIImage? {
        return self.createColorImage(with: color, size: CGSize(width: 1, height: 1));
    }
    
    
    static func createColorImage(with color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        color.setFill();
        UIRectFill(CGRect(origin: .zero, size: size));
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return image;
    }
    
    /**
    对当前图片进行图片模糊
    number： 模糊参数 （0.1 ~ 1.0）之间，表示模糊的程度
    */
     func blur() -> UIImage? {
        guard let ciImg = CIImage(image: self) else { return nil }
        let blur = CIFilter(name: "CIGaussianBlur");
        blur?.setValue(ciImg, forKey: kCIInputImageKey);
        blur?.setValue(5.0, forKey: kCIInputRadiusKey);
        if let outputImg = blur?.outputImage {
            return UIImage(ciImage: outputImg);
        }
        return nil;
    }
    
    func saveToLibrary() {
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self);
            let assetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil);
            let collection =  assetCollections.object(at: 4);
            let addAssetRequest = PHAssetCollectionChangeRequest(for: collection);
            addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray);
            
        }, completionHandler: {success, error in
            if !success { print("Error creating the asset: \(String(describing: error))") }
        })
        
    }
}
