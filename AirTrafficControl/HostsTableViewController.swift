import UIKit

class HostsTableViewController: UITableViewController {
    let concourseClient = ConcourseClient(jsonClient: JsonClient(httpClient: HttpClient()))
    var hosts: [String] = ["p-concourse.wings.cf-app.com"]

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
        vc.concourseClient = self.concourseClient

        let index = tableView.indexPathForSelectedRow?.row
        vc.host = self.hosts[index!]

        concourseClient.getTeams(host: vc.host) {(error, teams) in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            vc.teams = teams as! [Dictionary<String, Any>]
            vc.teams.sort() {(a, b) in
                return b["name"] as! String > a["name"] as! String
            }

            vc.tableView?.reloadData()
        }
    }
}
