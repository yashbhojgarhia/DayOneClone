//
//  JournalTableViewController.swift
//  Day One Clone
//
//  Created by Yash Bhojgarhia on 21/06/21.
//

import UIKit
import RealmSwift

class JournalTableViewController: UITableViewController {
    
    var entries: Results<Entry>?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var whiteCameraButton: UIButton!
    @IBOutlet weak var whitePlusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        whiteCameraButton.imageView?.contentMode = .scaleAspectFit
        whitePlusButton.imageView?.contentMode = .scaleAspectFit
        
        headerView.backgroundColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) //4cc1fc
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) //4cc1fc
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEntries()
    }

    func getEntries() {
        if let realm = try? Realm() {
            entries = realm.objects(Entry.self).sorted(byKeyPath: "date", ascending: false)
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? JournalCell {
            if let entry = entries?[indexPath.row] {
                cell.previewTextLabel.text = entry.text
                if let image = entry.pictures.first?.thumbnail() {
                    cell.imageViewWidth.constant = 100
                    cell.previewImageView.image = image
                } else {
                    cell.imageViewWidth.constant = 0
                }
                cell.dateLabel.text = entry.dayString()
                cell.monthLabel.text = entry.monthString()
                cell.yearLabel.text = entry.yearString()
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToNew", sender: "camera")
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToNew", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNew" {
            if let text = sender as? String {
                if text == "camera" {
                    let createVC = segue.destination as? CreateJournalViewController
                    createVC?.startWithCamera = true
                }
            }
        }
    }
    
}

class JournalCell: UITableViewCell {
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var previewTextLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
