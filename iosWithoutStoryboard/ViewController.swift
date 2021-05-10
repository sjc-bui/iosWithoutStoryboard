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

    let firstTbView = UITableView()
    let secondTbView = UITableView()
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

        firstTbView.delegate = self
        firstTbView.dataSource = self

        secondTbView.delegate = self
        secondTbView.dataSource = self

//        let params = ["access_key": accessKey, "base": base]
//        getCurrency(url: url, params: params)
        jsonFromFile()

        getGithubUsers(url: gitURL)
        setTableView()
    }

    func setTableView() {
        view.addSubview(firstTbView)
        view.addSubview(secondTbView)
        firstTbView.translatesAutoresizingMaskIntoConstraints = false
        secondTbView.translatesAutoresizingMaskIntoConstraints = false

        firstTbView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        firstTbView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstTbView.bottomAnchor.constraint(equalTo: secondTbView.topAnchor).isActive = true
        firstTbView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstTbView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2).isActive = true
        firstTbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        secondTbView.topAnchor.constraint(equalTo: firstTbView.bottomAnchor).isActive = true
        secondTbView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        secondTbView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        secondTbView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        secondTbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
    }

    func getGithubUsers(url: String) {

        AF.request(url, method: .get).responseJSON { (res) in
            switch res.result {
            case .success( _):
                let decoder = JSONDecoder()
                guard let users = try? decoder.decode([User].self, from: res.data!) else { return }
                self.git_users = users
                DispatchQueue.main.async {
                    self.firstTbView.reloadData()
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
            case .failure(let error):
                print(error)
            }
            self.firstTbView.reloadData()
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
            self.secondTbView.reloadData()
        } catch {
            print("error!")
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == firstTbView {
            return git_users.count
        }
        return athleteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == firstTbView {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let user = git_users[indexPath.row]
            cell.textLabel?.text = "\(user.login)"
            cell.detailTextLabel?.text = "\(user.html_url)"
            cell.accessoryType = .disclosureIndicator
//            let url = URL(string: user.avatar_url)
            cell.imageView?.loadImageAsync(url: nil)
            cell.selectionStyle = .none
            returnCell = cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell2")
            let athlete = athleteList[indexPath.row]
            cell.textLabel?.text = "\(athlete.firstname) \(athlete.lastname)"
            cell.detailTextLabel?.text = "\(athlete.team)"
            cell.selectionStyle = .none
            returnCell = cell
        }
        return returnCell
    }
}
