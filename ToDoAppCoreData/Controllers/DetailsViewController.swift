//
//  DetailsViewController.swift
//  ToDoAppCoreData
//
//  Created by Mahmut Senbek on 2.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var choosenTask = ""
    var choosenSubtitle = ""
    var choosenDescription = ""
    var choosenId : UUID?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = choosenDescription
        subtitleLabel.text = choosenSubtitle
        taskLabel.text = choosenTask
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
