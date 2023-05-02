import UIKit

extension UITableViewCell {
    // swiftlint:disable:next identifier_name
    @objc static var dm_defaultIdentifier: String { return String(describing: self) }
}

extension UITableView {
    
    func dm_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.dm_defaultIdentifier)
    }
    
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T? {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: T.dm_defaultIdentifier) as? T
    }
    
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withIdentifier: T.dm_defaultIdentifier, for: indexPath) as? T
    }
    
}

extension UICollectionViewCell {
    // swiftlint:disable:next identifier_name
    @objc static var dm_defaultIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func dm_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.dm_defaultIdentifier)
    }
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UICollectionViewCell>(for indexPath:IndexPath) -> T? {
        // swiftlint:disable:next force_cast
        return dequeueReusableCell(withReuseIdentifier: T.dm_defaultIdentifier, for: indexPath) as? T
    }
}
