import UIKit

class PipelinesTableViewController: UITableViewController {
    var concourseClient: ConcourseClient? = nil
    var host: String = ""
    var team: String = ""
    var pipelines: [Dictionary<String, Any>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pipelines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = pipelines[indexPath.row]["name"] as? String
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! GroupsTableViewController
        vc.concourseClient = self.concourseClient
        vc.host = self.host
        vc.team = self.team

        let index = tableView.indexPathForSelectedRow?.row
        vc.pipeline = (self.pipelines[index!]["name"] as? String)!
        vc.groups = self.pipelines[index!]["groups"] as! [Dictionary<String, Any>]
        
        vc.tableView?.reloadData()
    }
}
