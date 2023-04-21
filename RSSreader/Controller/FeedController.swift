//
//  ViewController.swift
//  RSSreader
//
//  Created by ibrahim uysal on 13.04.2023.
//

import UIKit
import SafariServices

private let reuseIdentifier = "FeedCell"

final class FeedController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private let refresher = UIRefreshControl()
    private var feedArray: [Feed] = [] { didSet { tableView.reloadData() } }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Selectors
    
    @objc private func handleRefresh() {
        fetchData()
        refresher.endRefreshing()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "bloomberght"
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(FeedCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher

        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    private func fetchData() {
        let rssAddress = "https://www.bloomberght.com/rss"
        
        if let url = URL(string: rssAddress) {
            if let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as? XmlParserManager {
                let itemArray = myParser.feeds
                
                for item in itemArray {
                    let title = (item as AnyObject).object(forKey: "title") as? String ?? ""
                    let link = (item as AnyObject).object(forKey: "link") as? String ?? ""
                    let description = (item as AnyObject).object(forKey: "description") as? String ?? ""
                    let pubDate = (item as AnyObject).object(forKey: "pubDate") as? String ?? ""
                    
                    let feed = Feed(title: title, link: link, description: description, pubDate: pubDate)
                    feedArray.append(feed)
                }
            }
        }
    }
    
    private func size(forText text: String?) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.setWidth(view.frame.width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

//MARK: - UITableViewDataSource

extension FeedController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.feed = feedArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = feedArray[indexPath.row].title
        let sizeHeight = size(forText: text).height
        return sizeHeight+32
    }
}

//MARK: - UITableViewDelegate

extension FeedController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedFeedURL = feedArray[indexPath.row].link
        
        selectedFeedURL =  selectedFeedURL.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL.replacingOccurrences(of: "\n", with:"")
        selectedFeedURL =  selectedFeedURL.replacingOccurrences(of: "\t", with:"")

        guard let url = URL(string: selectedFeedURL) else {return}
        let sfVc = SFSafariViewController(url:url)
        self.present(sfVc, animated: true, completion: nil)
    }
}
