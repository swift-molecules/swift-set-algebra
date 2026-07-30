// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Set_Algebra_Primitives
public import Iterator_Chunk_Primitives

// MARK: - Fixture (top-level; not nested under `Set`)
//
// `Set` is the [DS-028] generic front-door `typealias` (`Set.FrontDoor.swift`
// in swift-set-primitives): `public typealias Set<E: Hash.Key & ~Copyable> =
// __Set<Hash.Indexed<...<E>>>`. Its own declared generic parameter is `E`, and
// the type it actually aliases (`__Set<S: ~Copyable>`) is generic over the
// storage column `S`, not over an element at all — `E` only appears nested
// inside `S`'s bound argument. Swift's member-type lookup does not look
// through an unbound generic typealias on any toolchain
// (swift-institute/Issues#81), so an `extension Set where ...` / `extension
// Set.Fixture` pair can never resolve, regardless of which parameter name the
// where-clause spells: there is no reachable `Set` namespace to nest a type
// or a conformance into. This is the same defect class that moved
// `Membership` off the nested `Set.Protocol` spelling onto a top-level name
// (W1/W2, swift-institute/.github#122) — see `Set.Protocol.swift`'s "Why this
// is a top-level name, not a nested `Set.Protocol`" note in
// swift-set-primitives. `Fixture` follows the same precedent: it stays
// top-level here instead of nesting under `Set`.

/// A minimal `Membership` + `Iterable` conformer for exercising the
/// membership core's `isEmpty` derivation and the orthogonal relational
/// predicate algebra (`isDisjoint`, `isSubset`, `isSuperset`,
/// `isStrictSubset`, `isStrictSuperset`, `isEqual`) — which now compose
/// `where Self: Iterable` in `Set Algebra Primitives`.
///
/// The fixture owns no storage discipline of its own — it backs onto a
/// plain array and enforces uniqueness on construction. It exists solely so
/// the protocol-level behavioural surface has a concrete conformer to test
/// against, independent of the storage disciplines that live in sibling
/// packages.
public struct Fixture<Element: Hash.`Protocol` & Copyable> {
    @usableFromInline
    var elements: [Element]

    /// Creates a fixture from `elements`, dropping any later duplicates so
    /// the set-uniqueness invariant holds.
    @inlinable
    public init(_ elements: some Swift.Sequence<Element>) {
        var unique: [Element] = []
        for element in elements where !unique.contains(where: { $0 == element }) {
            unique.append(element)
        }
        self.elements = unique
    }
}

// MARK: - Membership core ({contains, count})

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

// MARK: - Iteration concern (so the orthogonal predicate algebra applies)
//
// Reuses the canonical span iterator `Iterator.Chunk` — the same
// `Iterable.Iterator` the storage disciplines vend — over the backing array's
// span, rather than a hand-rolled iterator, so the fixture's iteration matches
// production exactly. `Iterator.Chunk`'s scalar `next()` is the Copyable-element
// default on `Iterator.Chunk.Protocol`.

extension Fixture: Iterable {
    @_implements(Iterable, Iterator)
    public typealias IterableIterator = Iterator_Chunk_Primitives.Iterator.Chunk<Element>

    @_lifetime(borrow self)
    @inlinable
    public borrowing func makeIterator() -> Iterator_Chunk_Primitives.Iterator.Chunk<Element> {
        Iterator_Chunk_Primitives.Iterator.Chunk(elements.span)
    }
}

// MARK: - Buildability concern (builder-primitives' Buildable: init() + add)
//
// Makes `Fixture` a `Buildable` conformer (builder-primitives' generic build
// capability — `Initiable`'s `init()` + the neutral `add`) so the constructive
// algebra (`union` / `intersection` / `subtracting` / `symmetricDifference`) and
// the `powerset()` lattice — all composed `where Self: Membership & Buildable &
// Iterable` in `Set Algebra Primitives` — have a concrete buildable conformer to
// test against, independent of the storage disciplines that live in sibling
// packages (set-ordered etc.). There is no bundled `Set.Buildable.Protocol`; the
// fixture composes the same builder-primitives × set-primitives the production
// disciplines do. `add` deduplicates (the family's grow semantics).

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
