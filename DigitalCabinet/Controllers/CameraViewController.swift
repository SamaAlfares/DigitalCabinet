//
//  CameraViewController.swift
//  DigitalCabinet
//
//  Created by admin on 31.05.2023.
//

import Foundation
import UIKit
import Vision
import CoreML
import FirebaseStorage
import FirebaseFirestore

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedCabinet: String = ""
    var imageUrl: String = ""
    
    let imagePicker = UIImagePickerController()
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = userPickedImage
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("could not convert to ciImage")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage){
        
        let id = UUID().uuidString
        
        guard let model = try? VNCoreMLModel(for: DiginetClassifier().model) else {
            fatalError("loading coreml model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("failed to procees image")
            }
            if let firstResult = results.first {
                self.navigationItem.title = firstResult.identifier
                let storageRef = Storage.storage().reference().child("\(id).png")
                //let compressedImage = self.resizeImage(image: self.image!, targetSize: 550)!
                if let uploadData = self.convert(cmage: image).jpegData(compressionQuality: 1.0 ){
                    storageRef.putData(uploadData, metadata: nil
                    , completion: { (metadata, error) in
                        if error != nil {
                        //self.writeDatabaseCustomer()
                            print("error")
                            return
                        } else {
                        storageRef.downloadURL(completion: { (url, error) in
                        print("Image URL: \((url?.absoluteString)!)")
                            let quantity = 1
                            let itemName = firstResult.identifier
                            self.db.collection(K.ItemFStore.itemCollectionName).document(id).setData([
                                "ParentID": self.selectedCabinet,
                                "ID": id,
                                "Name": itemName,
                                "Quantity": quantity,
                                "ImageUrl": url?.absoluteString
                            ]) {
                                (error) in
                                if let e = error {
                                    print("there was a mistake\(e)")
                                } else {
                                    print("data saved")
                                }
                            }
                            
                        })
                    }})
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }catch {
            print(error)
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
       let size = image.size
       
       let widthRatio  = targetSize.width  / size.width
       let heightRatio = targetSize.height / size.height
       
       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
       } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
       }
       
       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
       
       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
       image.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       
       return newImage!
   }
    
    func convert(cmage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
}
