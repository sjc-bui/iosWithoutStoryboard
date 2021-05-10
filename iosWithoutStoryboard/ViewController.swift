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
    let cache = NSCache<NSNumber, UIImage>()

    var athleteList = [Person]()
    var currency = [String]()
    var git_users = [User]()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        setNavigationBar()
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

    func setNavigationBar() {
        self.navigationItem.title = "Simple app"
        let btn1 = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: nil)
        let btn2 = UIBarButtonItem(title: "Count", style: .plain, target: self, action: #selector(navBarBtnClicked))
        self.navigationItem.rightBarButtonItem = btn1
        self.navigationItem.leftBarButtonItem = btn2
    }

    @objc func navBarBtnClicked() {
        let alert = UIAlertController(title: nil,
                                      message: "Table 1: \(git_users.count) records, Table 2: \(athleteList.count) records",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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

    func imageLoading(url: URL?, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .utility).async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
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
            let itemNumber = NSNumber(value: indexPath.row)
            cell.textLabel?.text = "\(user.login)"
            cell.detailTextLabel?.text = "\(user.html_url)"
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.image = UIImage(named: "placeholder.png")
            let url = URL(string: user.avatar_url)
            if let cachedImage = self.cache.object(forKey: itemNumber) {
                print("Using a cached image for item: \(itemNumber)")
                cell.imageView?.image = cachedImage
            } else {
                self.imageLoading(url: url) { [weak self] (image) in
                    guard let self = self,
                          let image = image else { return }
                    cell.imageView?.image = image
                    self.cache.setObject(image, forKey: itemNumber)
                }
            }
            returnCell = cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell2")
            let athlete = athleteList[indexPath.row]
            cell.textLabel?.text = "\(athlete.firstname) \(athlete.lastname)"
            cell.detailTextLabel?.text = "\(athlete.team)"
            returnCell = cell
        }
        returnCell.selectionStyle = .none
        return returnCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected index \(indexPath.row)")
        let detailView = DetailViewController()
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
