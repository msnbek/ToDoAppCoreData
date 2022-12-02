//
//  ViewController.swift
//  ToDoAppCoreData
//
//  Created by Mahmut Senbek on 2.12.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var selectedTask = ""
    var selectedSubtitle = ""
    var selectedDescription = ""
    var selectedId : UUID?
    var taskArray = [String]()
    var subtitleArray = [String]()
    var descriptionArray = [String]()
    var idArray = [UUID]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData),  name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func getData() {
        taskArray.removeAll(keepingCapacity: false)
        subtitleArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                
                if let task = result.value(forKey: "task") as? String {
                    self.taskArray.append(task)
                }
                if let subtitle = result.value(forKey: "subtitle") as? String {
                    self.subtitleArray.append(subtitle)
                }
                if let description = result.value(forKey: "details") as? String {
                    self.descriptionArray.append(description)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.tableView.reloadData()
               
                
            }
        }catch {
            print("error")
        }
        
        
    }


    @IBAction func addButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toPlanVC", sender: nil)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = taskArray[indexPath.row]
        cell.detailTextLabel?.text = subtitleArray[indexPath.row]
        print(taskArray)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.choosenTask = selectedTask
            destinationVC.choosenSubtitle = selectedSubtitle
            destinationVC.choosenDescription = selectedDescription
            destinationVC.choosenId = selectedId
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTask = taskArray[indexPath.row]
        selectedSubtitle = subtitleArray[indexPath.row]
        selectedDescription = descriptionArray[indexPath.row]
        selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row]  {
                                context.delete(result)
                                taskArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                }catch {
                                    print("error")
                                }
                                break
                            }
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }catch {
                print("error")
            }
 
            
        }
    }
    
}
