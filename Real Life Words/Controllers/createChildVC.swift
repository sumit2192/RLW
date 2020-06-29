//
//  createChildVC.swift
//  Real Life Words
//
//  Created by Mac on 03/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CropViewController
import CoreData

class createChildVC: UIViewController {
    //MARK:- VAriables and Outlets
    //MARK:-
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgShadowVw: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnadd: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var doneVw: UIView!
    @IBOutlet weak var imgDone: UIImageView!
    var imageArr : [UIImage] = []
    var imagePicker = UIImagePickerController()
    var imagePicked :Bool = false
    var imageData : Data?
    var user : childModel!
    var Last_Generated_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        //blurVw.addBlurEffect()
        imgShadowVw.addSahadow()
        txtName.addSahadow()
        txtName.addSpace()
        txtPass.addSahadow()
        txtPass.addSpace()
        txtConfirm.addSahadow()
        txtConfirm.addSpace()
        btnCreate.addSahadow()
        btnCreate.setButtonTitle(Title: "Create")
        imageArr = [#imageLiteral(resourceName: "camera"),#imageLiteral(resourceName: "gallery"),#imageLiteral(resourceName: "user_profile1"),#imageLiteral(resourceName: "user_profile2"),#imageLiteral(resourceName: "user_profile3"),#imageLiteral(resourceName: "user_profile4"),#imageLiteral(resourceName: "user_profile5"),#imageLiteral(resourceName: "user_profile6")]
        imagePicker.delegate = self
    }
    //MARK:- Implement ImagePicker
    //MARK:-
    
    //MARK:- Implement Custom Methods
    //MARK:-
    
    func fetchChild(data: [String:Any]){
        user = childModel(data)
        let Predicate = NSPredicate(format: "parent_email == [c] %@ AND name == [c] %@", user.parent_email!, user.name!)
        let childArr : [childModel] = persistenceStrategy.getChild(Entity:Constant().Table.CHILDREN , predicate: Predicate)
        if childArr.count == 0{
            saveChild(userData: data)
        }else{
           Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: "This user alreay exist. Try logging in or use different name to register", view: self) {}
        }
    }
    
    func saveChild(userData: [String:Any]){
        if let saveChild = persistenceStrategy.addChild(Entity: Constant().Table.CHILDREN, data: userData){
            print("Child saved as %@", saveChild.name!)
            blurVw.isHidden = false
            doneVw.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.doneVw.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { (Completed) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.doneVw.transform = CGAffineTransform.identity
                }) { (Completed) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.doneVw.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }) { (Completed) in
                        UIView.animate(withDuration: 0.1, animations: {
                            self.doneVw.transform = CGAffineTransform.identity
                        }) { (Completed) in
                            self.blurVw.isHidden = true
                            self.doneVw.isHidden = true
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.SETUP_GAME_VC) as! setUpGameVC
                            vc.refuser = self.user
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        }else{
            Utility.showAlertMessage(title: Constant().TITLE, message: "Something went wrong. Please try again", view: self)
        }
    }
    //MARK:- Implement Button Actions
    //MARK:-

    @IBAction func cmdCreate(_ sender: UIButton) {
        if Utility.isTxtFldEmpty(txtName){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.NAME_REQUIRED, view: self)
            return
        }else  if Utility.isTxtFldEmpty(txtPass){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_REQUIRED, view: self)
            return
        }else  if !imagePicked{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PHOTO_REQUIRED, view: self)
            return
        }else{
           
            if txtPass.text!.count < 4{
                Utility.showAlertMessage(title: Constant().TITLE, message: Constant.SHORT_CHILD_PASSWORD, view: self)
            }else{
                if txtPass.text != txtConfirm.text {
                    Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_UNMATCH, view: self)
                }else{
                    //Agree to terms
                    imageData = imgUser.image!.pngData()
                   let childData: [String: Any] = [
                        "name": txtName.text!,
                        "parent_email": DEFAULTS.string(forKey: Constant().UD_SUPER_USER_EMAIL)!,
                        "password":txtPass.text!,
                        "image": imgUser.image!.pngData()!,
                        "child_id": Last_Generated_id!+1
                    ]
                    fetchChild(data: childData)
                }
            }
        }

    }
    @IBAction func cmdAdd(_ sender: UIButton) {
        imgCollection.isHidden = false
        blurVw.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            self.blurVw.layer.add(transition, forKey: nil)
            self.imgCollection.layer.add(transition, forKey: nil)
            transition.subtype = CATransitionSubtype.fromBottom
            self.blurVw.layer.add(transition, forKey: nil)
        }
    }
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
    //MARK:- Implement Collection View Methods
    //MARK:-
extension createChildVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 220)
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCell", for: indexPath) as! ImgCell
        cell.addSahadow()
        cell.cellImg.image = imageArr[indexPath.row]
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // self.view.endEditing(true)
         blurVw.isHidden = true
        collectionView.isHidden = true
        if indexPath.row > 1{
            self.imgUser.image = imageArr[indexPath.row]
            self.infoLbl.isHidden = true
            self.imagePicked = true
        }else if indexPath.row == 1{
            self.takePhotoFromGallery()
        }else{
            self.takePhotoFromCamera()
        }
    }
    
}

    //MARK:- Cell Custom Class
    //MARK:-
class ImgCell:UICollectionViewCell{
    @IBOutlet weak var cellImg: UIImageView!
}

//MARK:- UIimagePickercontroller Delegate Methods
//MARK:-
extension createChildVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func takePhotoFromCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func takePhotoFromGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            
        }
    }
    
    //MARK: ImagePicker Delegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.dismiss(animated: true, completion: nil)
           let vc = CropViewController(image: pickedImage)
            vc.delegate = self
            vc.aspectRatioLockEnabled = true
            vc.aspectRatioPreset = .preset5x4
           // self.navigationController?.pushViewController(vc, animated: true)
            self.present(vc, animated: true) {
                
            }
        }
 
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- CropViewControllerDelegate Methods
//MARK:-
extension createChildVC : CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.imgUser.image = image
        self.infoLbl.isHidden = true
        self.imagePicked = true
        self.dismiss(animated: true, completion: nil)
       // self.navigationController?.popViewController(animated: true)
    }
}
