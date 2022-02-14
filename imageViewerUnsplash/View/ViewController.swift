//
//  ViewController.swift
//  imageViewerUnsplash
//
//  Created by Роман on 06.02.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    var itemsImage:[Result] = []
    private var collectionView: UICollectionView?
    let searchBar = UISearchBar()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        interface()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10.0,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width - 20,
                                 height: 50.0)
        collectionView?.frame = CGRect(x: 0,
                                       y: view.safeAreaInsets.top + 55,
                                       width: view.frame.size.width,
                                       height: view.frame.size.height - 55)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = itemsImage[indexPath.row].urls.small
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsCollectionViewCell.identifier,
                                                            for: indexPath)
                                                            as? ItemsCollectionViewCell else {return UICollectionViewCell()}
        cell.config(with: imageURLString)
        return cell
    }
    
    func fetchPhoto(_ query: String) {
        let urlString = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(query)&client_id=\(key)"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { [weak self]data, _, error in
            guard let data = data else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(Images.self, from: data)
                DispatchQueue.main.async {
                    self?.itemsImage = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func interface(){
        let collectionViewLayout = UICollectionViewFlowLayout()
        searchBar.delegate = self
        view.addSubview(searchBar)
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = .zero
        collectionViewLayout.minimumInteritemSpacing = .zero
        collectionViewLayout.itemSize = CGSize(width: view.frame.width / 2,
                                               height: view.frame.width / 2)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        collectionView.register(ItemsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ItemsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        if let text = searchBar.text{
            itemsImage = []
            collectionView?.reloadData()
            fetchPhoto(text)
        }
        
    }
    
}

 
