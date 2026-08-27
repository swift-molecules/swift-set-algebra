public import Set_Algebra
public import Iterator_Chunk

public struct Fixture<Element: Hash.`Protocol` & Copyable> {
    @usableFromInline
    var elements: [Element]

    @inlinable
    public init(_ elements: some Swift.Sequence<Element>) {
        var unique: [Element] = []
        for element in elements where !unique.contains(where: { $0 == element }) {
            unique.append(element)
        }
        self.elements = unique
    }
}

extension Fixture: Membership {
    @inlinable
    public func contains(_ element: borrowing Element) -> Bool {
        let needle = copy element
        return elements.contains(where: { $0 == needle })
    }

    @inlinable
    public var count: Index<Element>.Count {
        Index<Element>.Count(Cardinal(Swift.UInt(elements.count)))
    }
}

extension Fixture: Iterable {
    @_implements(Iterable, Iterator)
    public typealias IterableIterator = Iterator_Chunk.Iterator.Chunk<Element>

    @_lifetime(borrow self)
    @inlinable
    public borrowing func makeIterator() -> Iterator_Chunk.Iterator.Chunk<Element> {
        Iterator_Chunk.Iterator.Chunk(elements.span)
    }
}

extension Fixture: Buildable {
    @inlinable
    public init() {
        self.elements = []
    }

    @inlinable
    public mutating func add(_ element: consuming Element) {
        let needle = copy element
        guard !elements.contains(where: { $0 == needle }) else { return }
        elements.append(element)
    }
}
