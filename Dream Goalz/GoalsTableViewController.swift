//
//  GoalsTableViewController.swift
//  Dream Goalz
//
//  Created by Laurie Gray on 07/02/2019.
//  Copyright © 2019 Code Disciple. All rights reserved.
//

import UIKit

class GoalsTableViewController: UITableViewController {
    
    var goals: [Goal] = []
    
    var quotes: [Quote] = []
    
    // Computed Property
    var completedGoals: [Goal] {
        return goals.filter { goal in
            return goal.isCompleted == true
        }
    }
    
    var incompleteGoals: [Goal] {
        return goals.filter { goal in
            return goal.isCompleted == false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getQuotes()
        fetchData()
    }
    
    func fetchData() {
        if let data = UserDefaults.standard.value(forKey: "UserGoals") as? Data {
            
            if let savedGoals = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Goal] {
                
                goals = savedGoals!
            }
        }
    }
    
    func saveData() {
        // Archive
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: goals, requiringSecureCoding: false)
        
        UserDefaults.standard.set(encodedData, forKey: "UserGoals")
    }
    
    @IBAction func addGoalTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Goal", message: "Enter goal details", preferredStyle: .alert)
        
        // Add action
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            
            // Unwrapping Optionals
            // Optional Chaining
            if let text = alertController.textFields?.first?.text {
                
                let newGoal = Goal(title: text)
                
                self?.goals.append(newGoal)
                
                self?.tableView.reloadData()
                
                self?.saveData()
            }

        }
        
        // Save the goals to disk
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Textfield
        alertController.addTextField(configurationHandler: nil)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // How many sections do I show?
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // What is the title for that section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Ternary operator
        
        let title = section == 0 ? "Still Pursuing" : "Achieved"
        return title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        let count = section == 0 ? incompleteGoals.count : completedGoals.count
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "goalCellID"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let cellTitle = indexPath.section == 0 ? incompleteGoals[indexPath.row].title : completedGoals[indexPath.row].title
        
        cell.textLabel?.text = cellTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let goal = indexPath.section == 0 ? incompleteGoals[indexPath.row] : completedGoals[indexPath.row]
        
        goal.isCompleted = !goal.isCompleted
        tableView.reloadSections([0, 1], with: .fade)
        
        saveData()
    }
}

// Segue handling 🤸‍♂️
extension GoalsTableViewController {
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dreamGoalsSegueId" {
            
            if let goalDetailViewController = segue.destination as? GoalDetailViewController {
                goalDetailViewController.quote = quotes.randomElement()
            }
            
        }
    }
    
    // Networking code
    func getQuotes() {
        let urlString = "https://gist.githubusercontent.com/isaacmendez/9ef13dfe10f668c2cd433ec1d99f92bc/raw/2ba4825dc64fe429c7d340b61b164d0bbdcb43b0/inspringQuotesDataModel.json"
        
        let url = URL(string: urlString)!
        
        let session = URLSession(configuration: .default)
        
        // Activate the session
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            if let downloadedData = data {
                // [Quote]
                if let quotesFromURL = try? JSONDecoder().decode([Quote].self, from: downloadedData) {
                    self.quotes = quotesFromURL
                }
            }
        }
        
        dataTask.resume()
    }
}
