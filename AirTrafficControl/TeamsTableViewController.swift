import UIKit

class TeamsTableViewController: UITableViewController {
    var concourseClient: ConcourseClient? = nil
    var host: String = ""
    var teams: [Dictionary<String, Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
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
        let vc = segue.destination as! PipelinesTableViewController
        let index = tableView.indexPathForSelectedRow?.row
        vc.host = self.host
        vc.team = (self.teams[index!]["name"] as? String)!

        concourseClient?.getPipelines(host: vc.host) {(error, pipelines) in
            if (error == nil) {
                vc.pipelines = []
                let pipelinesArray = pipelines as! NSArray
                for pipeline in pipelinesArray {
                    let p = pipeline as! Dictionary<String, Any>
                    if (p["team_name"] as! String == vc.team) {
                        vc.pipelines.append(p)
                    }
                }
            }
            vc.tableView?.reloadData()
        }
    }
}
