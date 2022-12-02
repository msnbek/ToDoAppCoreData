//
//  AddPlanViewController.swift
//  ToDoAppCoreData
//
//  Created by Mahmut Senbek on 2.12.2022.
//

import UIKit
import CoreData

class AddPlanViewController: UIViewController {
    
    
    
    var planId : UUID?
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        if taskTextField.text != "" && subtitleTextField.text != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newBook = NSEntityDescription.insertNewObject(forEntityName: "Plan", into: context)
            
            //Attributes
            
            newBook.setValue(taskTextField.text!, forKey: "task")
            newBook.setValue(subtitleTextField.text!, forKey: "subtitle")
            newBook.setValue(descriptionTextField.text!, forKey: "details")
            newBook.setValue(UUID(), forKey: "id")
       
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Error")
            }
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
            self.navigationController?.popViewController(animated: true)
            
            let alert = UIAlertController(title: "Saved!", message: "Your plan saved.", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Accept", style: UIAlertAction.Style.default) { [self] UIAlertAction in
                performSegue(withIdentifier: "toTableView", sender: nil)
               
            }
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        
        
    }
    
 
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toTableView", sender: nil)
    }
    
}
