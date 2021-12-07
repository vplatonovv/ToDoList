//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Слава Платонов on 09.10.2021.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var currentTasks: [Task] = []
    var completedTasks: [Task] = []
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
        view.backgroundColor = .systemGray6
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
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let tasks):
                self.currentTasks = tasks.filter({ $0.done == false })
                self.completedTasks = tasks.filter({ $0.done == true })
                tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ToDoListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "ТЕКУЩИЕ ЗАДАЧИ" : "ВЫПОЛНЕННЫЕ ЗАДАЧИ"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath)
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        content.secondaryText = task.note
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newTaskVc = NewTaskViewController()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        newTaskVc.isEdit = true
        newTaskVc.task = task
        newTaskVc.modalPresentationStyle = .fullScreen
        newTaskVc.titleTextField.text = task.title
        newTaskVc.noteTextView.text = task.note
        navigationController?.present(newTaskVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [unowned self] _, _, _ in
            if indexPath.section == 0 {
                currentTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                StorageManager.shared.delete(task: task)
            } else {
                completedTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                StorageManager.shared.delete(task: task)
            }
        }

        let doneAction = UIContextualAction(style: .normal, title: "Готово") { [unowned self] _, _, _ in
            self.currentTasks.remove(at: indexPath.row)
            self.completedTasks.append(task)
            tableView.reloadData()
            task.done = true
            StorageManager.shared.saveContext()
        }
        
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        if indexPath.section == 0 {
            return UISwipeActionsConfiguration(actions: [doneAction, deleteAction])
        } else {
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }
}
