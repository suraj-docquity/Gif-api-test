//
//  ViewController.swift
//  Gif api test
//
//  Created by Suraj Jaiswal on 14/02/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

   
    @IBOutlet var gifCollectionView: UICollectionView!
    
    var gifData : GifData?
    var gifDataArr = [DataObject]()
    var gifImage = [ImgObject]()
    var gifImgLinks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
//        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=CqpjNoJdmUgkEyhXAVIFC01bZtK0oZoX&limit=3&rating=g")
        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=CqpjNoJdmUgkEyhXAVIFC01bZtK0oZoX&limit=100&rating=g")
        
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler:{
            (resData,response,error) in
            
            guard let gifResData = resData, error == nil else {
                print("Error while accessing data")
                return
            }
            
            var gifDataObject : GifData?
            do{
                gifDataObject = try JSONDecoder().decode(GifData.self, from: gifResData)
            }
            catch{
                print("Error while data parsing")
            }
            
            self.gifDataArr = gifDataObject!.data
            for i in self.gifDataArr {
//                print(i.images.original.url,"\n")
                self.gifImgLinks.append(i.images.original.url)
            }
            
            DispatchQueue.main.async {
                self.gifCollectionView.reloadData()
            }
            
        })
        
        task.resume()
    }
}

extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifImgLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = gifCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GifCollectionViewCell
        
        if let gifImgURL = URL(string: gifImgLinks[indexPath.row]){
            
            cell.gifImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
            cell.gifImgView.sd_imageIndicator?.startAnimatingIndicator()
            cell.gifImgView.sd_setImage(with: gifImgURL, placeholderImage: UIImage(named: "empty-img.png"),options: .continueInBackground,completed: nil)
            
            cell.gifImgView.contentMode = .scaleToFill
            cell.gifImgView.layer.cornerRadius = 5
            
            
        }else{
            cell.gifImgView.image = UIImage(named: "empty-img.png")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.size.width - 30)/2
        return CGSize(width: size, height: size)
    }
    
    
    
    
}
