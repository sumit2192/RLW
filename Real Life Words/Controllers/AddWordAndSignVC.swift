//
//  AddWordAndSignVC.swift
//  Real Life Words
//
//  Created by Mac on 08/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CropViewController
import CoreData

class AddWordAndSignVC: UIViewController {

    //MARK:- Variables and outlets
    //MARK:-
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var fontCollectionVw: UICollectionView!
    @IBOutlet weak var CameraBaseVw: UIView!
    @IBOutlet weak var CameraVw: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var GalleryVw: UIView!
    @IBOutlet weak var btnGallery: UIButton!
    
    var refUser: childModel!
    var word: wordModel!
    var fontNameArr : [String]!
    var fontColorArr : [UIColor]!
    var fontColorNameArr : [UIColor]!
    var imagePicker = UIImagePickerController()
    var imagePicked :Bool = false
    var Last_Generated_wordId : Int?
    
    var arrSelectedTypeIndex = [IndexPath]()
    var arrSelectedColorIndex = [IndexPath]()
    var imageData : Data?
    var colorStr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.setButtonTitle(Title: "Add")
        fontNameArr = ["Baloo Paji","Montserrat","Roboto","Arial","Atma","Bevan","Capriola"]
        fontColorArr = [UIColor(named: "Color-1")!,UIColor(named: "Color-2")!,UIColor(named: "Color-3")!,UIColor(named: "Color-4")!,UIColor(named: "Color-5")!]
        
        imgSign.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_image)))
        imagePicker.delegate = self
                // Do any additional setup after loading the view.
    }
   //MARK:- Implement Custom Methods
   //MARK:-
    
    func createWordWithSuppliedData(data: [String:Any]){
        word = wordModel(data)
        let predicate = NSPredicate(format: "name == [c] %@", word.name!)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do{
            let obj = try context.fetch(request)
            if obj.count == 0{
                print("not exist")
                self.saveData()
            }else{
                print("exist")
                print(obj.first!)
                Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: String(format: "This word alreay exist for %@ . Please use a different word", word.user_name!), view: self) {
                    
                }
            }
        }catch{
            print(error.localizedDescription)
                      // return nil
        }
    }
    
    func saveData(){

        let entity = NSEntityDescription.entity(forEntityName: "Words", in: context)
        let newWord = NSManagedObject(entity: entity!, insertInto: context)
        newWord.setValue(word.font_color, forKey: "font_color")
        newWord.setValue(word.font_name, forKey: "font_name")
        newWord.setValue(word.name, forKey: "name")
        newWord.setValue(word.parent_email, forKey: "parent_email")
        newWord.setValue(word.user_name, forKey: "user_name")
        newWord.setValue(word.sign, forKey: "sign")
        newWord.setValue(word.word_id, forKey: "word_id")
        do {
            try context.save()
           // Utility.showKSAlertMessage(title: Constant().TITLE, message: "Word added sucessfully", view: self)
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error while saving")
        }
    }
    
    @objc func tap_image(sender:UITapGestureRecognizer){
        if CameraBaseVw.isHidden{
            self.CameraBaseVw.isHidden = false
            UIView.animate(withDuration: 0.3) {
                let transition = CATransition()
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromTop
                self.CameraBaseVw.layer.add(transition, forKey: nil)
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                let transition = CATransition()
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromBottom
                self.CameraBaseVw.layer.add(transition, forKey: nil)
                self.CameraBaseVw.isHidden = true
            }
        }

    }
    //MARK:- Implement Button Methods
    //MARK:-
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cmdAdd(_ sender: UIButton) {
        if Utility.isTxtFldEmpty(txtName){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.WORD_NAME_REQUIRED, view: self)
            return
        }else  if !imagePicked{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.WORD_IMAGE_REQUIRED, view: self)
            return
        }else  if arrSelectedTypeIndex.count == 0{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.FONT_TYPE_REQUIRED, view: self)
            return
        }else  if arrSelectedColorIndex.count == 0{
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.FONT_COLOR_REQUIRED, view: self)
            return
        }else{
            imageData = imgSign.image!.pngData()
            let refcolor = fontColorArr[arrSelectedColorIndex[0].row]
            colorStr = refcolor.StringFromUIColor(color: refcolor)
            let refFont = fontNameArr[arrSelectedTypeIndex[0].row]
            let wordData: [String: Any] = [
                "font_color": colorStr!,
                "font_name": refFont,
                "name": txtName.text!,
                "parent_email":refUser.parent_email!,
                "user_name":refUser.name!,
                "sign": imageData!,
                "word_id": Last_Generated_wordId!+1
            ]
            self.createWordWithSuppliedData(data: wordData)
        }
    }
    
    @IBAction func cmdpickFrom(_ sender: UIButton) {
        //sender tag 0 for camera, 1 for gallery
        if sender.tag == 0{
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                UIView.animate(withDuration: 0.3) {
                               let transition = CATransition()
                               transition.type = CATransitionType.push
                               transition.subtype = CATransitionSubtype.fromBottom
                               self.CameraBaseVw.layer.add(transition, forKey: nil)
                               self.CameraBaseVw.isHidden = true
                           }
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
        }else{
            UIView.animate(withDuration: 0.3) {
                           let transition = CATransition()
                           transition.type = CATransitionType.push
                           transition.subtype = CATransitionSubtype.fromBottom
                           self.CameraBaseVw.layer.add(transition, forKey: nil)
                           self.CameraBaseVw.isHidden = true
                       }
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
}

//MARK:- UIimagePickercontroller Delegate Methods
//MARK:-
extension AddWordAndSignVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

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
extension AddWordAndSignVC : CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        self.imgSign.image = image
        self.imagePicked = true
        self.dismiss(animated: true, completion: nil)
       
    }
}
    //MARK:- Implement Collection View Methods
    //MARK:-
