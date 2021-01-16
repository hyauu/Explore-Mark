//
//  PlaceDetailViewController.swift
//  Explore&Mark
//
//  Created by 邱浩庭 on 15/1/2021.
//

import Foundation
import UIKit
import CoreData

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeKinds: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    var place: Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesCollection.delegate = self
        imagesCollection.dataSource = self
        
        placeName.text = place.name ?? "Name Unkown"
        placeKinds.text = place.kinds ?? "Kinds Unkown"
        placeDescription.text = place.wikiDescription ?? "Description Unkown"
        
        // get photo info
        let fetcchRequest: NSFetchRequest<Images> = Images.fetchRequest()
        fetcchRequest.predicate = NSPredicate(format: "place == %@", place)
        var images: [Images]
        do {
            images = try DataController.shared.viewContext.fetch(fetcchRequest)
        } catch {
            images = []
        }
        
        if place.imageCount == 0 || images.count < place.imageCount {
            FlickrClient.searchForPhotos(place: place, completion: handleSearchPhotoResponse(data:error:))
        }
    }
    
    func handleSearchPhotoResponse(data: FlickrPhotoSearch?, error: Error?) {
        guard let data = data else {
            print("Flickr search photo failed for: \(error!.localizedDescription)")
            return
        }
        
        // update image count
        place?.imageCount = Int64(data.photos.photo.count)
        do {
            try DataController.shared.viewContext.save()
            imagesCollection.reloadData()
            
            // download image
            for photo in data.photos.photo {
                FlickrClient.downloadImage(photo: photo, size: "m", completion: handleDownloadImageReponse(data:error:))
            }
        } catch {
            print("Fail to save Place's imageCount to CoreData for \(error.localizedDescription)")
        }
    }
    
    func handleDownloadImageReponse(data: UIImage?, error: Error?) {
        guard let data = data else {
            print("Flickr search photo failed for: \(error!.localizedDescription)")
            return
        }
        
        do {
            // store image to CoreData
            let image = Images(context: DataController.shared.viewContext)
            image.place = place
            image.image = data.pngData()
            try DataController.shared.viewContext.save()
            imagesCollection.reloadData()
        } catch {
            print("Fail to save image to Image CoreData for \(error.localizedDescription)")
        }
    }
}

extension PlaceDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(place?.imageCount ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeImageCell", for: indexPath) as! PlaceImageCollectionViewCell
        cell.placeImage.contentMode = .scaleAspectFit
        // fetch images from CoreData
        let fetcchRequest: NSFetchRequest<Images> = Images.fetchRequest()
        fetcchRequest.predicate = NSPredicate(format: "place == %@", place)
        do {
            let images = try DataController.shared.viewContext.fetch(fetcchRequest)
            if (images.count <= indexPath.row) {
                cell.placeImage.image = UIImage(named: "VirtualTourist_512")
            } else {
                cell.placeImage.image = UIImage(data: images[indexPath.row].image!)
            }
        } catch {
            cell.placeImage.image = UIImage(named: "VirtualTourist_512")
            print("Fetch image from CoreData fialed for \(error.localizedDescription)")
        }
        
        return cell
    }
    
}
