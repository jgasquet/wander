//
//  AddEventFifthViewController.swift
//  Wander
//
//  Created by IOS on 7/20/18.
//  Copyright © 2018 IOS. All rights reserved.
//

import UIKit

class AddEventFifthViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var eventHeightConstraint: NSLayoutConstraint!
    @IBOutlet var coverImgVw: UIImageView!
    @IBOutlet var coverAddBtn: UIButton!
    @IBOutlet var coverCrossBtn: UIButton!
    @IBOutlet var photosCollectionView: UICollectionView!
    
    var photosArray: [UIImage] = []
    var photosDataArray: [Data] = []
    let picker = UIImagePickerController()
    var imgData: Data = Data()
    var coverImgData: Data = Data()
    var isCover: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHeightConstraint.constant = 600
        
        picker.delegate = self
        
        coverAddBtn.layer.borderColor = UIColor.red.cgColor
        coverAddBtn.layer.borderWidth = 1.0
        coverCrossBtn.isHidden = true
        coverImgVw.image = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func coverAddBtnAction(_ sender: Any) {
        isCover = true
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGallary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func coverCrossBtnAction(_ sender: Any) {
        coverImgVw.image = nil
        coverAddBtn.isHidden = false
        coverCrossBtn.isHidden = true
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        //addEventDict["coverPhoto"] = coverImgVw.image
        if coverImgVw.image == nil {
            self.showMessage(message: "Cover photo is mandatory.")
        }
        else {
            photosDataArray.insert(coverImgData, at: 0)
            addEventDict["photos"] = photosDataArray
            let vc: AddEventSixthViewController = storyboard?.instantiateViewController(withIdentifier: "AddEventSixthViewController") as! AddEventSixthViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailsCollectionViewCell", for: indexPath as IndexPath) as! EventDetailsCollectionViewCell
        cell.cellAddButton.addTarget(self, action: #selector(addBtnAction(_:)), for: .touchUpInside)
        cell.cellAddButton.layer.borderColor = UIColor.red.cgColor
        cell.cellAddButton.layer.borderWidth = 1.0
        cell.cellDeleteButton.tag = 1000 + indexPath.item
        cell.cellDeleteButton.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
        if indexPath.item == photosArray.count {
            cell.cellImageView.isHidden = true
            cell.cellAddButton.isHidden = false
            cell.cellDeleteButton.isHidden = true
        }
        else {
            cell.cellImageView.isHidden = false
            cell.cellAddButton.isHidden = true
            cell.cellDeleteButton.isHidden = false
            cell.cellImageView.image = photosArray[indexPath.item]
        }
        return cell
    }
    
    @objc func addBtnAction(_ sender: UIButton) {
        isCover = false
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.openGallary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func deleteBtnAction(_ sender: UIButton) {
        photosArray.remove(at: sender.tag-1000)
        photosDataArray.remove(at: sender.tag-1000)
        photosCollectionView.reloadData()
    }
    
    //MARK:- UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView .deselectItem(at: indexPath, animated: true)
    }
    
    //MARK:- UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath:IndexPath ) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    //MARK:- UIImage
    
    func openGallary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - UIImagePicker Delegates
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        if isCover == true {
            coverImgData = UIImageJPEGRepresentation(chosenImage, 0.5)!
            coverImgVw.image = chosenImage
            coverAddBtn.isHidden = true
            coverCrossBtn.isHidden = false
        }
        else {
            imgData = UIImageJPEGRepresentation(chosenImage, 0.5)!
            photosArray.append(chosenImage)
            photosDataArray.append(imgData)
            photosCollectionView.reloadData()
        }
    }
}
