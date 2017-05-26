//
//  ViewController.swift
//  ContactsDemo
//
//  Created by Bansi on 23/05/17.
//
//
//http://www.appcoda.com/ios-contacts-framework/
import UIKit
import ContactsUI




class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,fetchContactDelegate {

    @IBOutlet var tblContact : UITableView!
    var arrContacts : [CNContact]?
    var contactStore = CNContactStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllContacts()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: "AddContact"), object: nil, queue: OperationQueue.main) { (notification) in
                self.fetchAllContacts()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    func getContacts() {
        let store = CNContactStore()
        self.retrieveContactsWithStore(store: store)
        /* if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
                if authorized {
                    self.retrieveContactsWithStore(store: store)
                }
            } as! (Bool, Error?) -> Void)
        } else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContactsWithStore(store: store)
        }*/
    }
    func retrieveContactsWithStore(store: CNContactStore) {
        do {
            let groups = try store.groups(matching: nil)
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            //self.arrContacts?.addObjects(from: contacts)
            DispatchQueue.main.async(execute: { () -> Void in
                self.tblContact.reloadData()
            })
        } catch {
            print(error)
        }
    }
    func fetchAllContacts(){
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                   
                } catch {
                    print("Error fetching results for container")
                }
            }
            return results
        }()
        arrContacts = contacts
        //print(contacts)
        if arrContacts != nil {
            self.tblContact.delegate = self
            self.tblContact.dataSource = self
            self.tblContact.reloadData()
        }
    }
    
   func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            //self.showMessage(message)
                            
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    //MARK:- TableView Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        if arrContacts != nil && arrContacts!.count > indexPath.row{
            let contact = arrContacts![indexPath.row]
            
            cell.lblContactName.text = "\(contact.namePrefix) \(contact.nameSuffix)"
            cell.lblContactPhone.text = "\(contact.phoneNumbers[0].value.stringValue)"
            //cell.lblContactEmail.text = "\(contact.emailAddresses[0].value)"
            if contact.imageDataAvailable{
                
                cell.imgContact.image = UIImage(data: contact.thumbnailImageData!)
            }
            
            
        }

       // print("entry \(entry ?? "" )")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = arrContacts?.count{
            print("array count is \(String(describing: arrContacts?.count))")
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: CreateContactVC.self) == true {
            let addController = segue.destination as! CreateContactVC
            addController.myParent = self
        }
    }

}

