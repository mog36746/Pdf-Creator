//
//  PdfBuilderViewController- .swift
//  Pdf Creator
//
//  Created by Md. Mazidul Islam on 4/3/20.
//  Copyright © 2020 Jon. All rights reserved.
//

import UIKit

class PdfBuilderViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var toTextField: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var applicationTextField: UITextView!
    @IBOutlet weak var requestTextField: UITextView!
    @IBOutlet weak var fromTextField: UITextView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var size8: UIButton!
    @IBOutlet weak var size9: UIButton!
    @IBOutlet weak var size10: UIButton!
    @IBOutlet weak var size11: UIButton!
    @IBOutlet weak var size12: UIButton!
    var fontSize: CGFloat = 10
    
    func setUpView() {
        dateTextField.text = "৩০ জুলাই ২০১৮"
        toTextField.text = """
বরাবর
প্রধান নির্বাহী
সামাজিক যোগাযোগ মাধ্যম ফেসবুক
ক্যালিফোর্নিয়া, যুক্তরাষ্ট্র
        
"""
        subjectTextField.text = "বিষয়: ফেসবুক একাউন্ট সক্রিয় করার আবেদন"
        applicationTextField.text = """
        
        জনাব
        সবিনয় নিবেদন এই যে, আমি একজন নিয়মিত ফেসবুক ব্যবহারকারী। গত ৫ বছর থেকে 00j1unied@gmail.com মেইলটি ব্যবহার করে এবং ফেসবুক কর্তৃপক্ষের সকল নিয়মনীতি মেনে আমি ফেসবুক ব্যবহার করে আসছি। কিন্তু গত ২দিন থেকে কোন এক অজানা কারণে আমার ফেসবুক একাউন্টটি নিষ্ক্রিয় হয়ে গেছে। যার ফলে আমি সামাজিক যোগাযোগ মাধ্যমটি ব্যবহার থেকে বঞ্চিত হচ্ছি। যা আমাকে পুরো বিশ্ব থেকে পিছিয়ে দিচ্ছে।
        
        """
        requestTextField.text = "অতএব আবেদন এই যে, আমার একাউন্টটি কেন নিষ্ক্রিয় করে দেয়া হয়েছে তা অনুসন্ধান করে দ্রুত সক্রিয় করার মাধ্যমে আমার সামাজিক যোগাযোগের পথটি সুগম করতে আজ্ঞা হয়।"
        fromTextField.text = """
        
বিনীত
জুনাইদ হোসেন
বাসা নং: এবিসি, রোড নং: ১২৩,
বাংলামোটর, ঢাকা-১২১৫
"""
        
    }
    func setBorder(textField: UIView) {
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4.0
    }
    override func viewDidLoad() {
        setUpView()
        super.viewDidLoad()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String )
        // Add subtle outline around text views
        setBorder(textField: dateTextField)
        setBorder(textField: toTextField)
        setBorder(textField: subjectTextField)
        setBorder(textField: applicationTextField)
        setBorder(textField: requestTextField)
        setBorder(textField: fromTextField)
        setBorder(textField: imagePreview)

        
        // Add the share icon and action
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        self.toolbarItems?.append(shareButton)
        
        // Add responder for keyboards to dismiss when tap or drag outside of text fields
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing(_:))))
        scrollView.keyboardDismissMode = .onDrag
    }
    
    @objc func shareAction() {
        // 1
        guard
            let date = dateTextField.text,
            let to = toTextField.text,
            let subject = subjectTextField.text,
            let application = applicationTextField.text,
            let request = requestTextField.text,
            let from = fromTextField.text,
            let image = imagePreview.image
            
            else {
                // 2
                let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
        }
        
        // 3
        let pdfCreator = PDFCreator(fontSize: fontSize, date: date, to: to, subject: subject, application: application, request: request, from: from, image: image)
        let pdfData = pdfCreator.createFlyer()
        let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    @IBAction func fontSizeSelector(_ sender: UIButton) {
        fontSize = CGFloat(sender.tag)
        
    }
    
    @IBAction func selectImageTouched(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Select Photo", message: "Where do you want to select a photo?", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photos", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let photoPicker = UIImagePickerController()
                photoPicker.delegate = self
                photoPicker.sourceType = .photoLibrary
                photoPicker.allowsEditing = false
                
                self.present(photoPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(photoAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraPicker = UIImagePickerController()
                cameraPicker.delegate = self
                cameraPicker.sourceType = .camera
                
                self.present(cameraPicker, animated: true, completion: nil)
            }
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if
            let _ = dateTextField.text,
            let _ = toTextField.text,
            let _ = subjectTextField.text,
            let _ = applicationTextField.text,
            let _ = requestTextField.text,
            let _ = fromTextField.text,
            let _ = imagePreview.image {
            return true
        }
        
        let alert = UIAlertController(title: "All Information Not Provided", message: "You must supply all information to create a flyer.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            guard let vc = segue.destination as? PDFPreviewViewController else { return }
            
            if
                let date = dateTextField.text,
                let to = toTextField.text,
                let subject = subjectTextField.text,
                let application = applicationTextField.text,
                let request = requestTextField.text,
                let from = fromTextField.text,
                let image = imagePreview.image {
                let pdfCreator = PDFCreator(fontSize: fontSize, date: date, to: to, subject: subject, application: application, request: request, from: from, image: image)
                vc.documentData = pdfCreator.createFlyer()
            }
        }
    }
}

extension PdfBuilderViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imagePreview.image = selectedImage
        imagePreview.isHidden = false
        selectImageButton.setTitle("", for: .normal)
        
        
        dismiss(animated: true, completion: nil)
    }
}

extension PdfBuilderViewController: UINavigationControllerDelegate {
    // Not used, but necessary for compilation
}

