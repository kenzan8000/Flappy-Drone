/// MARK: - LOG

/**
 * display log
 * @param body log
 */
func FDLOG(body: Any) {
    print(body)
}


/// MARK: - function

/**
 * return class name
 * @param classType classType
 * @return class name
 */
func FDNSStringFromClass(classType:AnyClass) -> String {
    let classString = NSStringFromClass(classType.self)
    let range = classString.rangeOfString(".", options: NSStringCompareOptions.CaseInsensitiveSearch, range: Range<String.Index>(start:classString.startIndex, end: classString.endIndex), locale: nil)
    return classString.substringFromIndex(range!.endIndex)
}


/// MARK: - notification center

struct FDNotificationCenter {
    /// called when drone is discovered
    static let ARDiscoveryNotificationServicesDevicesListUpdated = kARDiscoveryNotificationServicesDevicesListUpdated
}
