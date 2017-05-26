//
//  CreateContactVC.swift
//  ContactsDemo
//
//  Created by Zeitech Solutions on 24/05/17.
//
//

import UIKit
import AddressBook
import Contacts

protocol fetchContactDelegate {
    func fetchAllContacts()
}

class CreateContactVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    


    @IBOutlet var imgContact: UIImageView!
    @IBOutlet  var txtFirstName: UITextField!
    @IBOutlet  var txtLastName: UITextField!
    @IBOutlet  var txtEmail: UITextField!
    @IBOutlet  var txtPhone: UITextField!
    @IBOutlet  var btnAdd : UIButton!
    
    
    var myParent : fetchContactDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgContact.isUserInteractionEnabled = true
        imgContact .addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        
        // Create a UiPickerContoller
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "", message: "Choose a Photo", preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imgContact.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addContact(_ sender : UIButton!){
        
        if (txtFirstName.text?.characters.count)! > 0 || (txtLastName.text?.characters.count)! > 0 || (txtEmail.text?.characters.count)! > 0 || (txtPhone.text?.characters.count)! > 0{
           
    if let number = txtPhone.text ,number.characters.count > 10{
                showAlertMessage("Number be of 10 digit")
    }else{
        self.createCNContactWithFirstName(firstName: txtFirstName.text!, lastName: txtLastName.text!, email: txtEmail.text, phone: txtPhone.text, image: imgContact.image)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //my One
   func createCNContactWithFirstName(firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?) {
        // create contact with mandatory values: first and last name
        let newContact = CNMutableContact()
        newContact.givenName = firstName
        newContact.familyName = lastName
        
        // email
        if email != nil {
            let contactEmail = CNLabeledValue(label: CNLabelHome, value: email! as NSString)
            newContact.emailAddresses = [contactEmail]
        }
        // phone
        if phone != nil {
            let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
            newContact.phoneNumbers = [contactPhone]
        }
        
        // image
        if image != nil {
            newContact.imageData = UIImageJPEGRepresentation(image!, 0.9)
        }
        
        do {
            let newContactRequest = CNSaveRequest()
            newContactRequest.add(newContact, toContainerWithIdentifier: nil)
            try CNContactStore().execute(newContactRequest)
            
         
            
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "AddContact"), object: nil)
            
             myParent?.fetchAllContacts()
            
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            self.showAlertMessage("I was unable to create the new contact. An error occurred.")
        }
    }
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
