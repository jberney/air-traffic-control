import UIKit

class HostsTableViewController: UITableViewController {
    var hosts: [String] = ["p-concourse.wings.cf-app.com"]
    let concourseClient = ConcourseClient(jsonClient: JsonClient(httpClient: HttpClient()))

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = hosts[indexPath.row]
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TeamsTableViewController
        let index = tableView.indexPathForSelectedRow?.row
        vc.host = self.hosts[index!]
        
        concourseClient.getTeams(host: vc.host) {(error, teams) in
            if (error == nil) {
                vc.teams = teams as! [Dictionary<String, Any>]
            }
            vc.tableView?.reloadData()
        }
    }
}
