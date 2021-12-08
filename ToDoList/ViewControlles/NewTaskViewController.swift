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
        textFiled.placeholder = "Название задачи"
        textFiled.font = UIFont.boldSystemFont(ofSize: 20)
        return textFiled
    }()
    
    var noteTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.text = "Заметка"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        return textView
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("Отмена", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        noteTextView.delegate = self
        view.backgroundColor = .systemGray5
        setupViews()
        setupConstrains()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(parametr:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTextView(parametr:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func updateTextView (parametr: Notification) {
        let userInfo = parametr.userInfo
        
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(getKeyboardRect, to: view.window)
        
        if parametr.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = UIEdgeInsets.zero
        } else {
            noteTextView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: keyboardFrame.height / 7, right: 0.0)
            noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        }
        noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
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
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            noteTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            noteTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            
            saveButton.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor)
        ])
    }
    
    
    
    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "Загаловок пустой", message: "Пожалуйста, введите название задачи!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        
        guard let title = titleTextField.text else { return }
        guard let note = noteTextView.text else { return }
        let toDoListVc = ToDoListViewController()
        
        if isEdit {
            StorageManager.shared.edit(task: task ?? Task(), newTitle: title, newNote: note)
            isEdit = false
        } else {
            StorageManager.shared.save(title: title, note: note, done: false) { task in
                toDoListVc.currentTasks.append(task)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension NewTaskViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteTextView.becomeFirstResponder()
        noteTextView.text = ""
        return true
    }
}
