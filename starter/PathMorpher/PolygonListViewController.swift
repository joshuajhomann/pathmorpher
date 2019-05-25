//
//  ViewController.swift
//  PathMorpher
//
//  Created by Joshua Homann on 5/24/19.
//  Copyright © 2019 com.josh. All rights reserved.
//

import UIKit

class PolygonListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private var polygons: [Polygon] = []
    private var indexPathForEdit: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = editButtonItem
        polygons = FileService
            .urls
            .filter { $0.pathExtension == "json"}
            .compactMap { try? FileService.read(type: Polygon.self, from: $0.lastPathComponent) }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        if editing && !tableView.isEditing {
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destination as EditPolygonViewController:
            indexPathForEdit = (sender as? UIButton)
                .flatMap { $0.firstParent(ofType: UITableViewCell.self) }
                .flatMap { tableView.indexPath(for: $0) }
            destination.polygon = indexPathForEdit.map { polygons[$0.row] }
        case let destination as MorphViewController:
            destination.paths = tableView
                .indexPathsForSelectedRows
                .map { $0.map {polygons[$0.row].path.cgPath} } ?? []

        default:
            break
        }
    }
    @IBAction func unwindEdit(_ segue: UIStoryboardSegue) {
        switch segue.source {
        case let source as EditPolygonViewController:
            if let indexpath = indexPathForEdit {
                polygons[indexpath.row] = source.polygon
                tableView.reloadRows(at: [indexpath], with: .automatic)
                try? FileService.write(source.polygon, to: source.polygon.filename)
            } else {
                polygons.append(source.polygon)
                tableView.insertRows(at: [IndexPath(row: polygons.indices.last ?? 0, section: 0)], with: .automatic)
                try? FileService.write(source.polygon, to: source.polygon.filename)
            }
        default:
            break
        }
    }
}

extension PolygonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            .init(style: .destructive, title: "Delete") { action, view, completion in
                try? FileService.delete(filename: self.polygons[indexPath.row].filename)
                self.polygons.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
                },
            .init(style: .normal, title: "Clone") { action, view, completion in
                self.polygons.insert(self.polygons[indexPath.row], at: indexPath.row)
                tableView.insertRows(at: [indexPath], with: .automatic)
                try? FileService.write(self.polygons[indexPath.row], to: self.polygons[indexPath.row].filename)
                completion(true)
            }
        ])
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        polygons.insert(polygons.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }

}

extension PolygonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PolygonListTableViewCell.self), for: indexPath)
        (cell as? PolygonListTableViewCell)?.configure(with: polygons[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return polygons.count
    }
}
