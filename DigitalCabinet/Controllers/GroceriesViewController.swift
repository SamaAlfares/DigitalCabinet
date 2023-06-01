//
//  GroceriesViewController.swift
//  DigitalCabinet

import UIKit

import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

import SDWebImage

class GroceriesViewController: UICollectionViewController {
    
    
    //MARK: - Variables Initialization
    
    let db = Firestore.firestore()
    var items: [Item] = []
    var id: String = ""
    static var imageUrl: String = ""
    var selectedCabinet: String? {
        didSet {
            loadItems()
        }
    }
    
    @IBOutlet var viewCollection: UICollectionView!
    
    @IBAction func cameraBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segues.cameraSegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation")}
        
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0) as Any]
        
    }
    
    //MARK: - CollectionView Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell" , for: indexPath) as? ItemCollectionViewCell else {
            fatalError("unable to dequeue")
        }
        
        let item = items[indexPath.row]
        cell.nameLbl.text = item.name
        cell.quantityLbl.text = String(item.quantity)
        cell.imageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        cell.imageView.setCorners(radius: 10)
        cell.decreaseBtn.setCorners(corner1: .layerMinXMaxYCorner, corner2: .layerMinXMinYCorner, radius: 15)
        cell.increaseBtn.setCorners(corner1: .layerMaxXMaxYCorner, corner2: .layerMaxXMinYCorner, radius: 15)
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func loadItems() {
        
        db.collection(K.ItemFStore.itemCollectionName).whereField("ParentID", isEqualTo: selectedCabinet as Any).addSnapshotListener { querySnapshot, error in
            self.items = []
            if let e = error {
                print("there was an issue retrieving data from the database\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let id = data[K.ItemFStore.id] as? String, let name = data[K.ItemFStore.name] as? String, let quantity = data[K.ItemFStore.quantity] as? Int, let imageUrl = data[K.ItemFStore.imageUrl] as? String  {
                            let newItem = Item(parentID: self.selectedCabinet!, id: id, name: name, quantity: quantity, imageUrl: imageUrl )
                            self.items.append(newItem)
                            print("Appended \(name)")
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                _ = IndexPath(row: self.items.count, section: 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CameraViewController
        
        destinationVC.selectedCabinet = selectedCabinet ?? "No Cabinet"
    }

}


//MARK: - Setting Cell Dimensions

extension GroceriesViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let heightVal = self.view.frame.height
        let widthVal = self.view.frame.width
        let cellsize = (heightVal < widthVal) ?  bounds.height/2 : bounds.width/2

        return CGSize(width: cellsize - 10   , height:  cellsize + 40  )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}