extension AddWordAndSignVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0{
            return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.height/2 )
        }else{
            return CGSize(width: 100, height: 100)
        }
        
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return fontNameArr.count
        }else{
            return fontColorArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontTypeCell", for: indexPath) as! FontTypeCell
            cell.lblFontName.text = fontNameArr[indexPath.row]
            if arrSelectedTypeIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                cell.backgroundColor = #colorLiteral(red: 0.9330000281, green: 0.976000011, blue: 1, alpha: 1)
                cell.lblFontName.textColor = #colorLiteral(red: 0, green: 0.4629999995, blue: 0.7179999948, alpha: 1)
            }else {
                cell.backgroundColor = #colorLiteral(red: 0.9330000281, green: 0.976000011, blue: 1, alpha: 0)
                cell.lblFontName.textColor = #colorLiteral(red: 0.9333333333, green: 0.9764705882, blue: 1, alpha: 1)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontColorCell", for: indexPath) as! FontColorCell
            cell.colorVw.backgroundColor = fontColorArr[indexPath.row]
            if arrSelectedColorIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
                cell.backgroundColor = #colorLiteral(red: 0.9330000281, green: 0.976000011, blue: 1, alpha: 1)
            }else {
                cell.backgroundColor = #colorLiteral(red: 0.9330000281, green: 0.976000011, blue: 1, alpha: 0)
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0{
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 50)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            if arrSelectedTypeIndex.contains(indexPath) {
                arrSelectedTypeIndex = arrSelectedTypeIndex.filter { $0 != indexPath}
            }
            else {
                arrSelectedTypeIndex.removeAll()
                arrSelectedTypeIndex.append(indexPath)
            }
           
        }else{
            if arrSelectedColorIndex.contains(indexPath) {
                arrSelectedColorIndex = arrSelectedColorIndex.filter { $0 != indexPath}
            }
            else {
                arrSelectedColorIndex.removeAll()
                arrSelectedColorIndex.append(indexPath)
            }
        }
        
         collectionView.reloadData()
    }
    
}
    //MARK:- Cell Custom Class
    //MARK:-
class FontTypeCell:UICollectionViewCell{
    @IBOutlet weak var lblFontName: UILabel!
    
}


class FontColorCell:UICollectionViewCell{
    @IBOutlet weak var colorVw: UIView!
}
/**            */
    
    
