//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Слава Платонов on 09.10.2021.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    var isEdit = false
    var task: Task? = nil
    
    var titleTextField: UITextField = {
        let textFiled = UITextField()
        textFiled.borderStyle = .roundedRect
        textFiled.placeholder = "Call the task"
        textFiled.font = UIFont.boldSystemFont(ofSize: 20)
        return textFiled
    }()
    
    var noteTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.text = "Note..."
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        return textView
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
        titleTextField.delegate = self
        noteTextView.delegate = self
        view.backgroundColor = .systemGray5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(titleTextField)
        view.addSubview(noteTextView)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
    
    private func setupConstrains() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        noteTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        noteTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
        noteTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 40).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
        
        cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
    }
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        guard let title = titleTextField.text else { return }
        guard let note = noteTextView.text else { return }
        let toDoListVc = ToDoListViewController()
        
        if isEdit {
            StorageManager.shared.edit(task: task ?? Task(), newTitle: title, newNote: note)
            isEdit = false
        } else {
            StorageManager.shared.save(title: title, note: note) { task in
                toDoListVc.tasks.append(task)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension NewTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextView.becomeFirstResponder()
        noteTextView.text = nil
        return true
    }
}
