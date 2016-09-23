//
//  ViewController.swift
//  RxSchmidt
//
//  Created by Malte Bünz on 23/09/16.
//  Copyright © 2016 mbnz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.observeSearchBar()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cityCell")
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}

import RxCocoa
import RxSwift

extension ViewController {
    
    func observeSearchBar() {
        self.searchBar
            .rx.text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.characters.count > 0 }
            .subscribe { [unowned self](query) in
                self.shownCities = self.allCities.filter { $0.hasPrefix(query.element!) }
                self.tableView.reloadData()
        }
        .addDisposableTo(self.disposeBag)
    }
}

