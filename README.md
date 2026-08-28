# Set Algebra

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The orthogonal **set algebra** — relational predicates (`isSubset`, `isSuperset`, `isDisjoint`, `isStrictSubset`, `isStrictSuperset`, `isEqual`) and constructive operations (`union`, `intersection`, `subtracting`, `symmetricDifference`) — supplied as protocol-extension defaults over the membership core in `swift-set`.

---

## Quick Start

Algebra is a *third orthogonal concern*, composed over the set membership core (`Membership` = `{contains, count}`) and the iteration concern (`Iterable`) — never baked into either. Any type that conforms `Membership & Iterable` inherits the relational predicates for free; any `Buildable & Iterable` type additionally inherits the `Self`-returning constructive operations.

```swift
import Set_Algebra

// Predicates work over any two conformers with the same element — even
// different set types — against borrowed receivers, with no allocation:
func overlap<A: Membership & Iterable, B: Membership & Iterable>(
    _ a: borrowing A, _ b: borrowing B
) -> Bool where A.Element == B.Element, A.Element: Copyable,
                A.Iterator.Element == A.Element, B.Iterator.Element == B.Element {
    !a.isDisjoint(with: b)
}
```

Constructive operations return `Self` (on the growable `Buildable` refinement), so a set discipline gets back its own type:

```swift
let u = a.union(b)          // Self
let i = a.intersection(b)   // Self
```

## Architecture

This package bridges the membership core (`swift-set`) with the iteration concern (`swift-iterator`), carrying only the element-wise algebra:

- **Predicates** — `where Self: Membership & Iterable` (the Copyable-element slice).
- **Constructive** — `where Self: Buildable & Iterable`, returning `Self`.

The `@inlinable` defaults monomorphize to **0 `witness_method`** on the hot path in release, cross-package. `powerset()` exposes the corresponding `Algebra.Lattice` witness with union as join and intersection as meet.

The package composes the atom-owned Set, Iterator, and Algebra surfaces with the molecule-owned Builder grammar. It requires Swift 6.4 and the platform 27 generation.

## License

Apache License 2.0. See [LICENSE.md](LICENSE.md).
