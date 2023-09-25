//
//  MainViewModel.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import Foundation

protocol MainViewModelProtocol {
    var photos: [PhotoTypeDtoOut.PhotoDtoOut] { get set }
    var page: Int { get set }
    var isPagination: Bool { get set }
    
    func getPhotos(for page: Int) async
    func getImageData(url: String) async -> Data?
    func sendPhoto(image: Data, id: Int)
}

final class MainViewModel: MainViewModelProtocol {
    
    private var userName = "Artem Nikitin"
    
    private weak var view: MainViewControllerProtocol?
    private var networkService = NetworkService()
    private var maxPages: Int?
    
    private var path = "/api/v2/photo/type"
    private var pathToUpload = "/api/v2/photo"
    
    var photos: [PhotoTypeDtoOut.PhotoDtoOut] = []
    var page = 0
    var isPagination: Bool = false
    
    init(view: MainViewControllerProtocol?) {
        self.view = view
        
        Task {
            await getPhotos(for: page)
            
            DispatchQueue.main.async {
                view?.reloadTableView()
            }
        }
    }
    
    func getPhotos(for page: Int) async {
        // Проверяем, активна ли уже пагинация, чтобы избежать дублирования запросов
        guard !isPagination else { return }
        
        // Проверяем, не достигнут ли максимальный номер страницы
        guard maxPages == nil || page < maxPages ?? 0 else { return }
        
        // Устанавливаем флаг пагинации
        isPagination = true
        
        // Асинхронно получаем данные
        if let newPage: PhotoTypeDtoOut = await networkService.fetchData(path: path, page: String(page)) {
            // Добавляем новые фотографии в массив
            photos.append(contentsOf: newPage.content)
            
            // Обновляем таблицу на главном потоке
            DispatchQueue.main.async {
                self.view?.reloadTableView()
            }
            
            // Обновляем информацию о максимальном количестве страниц и номере текущей страницы
            self.maxPages = newPage.totalPages
            self.page += 1
        }
        
        // Снимаем флаг пагинации
        isPagination = false
    }

    func getImageData(url: String) async -> Data? {
        do {
            return try await networkService.getAllImage(url: url)
        } catch {
            return nil
        }
    }
    
    func sendPhoto(image: Data, id: Int) {
        let parameters: [String: Any] = [
            "name": self.userName,
            "photo": image,
            "typeId": String(id)
        ]
        networkService.sendPhotoToServer(id: id, path: pathToUpload, parameters: parameters)
    }
}
