//
//  Constants.swift
//  DigitalCabinet
//
//  Created by admin on 18.04.2023.
//

struct K{
    
    static let cellName = "Cell"
    static let collectionCellName = "ItemsCollectionViewCell"
    
    struct Info {
        static let email = "   Email"
        static let username = "   Username"
        static let password = "   Password"
    }
    
    struct Segues {
        static let signupSegue = "SignUpSegue"
        static let loginSegue = "LoginSegue"
        static let groceriesSegue = "GroceriesSegue"
        static let cameraSegue = "CameraSegue"
    }
    
    struct AddButton {
        static let cabinetAlertTitle = "Add New Cabinets"
        static let cabinetActionTitle = "Add Cabinet"
        static let cabinetTextFieldPlaceHolder = "Create New Cabinet"
        
        static let itemAlertTitle = "Add New Item"
        static let itemActionTitle = "Add Item"
        static let itemTextFieldPlaceHolder = "Create New Item"
    }
    
    struct CabinetFStore {
        static let cabinetCollectionName = "Cabinets"
        static let id = "ID"
        static let owner = "Owner"
        static let name = "Name"
    }
    
    struct ItemFStore {
        static let itemCollectionName = "Items"
        static let parentID = "ParentID"
        static let id = "ID"
        static let name = "Name"
        static let quantity = "Quantity"
        static let imageUrl = "ImageUrl"
    }
}
