//
//  Contact.swift
//  ContactsDemo
//
//  Created by Zeitech Solutions on 24/05/17.
//
//

import UIKit
import AddressBook
import Contacts

class Contact: NSObject {
   
    var firstName : String?
    var lastName : String?
    var name : String?
    var number : Int?
    var email : String?
    var image : UIImage?
    
    init(firstName : String?,lastName : String?,number : Int?,email : String?,image : UIImage?) {
        self.firstName = firstName
        self.lastName = lastName
        self.number = number
        self.email = email
        self.image = image
    }
    init(name : String?,number : Int?,email : String?,image : UIImage?) {
        
        self.name = name
        self.number = number
        self.email = email
        self.image = image
    }
   
    
    @available(iOS 9.0, *)
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.name = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
        // image
        self.image = (cnContact.isKeyAvailable(CNContactImageDataKey) && cnContact.imageDataAvailable) ? UIImage(data: cnContact.imageData!) : nil
        // email
        if cnContact.isKeyAvailable(CNContactEmailAddressesKey) {
            for possibleEmail in cnContact.emailAddresses {
                let properEmail = possibleEmail.value as String
               // if properEmail.isEmail() { self.email = properEmail; break }
            }
        }
        // phone
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
               // self.number = phone
            }
        }
    }

}
