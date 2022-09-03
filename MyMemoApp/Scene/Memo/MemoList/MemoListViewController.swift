//
//  MemoListViewController.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit
import Toast

final class MemoListViewController: BaseViewController {
    
    let memoView = MemoListViewUI()
    let memoViewModel = MemoViewModel()
    let numberFormatter = NumberFormatter()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        self.view = memoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        memoViewModel.getAllData()
        memoView.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWalkThrough()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
        title = ""
    }
    
    override func configureViewController() {
        memoView.tableView.delegate = self
        memoView.tableView.dataSource = self
        memoView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reusableIdentifier)
    }
    
    override func setNavigationController() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppUIColor.gray.color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppUIColor.white.color]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: AppUIColor.white.color]
        
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
        navigationController?.view.backgroundColor = AppUIColor.black.color
        
        title = "0개의 메모"
                
        self.navigationController?.navigationBar.backgroundColor = AppUIColor.gray.color
        
        self.navigationItem.searchController = searchController
        let searchBarView = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchBarView?.textColor = AppUIColor.white.color
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.tintColor = AppUIColor.darkYellow.color
        
    }

    private func setToolbar() {
        var barItems = [UIBarButtonItem]()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbarItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonTapped(_:)))
        
        toolbarItem.tintColor = AppUIColor.darkYellow.color
        barItems.append(flexibleSpace)
        barItems.append(toolbarItem)
        memoView.toolbar.setItems(barItems, animated: true)
    }
    
    @objc func writeButtonTapped(_ sender: UIBarButtonItem) {
        presentVC(viewController: MemoEditViewController(), transitionType: .push)
    }
    
    // MARK: bindData
    override func bindData() {
        
        memoViewModel.memoData.bind { data in
            guard let data = data else { return }

            self.numberFormatter.numberStyle  = .decimal
            self.title = "\(self.numberFormatter.string(for: data.count)!)개의 메모"
            self.memoView.tableView.reloadData()
        }
        
        memoViewModel.pinnedMemoData.bind { data in
            self.memoView.tableView.reloadData()
        }
        
        memoViewModel.isSearching.bind { bool in
            self.memoView.tableView.reloadData()
        }
        
        memoViewModel.searchMemoData.bind { modelArray in
            self.memoView.tableView.reloadData()
        }
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if memoViewModel.pinnedMemoData.value?.count == 0 { return 1 }
        
        return memoViewModel.isSearching.value ? 1 : 2
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if memoViewModel.isSearching.value {
            return memoViewModel.searchMemoData.value?.count ?? 0
        }
        
        if memoViewModel.pinnedMemoData.value?.count == 0 {
            return memoViewModel.memoData.value?.count ?? 0
        }
        
        switch section {
        case TableType.pinnedMemo.rawValue:
            
            guard let pinnedMemo = memoViewModel.pinnedMemoData.value else { return 0}
            
            if pinnedMemo.count > 5 {
                self.view.makeToast(AppToastMessage.message)
                return 5
            } else {
                return pinnedMemo.count
            }
            
        case TableType.memo.rawValue:
            return memoViewModel.memoData.value?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reusableIdentifier) as? MemoListTableViewCell else { return UITableViewCell()}
        
        if memoViewModel.isSearching.value {
            guard let searchMemo = memoViewModel.searchMemoData.value, searchMemo.count != 0 else { return cell }
            
            cell.titleLabel.attributedText = setCellTitle(searchQuery: memoViewModel.searchQuery.value, memo: searchMemo[indexPath.row])
            cell.bodyLabel.attributedText = setCellContext(searchQuery: memoViewModel.searchQuery.value, memo: searchMemo[indexPath.row])
            return cell
        }

        if memoViewModel.pinnedMemoData.value?.count == 0 {
            guard let data = memoViewModel.memoData.value else { return cell}
            
            cell.titleLabel.attributedText = setCellTitle(searchQuery: "", memo: data[indexPath.row])
            cell.bodyLabel.attributedText = setCellContext(searchQuery: "", memo: data[indexPath.row])
            return cell
        }
        
        switch indexPath.section {
        case TableType.pinnedMemo.rawValue:
            
            guard let data = memoViewModel.pinnedMemoData.value else { return cell }
            cell.titleLabel.attributedText = setCellTitle(searchQuery: "", memo: data[indexPath.row])
            cell.bodyLabel.attributedText = setCellContext(searchQuery: "", memo: data[indexPath.row])
            return cell
            
        case TableType.memo.rawValue:
            
            guard let data = memoViewModel.memoData.value else { return cell }
            cell.titleLabel.attributedText = setCellTitle(searchQuery: "", memo: data[indexPath.row])
            cell.bodyLabel.attributedText = setCellContext(searchQuery: "", memo: data[indexPath.row])
            return cell
            
        default:
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reusableIdentifier) as? TableHeaderView else { return UIView()}
        
        if memoViewModel.isSearching.value {
            
            headerView.headerTitleLabel.text = "\(memoViewModel.searchMemoData.value?.count ?? 0)개 찾음"
            return headerView
        }
        
        if memoViewModel.pinnedMemoData.value?.count == 0 {
            headerView.headerTitleLabel.text = TableType.memo.sectionTitle
            return headerView
        }
        
        switch section {
        case TableType.pinnedMemo.rawValue:
            headerView.headerTitleLabel.text = TableType.pinnedMemo.sectionTitle
        case TableType.memo.rawValue:
            headerView.headerTitleLabel.text = TableType.memo.sectionTitle
        default:
            return UIView()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MemoEditViewController()
        
        if memoViewModel.isSearching.value {
            guard let searchMemo = memoViewModel.searchMemoData.value else { return }
            self.searchController.searchBar.resignFirstResponder()
            vc.isSearching = true
            vc.originalModel = searchMemo[indexPath.row]
        
        } else if memoViewModel.pinnedMemoData.value?.count == 0 {
            vc.originalModel = memoViewModel.memoData.value?[indexPath.row]
        
        } else {
            switch indexPath.section {
            case TableType.pinnedMemo.rawValue:
                vc.originalModel = memoViewModel.pinnedMemoData.value?[indexPath.row]
            case TableType.memo.rawValue:
                vc.originalModel = memoViewModel.memoData.value?[indexPath.row]
            default:
                return
            }
        }
        
        presentVC(viewController: vc, transitionType: .push)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let pin = UIContextualAction(style: .normal, title: "") { action, view, handler in
            
            self.memoViewModel.setpinned(indexPath: indexPath)
        }
        
        pin.image = setpinImage(indexPath: indexPath).withTintColor(AppUIColor.white.color)
        pin.backgroundColor = AppUIColor.yellow.color
        
        return UISwipeActionsConfiguration(actions: [pin])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "") {[weak self] action, view, handler in
            
            self?.showAlert(title: "정말 삭제하시겠습니까?", message: nil, onOK: { _ in
                self?.memoViewModel.deleteData(indexpath: indexPath)
            })
        }
        
        delete.image = AppUIImage.delete.image.withTintColor(AppUIColor.white.color)
        delete.backgroundColor = AppUIColor.red.color
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func setpinImage(indexPath: IndexPath) -> UIImage {

        if memoViewModel.pinnedMemoData.value?.count == 0 {
            guard let data = memoViewModel.memoData.value else { return UIImage() }
            return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image
        }
        
        switch indexPath.section {
        case TableType.pinnedMemo.rawValue:
            guard let data = memoViewModel.pinnedMemoData.value else { return UIImage() }
            return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image
            
        case TableType.memo.rawValue:
            guard let data = memoViewModel.memoData.value else { return UIImage() }
            return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image
        default:
            return UIImage()
        }
    }
    
}

// MARK: UISearchBarDelegate
extension MemoListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.memoViewModel.isSearching.value = true
        print(#function)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        
        self.memoViewModel.searchQuery.value = text
        self.memoViewModel.fetchData(tableType: .searchingMemo, searchQuery: text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.memoViewModel.isSearching.value = false
        self.memoViewModel.searchQuery.value = ""
        self.memoViewModel.fetchData(tableType: .searchingMemo, searchQuery: memoViewModel.searchQuery.value)
    }
}

extension MemoListViewController {
    
    fileprivate func showWalkThrough() {

//        let vc = WalkThroughView()
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overCurrentContext
//        self.present(vc, animated: true)
        
        if UserDefaults.standard.bool(forKey: WalkThroughConstant.userDefaultKey) == false {

            let vc = WalkThroughView()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
}
