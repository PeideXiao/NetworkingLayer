//
//  ViewController.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var albums:[Album] = []
    var manager = AlbumServiceManager.shared
    var imageCached:[String: UIImage] = [:]
    var queue: OperationQueue = OperationQueue()
    var operatioinDict = [String: ImageOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        self.navigationItem.title = "Albums";
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.saveData();
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(self.albums) as Data {
            print(NSHomeDirectory());
            UserDefaults.standard.setValue(data, forKey: "albums");
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let album = self.albums[indexPath.row];
        cell.textLabel?.text = album.name;
        
        let url = album.coverURL;
        
        if self.imageCached.count > 20 {
            self.imageCached.removeAll();
            print("cache cleared")
        }
        
        if let image = imageCached[url] {
            cell.imageView?.image = image
            print("Memory****")
        }
        else {
            cell.imageView?.image = self.placeholderImage();
            
            do {
                let data = try SandBoxHandler.readData(from:"\(album.collectionID).jpg");
                let image = UIImage(data: data);
                cell.imageView?.image = image
                imageCached[url] = image
                print("Sandbox====\(self.imageCached.count)")
                
            } catch {
                // download
                
                if let _ = operatioinDict[url] { return cell; }
                let op = ImageOperation(album: album)  { (image:UIImage?, error: Error?) in
                    if let image:UIImage = image {
                        self.imageCached[url] = image;
                        self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.middle);
                        self.operatioinDict.removeValue(forKey: url)
                    }
                    else {
                        // image = nil
                        print("!!!download fail, image is nil")
                        self.operatioinDict.removeValue(forKey: url);
                    }
                }
                queue.addOperation(op);
                operatioinDict[url] = op;
            }
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = self.albums[indexPath.row];
        let vc = PlayerViewController();
        vc.filePath = album.previewURL;
        
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil);
    }
    
}

extension ViewController {
    
    func filePath(fileName: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!;
        return path + "/\(fileName).jpg"
    }
    
    func placeholderImage()-> UIImage? {
        let filePath = Bundle.main.path(forResource: "placeholder", ofType: "png");
        return UIImage(contentsOfFile: filePath!);
    }
    
    
    func filePath_archiver() {
        var documentDirectory = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!;
        documentDirectory.appendPathComponent("music.mp3");
        
        //        NSKeyedArchiver.archivedData(withRootObject: <#T##Any#>, requiringSecureCoding: <#T##Bool#>)
        //        NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: <#T##Data#>)
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        manager.getAlbums(text) { (results: Result<[Album]>) in
            switch results {
            case .success(let albums):
                DispatchQueue.main.async {
                    self.albums = albums
                    self.tableView.reloadData();                }
                
            case .failure(let err):  print(err.localizedDescription)
            }
        }
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
