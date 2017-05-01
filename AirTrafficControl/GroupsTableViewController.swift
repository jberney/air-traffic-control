import UIKit

class GroupsTableViewController: UITableViewController {
    var concourseClient: ConcourseClient? = nil
    var host: String = ""
    var team: String = ""
    var pipeline: String = ""
    var groups: [Dictionary<String, Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row]["name"] as? String
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! JobsTableViewController
        vc.host = self.host
        vc.team = self.team
        vc.pipeline = self.pipeline

        let index = tableView.indexPathForSelectedRow?.row
        vc.group = (self.groups[index!]["name"] as? String)!

        concourseClient?.getJobs(host: vc.host, team: vc.team, pipeline: vc.pipeline) {(error, jobs) in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }

            vc.jobs = []
            let jobsArray = jobs as! NSArray
            for job in jobsArray {
                let j = job as! Dictionary<String, Any>
                let groups = j["groups"] as! NSArray
                if (groups.contains(vc.group)) {
                    vc.jobs.append(j)
                }
            }
            
            vc.tableView?.reloadData()
        }
    }
}
