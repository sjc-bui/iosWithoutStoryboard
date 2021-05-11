//
//  DetailViewController.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/10.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    let backBtn = UIButton()
    let nextBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        setView()
    }

    func setView() {
        backBtn.setTitle("戻る", for: .normal)
        backBtn.backgroundColor = .systemBlue
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        backBtn.layer.cornerRadius = 4
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)

        nextBtn.setTitle("次へ", for: .normal)
        nextBtn.backgroundColor = .systemBlue
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        nextBtn.layer.cornerRadius = 4

        view.addSubview(backBtn)
        view.addSubview(nextBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false

        backBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34).isActive = true
        backBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
        nextBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -34).isActive = true
        nextBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nextBtn.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }

    @objc func backBtnClicked() {
        print("back button clicked")
        self.navigationController?.popViewController(animated: false)
    }
}
