//
//  MainViewController.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func setController(_ controller: MainViewModelProtocol)
    func reloadTableView()
}

final class MainViewController: UIViewController {
    
    private var viewModel: MainViewModelProtocol?
    private var photoId: Int?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(TableCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupUI()
    }
}

private extension MainViewController {
    
    func showImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // колличество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.photos.count ?? 0
    }
    
    // установка картинок и текста
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableCell
        
        let photo = viewModel?.photos[indexPath.row]
        cell.label.text = photo?.name
        
        if let url = photo?.image {
            Task {
                if let imageData = await viewModel?.getImageData(url: url) {
                    DispatchQueue.main.async {
                        cell.image.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            cell.image.image = UIImage(named: "noImage")
        }
        
        return cell
    }
    
    // вызываем камеру при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        photoId = viewModel?.photos[indexPath.row].id
        showImagePicker()
    }
    
    // Сheck Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let controller = viewModel else { return }
        
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Проверяем, достигли ли конца таблицы и не в процессе уже пагинации
        if position > contentHeight + 50 - frameHeight && position > 0 && !controller.isPagination {
            Task {
                await controller.getPhotos(for: controller.page)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // закрытие камеры
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        guard let id = photoId else { return }
        viewModel?.sendPhoto(image: imageData, id: id)
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
    func setController(_ viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
