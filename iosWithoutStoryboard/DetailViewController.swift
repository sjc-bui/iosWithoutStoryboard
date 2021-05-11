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
        self.navigationItem.title = "注文数を確認する"
        setView()
    }

    func setView() {
        backBtn.RoundAndWeight(title: "戻る", size: 20, style: .bold, background: .systemBlue)
        nextBtn.RoundAndWeight(title: "次へ", size: 20, style: .bold, background: .systemBlue)
        backBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)

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
