//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Слава Платонов on 09.10.2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var tasks: [Task] = []
    private let cell = "task"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell)
        tableView.rowHeight = 80
        view.backgroundColor = .systemGray5
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "ToDoList"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(newTask))
    }
    
    @objc private func newTask() {
        let newTaskVc = NewTaskViewController()
        newTaskVc.modalPresentationStyle = .fullScreen
        navigationController?.present(newTaskVc, animated: true)
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ToDoListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        let task = tasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newTaskVc = NewTaskViewController()
        let task = tasks[indexPath.row]
        newTaskVc.isEdit = true
        newTaskVc.task = task
        newTaskVc.modalPresentationStyle = .fullScreen
        newTaskVc.titleTextField.text = task.title
        newTaskVc.noteTextView.text = task.note
        navigationController?.present(newTaskVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task: task)
        }
    }
}
