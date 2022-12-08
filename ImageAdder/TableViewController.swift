//
//  TableViewController.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/7/22.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var imageCounter: Int = 0
    
    private var pathToDocumentsFolder = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    private var files: [String] {
        get {
            (try? FileManager.default.contentsOfDirectory(atPath: pathToDocumentsFolder)) ?? []
        }
        set {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Documents"
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {

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
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = "image_" + "\(imageCounter)" + ".jpg"
        imageCounter += 1
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        print("file path: \(fileURL)")

                
        if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                print("file saved: \(fileName)")
                try data.write(to: fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
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
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
