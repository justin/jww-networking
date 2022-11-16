import Foundation

typealias Path = URL.Path

/// Protocol that defines the values that can be extracted from a path component.
protocol PathComponent {
    /// A string representation of a path component. This omits the leading "/" separator.
    var stringValue: String { get }

    /// A valid path value that can be passed into `URLComponents`.
    var pathValue: String { get }
}

extension URL {
    /// An object that supports building the path piece of a URL from an array of different components.
    struct Path: Equatable {
        /// The separator between each path component.
        fileprivate static let separator = "/"

        /// Array of components that a part of the generated path.
        private let components: [PathComponent]

        /// Create and return a new `Path` object.
        ///
        /// - Parameter path: Array of path components.
        init(_ path: PathComponent...) {
            self.init(path)
        }

        /// Create and return a new `Path` object.
        ///
        /// - Parameter path: Array of path components.
        init(_ path: [PathComponent]) {
            let adjusted: [PathComponent] = path.map({ component in
                guard component.stringValue.hasPrefix(Path.separator) else {
                    return component
                }

                return String(component.stringValue.dropFirst())
            })

            self.components = adjusted
        }

        /// Append an additional component to an existing path.
        ///
        /// - Parameter path: The path component to append.
        func appending(_ path: PathComponent...) -> Path {
            Path(self.components + path)
        }

        static func + (lhs: Path, rhs: Path) -> Path {
            Path(lhs.components + rhs.components)
        }

        static func == (lhs: URL.Path, rhs: URL.Path) -> Bool {
            lhs.pathValue == rhs.pathValue
        }
    }
}

// MARK: Collection + Sequence Conformance
// ========================================
// Collection + Sequence Conformance
// ========================================
extension Path: Collection {
    typealias Element = PathComponent
    typealias Iterator = AnyIterator<Element>

    func makeIterator() -> Iterator {
        var iterator = components.makeIterator()

        return AnyIterator {
            return iterator.next()
        }
    }

    var startIndex: Int {
        components.startIndex
    }

    var endIndex: Int {
        components.endIndex
    }

    subscript(position: Int) -> Element {
        components[position]
    }

    // swiftlint:disable:next identifier_name
    func index(after i: Int) -> Int {
        components.index(after: i)
    }
}

// MARK: PathComponent Conformances
// ====================================
// PathComponent Conformances
// ====================================
extension Path: PathComponent {
    var stringValue: String {
        components
            .map(\.stringValue)
            .joined(separator: Path.separator)
    }

    var pathValue: String {
        components
            .map(\.pathValue)
            .joined()
    }
}

extension String: PathComponent {
    var stringValue: String {
        return self
    }
}

extension Int: PathComponent {
    var stringValue: String {
        String(describing: self)
    }
}

extension PathComponent {
    var pathValue: String {
        let pathValue: String
        switch stringValue {
        case _ where stringValue.isEmpty:
            pathValue = ""
        default:
            pathValue = Path.separator + stringValue
        }

        return pathValue
    }
}
