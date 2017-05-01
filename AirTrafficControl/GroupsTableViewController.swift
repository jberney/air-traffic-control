import UIKit

class GroupsTableViewController: UITableViewController {
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
}
