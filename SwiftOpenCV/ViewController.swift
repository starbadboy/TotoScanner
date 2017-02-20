//
//  ViewController.swift
//  SwiftOpenCV
//
//  Created by Lee Whitney on 10/28/14.
//  Copyright (c) 2014 WhitneyLand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTakePictureTapped(_ sender: AnyObject) {
        
        let sheet: UIActionSheet = UIActionSheet();
        let title: String = "Please choose an option";
        sheet.title  = title;
        sheet.delegate = self;
        sheet.addButton(withTitle: "Choose Picture");
        sheet.addButton(withTitle: "Take Picture");
        sheet.addButton(withTitle: "Cancel");
        sheet.cancelButtonIndex = 2;
        sheet.show(in: self.view);
    }
    
    func actionSheet(_ sheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch buttonIndex{
            
        case 0:
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            break;
        default:
            break;
        }
    }
    
    
    @IBAction func onDetectTapped(_ sender: AnyObject) {
        
        let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
        progressHud?.labelText = "Detecting..."
        progressHud?.mode = MBProgressHUDModeIndeterminate
        
        let ocr = SwiftOCR(fromImage: selectedImage)
        ocr.recognize()
        
        imageView.image = ocr.groupedImage
        
        progressHud?.hide(true);
    }
    
    @IBAction func onRecognizeTapped(_ sender: AnyObject) {
        
        if((self.selectedImage) != nil){
            let progressHud = MBProgressHUD.showAdded(to: view, animated: true)
            progressHud?.labelText = "Detecting..."
            progressHud?.mode = MBProgressHUDModeIndeterminate
            
            DispatchQueue.global(qos: .background).async(execute: { () -> Void in
                let ocr = SwiftOCR(fromImage: self.selectedImage)
                ocr.recognize()
                
                DispatchQueue.main.sync(execute: { () -> Void in
                    self.imageView.image = ocr.groupedImage
                    
                    progressHud?.hide(true);
                    
                    let dprogressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    dprogressHud?.labelText = "Recognizing..."
                    dprogressHud?.mode = MBProgressHUDModeIndeterminate
                    
                    let text = ocr.recognizedText
                    
                    self.performSegue(withIdentifier: "ShowRecognition", sender: text);
                    
                    dprogressHud?.hide(true)
                })
            })
        }else {
            let alert = UIAlertView(title: "SwiftOCR", message: "Please select image", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        selectedImage = image;
        picker.dismiss(animated: true, completion: nil);
        imageView.image = selectedImage;
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc =  segue.destination as! DetailViewController
        vc.recognizedText = sender as! String
    }


}

