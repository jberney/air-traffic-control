import UIKit

class TeamsTableViewController: UITableViewController {
    var teams: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let httpClient = HttpClient()
        let jsonClient = JsonClient(httpClient: httpClient)
        let concourseClient = ConcourseClient(jsonClient: jsonClient)
        concourseClient.getTeams(host: "p-concourse.wings.cf-app.com") {(error, teams) in
            if (error == nil) {
                self.teams = teams as! [Dictionary<String, Any>]
            }
            self.tableView?.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = teams[indexPath.row]["name"] as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARING")
           }
}
