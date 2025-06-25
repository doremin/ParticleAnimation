//
//  ViewController.swift
//  ParticleAnimation
//
//  Created by doremin on 6/25/25.
//

import UIKit

final class ViewController: UIViewController {
    
    private enum Destination: Int, CaseIterable {
        case particle = 0
        case emitter
        
        var info: (title: String, target: UIViewController) {
            switch self {
            case .particle:
                return ("Particle", ParticleViewController())
            case .emitter:
                return ("Emitter", EmitterViewController())
            }
        }
    }
    
    private static let cellReuseIdentifier = "cell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.cellReuseIdentifier)
        return tableView
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, Destination> = {
        UITableViewDiffableDataSource<Int, Destination>(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellReuseIdentifier) else {
                return nil
            }
            var config = cell.defaultContentConfiguration()
            config.text = item.info.title
            cell.contentConfiguration = config
            return cell
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(tableView)
        
        makeConstraints()
        loadDestinations()
    }
    
    private func loadDestinations() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(Destination.allCases)
        dataSource.apply(snapshot)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let target = Destination(rawValue: indexPath.row)?.info.target else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(target, animated: true)
    }
}
