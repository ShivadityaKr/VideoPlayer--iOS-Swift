//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Shivaditya Kumar on 09/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "CustomTVC", bundle: nil), forCellReuseIdentifier: "CustomTVC")
    }
    
    private func loadscreen() {
        let vc = PlayerVC.instantiate()
        present(vc, animated: true)
    }

}
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTVC") as? CustomTVC else {return UITableViewCell()}
        let data = videoData[indexPath.row]
        cell.setData(imageURL: UIImage(systemName: "photo")!, title: data["title"]!, subtitle: data["subtitle"]!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = videoData[indexPath.row]
        let videoURL = data["sources"]!
        let title = data["title"]!
        let vc = PlayerVC.instantiate()
        vc.videoURL = videoURL
        vc.videoTitle = title
        self.present(vc, animated: true, completion: nil)
    }
}

