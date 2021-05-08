//
//  ViewController.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/08.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!

    let url = "http://data.fixer.io/api/latest"
    let accessKey = "8ef64676f4bca80be997020a5936255b"
    let base = "EUR"

    var currency = [String]()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

        tableView.delegate = self
        tableView.dataSource = self

        let params = ["access_key": accessKey, "base": base]
        getCurrency(url: url, params: params)
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

    func getCurrency(url: String, params: [String: String]) {
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonData: JSON = JSON(response.data!)
                self.updateTableData(data: jsonData)
                print(value)
            case .failure(let error):
                print(error)
            }
            self.tableView.reloadData()
        }
    }

    func updateTableData(data: JSON) {
        for (name, price) in data["rates"] {
            let cur = "\(name) \(price)"
            currency.append(cur)
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currency.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        //cell.imageView?.image = UIImage(named: "swift")
        cell.textLabel?.text = currency[indexPath.row]
        cell.detailTextLabel?.text = "Currency"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
