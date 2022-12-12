//
//  TableViewController.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/7/22.
//

import UIKit

class ProfileTVController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var imageCounter: Int = 0
    
    private var pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    private var files: [String] {
        get {
            var filesSorted: [String]
            do {
                filesSorted = try FileManager.default.contentsOfDirectory(atPath: pathToDocumentsFolder)
            }
            catch {
                filesSorted = []
                return filesSorted
            }
            return sortFiles(files: filesSorted)
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @IBAction func addPhotoButtonPushed(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = self
            present(imagePickerVC, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)

            if let image = info[.originalImage] as? UIImage {
                saveImageToDocumentDirectory(image: image)
                tableView.reloadData()
            }
        }
    
    
    func saveImageToDocumentDirectory(image: UIImage) {
        
        TextPicker.defaultPicker.showPicker(in: self) { text in
            
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsDirectory.appendingPathComponent(text)
            //        print("file URL: \(fileURL)")
            
            if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    print("file saved: \(text)")
                    try data.write(to: fileURL)
                } catch {
                    print("error saving file:", error)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    private func sortFiles(files: [String]) -> [String] {
        
        let order = UserDefaults.standard.string(forKey: "order")
        let filesSorted: [String]
        if  order == "Alphabetically" {
            filesSorted = files.sorted { (lhs: String, rhs: String) -> Bool in
                return lhs.compare(rhs, options: [.numeric], locale: .current) == .orderedAscending
            }
        } else {
            filesSorted = files.sorted { (lhs: String, rhs: String) -> Bool in
                return lhs.compare(rhs, options: [.numeric], locale: .current) == .orderedDescending
            }
        }
        return filesSorted
//        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let fullPath = pathToDocumentsFolder + "/" + files[indexPath.row]
//        print(fullPath)
        let image    = UIImage(contentsOfFile: fullPath)
        cell.imageView?.image = image
        
        let imageName = URL(filePath: fullPath).lastPathComponent
        cell.textLabel?.text = imageName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            if editingStyle == .delete {
                let fullPath = pathToDocumentsFolder + "/" + files[indexPath.row]
                do {
                    try FileManager.default.removeItem(atPath: fullPath)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("can't delete an item")
                }
                
            } else if editingStyle == .insert {
            }
    }

}
