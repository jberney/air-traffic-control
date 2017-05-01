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
        vc.concourseClient = self.concourseClient
        vc.host = self.host

        let index = tableView.indexPathForSelectedRow?.row
        vc.team = (self.teams[index!]["name"] as? String)!

        concourseClient?.getPipelines(host: vc.host) {(error, pipelines) in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            vc.pipelines = []
            let pipelinesArray = pipelines as! NSArray
            for pipeline in pipelinesArray {
                let p = pipeline as! Dictionary<String, Any>
                if (p["team_name"] as! String == vc.team) {
                    vc.pipelines.append(p)
                }
            }
            vc.pipelines.sort() {(a, b) in
                return b["name"] as! String > a["name"] as! String
            }
            
            vc.tableView?.reloadData()
        }
    }
}
