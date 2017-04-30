//
//  HostsTableViewController.swift
//  Concourse
//
//  Created by jberney on 4/29/17.
//  Copyright © 2017 jberney. All rights reserved.
//

import UIKit

class HostsTableViewController: UITableViewController {
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
        let index = tableView.indexPathForSelectedRow?.row
        vc.host = self.hosts[index!]
    }
}
