//
//  ViewController.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/08.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!

    let characters = ["東京", "名古屋", "大阪", "宮城", "広島", "川崎", "沖縄"]

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        tableView.delegate = self
        tableView.dataSource = self
        setTableView()
    }

    func setTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = characters[indexPath.row]
        cell.detailTextLabel?.text = "detail text"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
