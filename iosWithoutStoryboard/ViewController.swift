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

//    let url = "http://data.fixer.io/api/latest"
//    let accessKey = "8ef64676f4bca80be997020a5936255b"
//    let base = "EUR"

    let gitURL = "https://api.github.com/users"

    var athleteList = [Person]()
    var currency = [String]()
    var git_users = [User]()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

        tableView.delegate = self
        tableView.dataSource = self

//        let params = ["access_key": accessKey, "base": base]
//        getCurrency(url: url, params: params)
//        jsonFromFile()

        getGithubUsers(url: gitURL)
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

    func getGithubUsers(url: String) {
        AF.request(url, method: .get).responseJSON { (res) in
            switch res.result {
            case .success( _):
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode([User].self, from: res.data!) else { return }
                self.git_users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func getCurrency(url: String, params: [String: String]) {
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let jsonData: JSON = JSON(value)
                self.updateTableData(data: jsonData)
//                print(value)
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

    func jsonFromFile() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "json") else {
            print("error")
            return
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            athleteList = try decoder.decode([Person].self, from: jsonData)
        } catch {
            print("error!")
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return git_users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let user = git_users[indexPath.row]
        cell.textLabel?.text = "\(user.login)"
        cell.detailTextLabel?.text = "\(user.html_url)"
        cell.accessoryType = .disclosureIndicator
        let url = URL(string: user.avatar_url)
        cell.imageView?.loadImageAsync(url: nil)
        cell.selectionStyle = .none
        return cell
    }
}
