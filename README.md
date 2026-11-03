# swift-set-algebra

Use this package when you have a set type that conforms to `Membership` (from swift-set) and also to `Iterable` and `Buildable`, and you want subset, superset, disjointness and equality tests, union, intersection, subtracting and symmetric difference, or the powerset as an `Algebra.Lattice<Element>`, without writing them for each type. It adds these to `Membership` as default methods, and the second operand can be any other `Membership & Iterable` type with the same `Element`. For the protocol itself, use swift-set. For lattices in general, use swift-algebra.

## Laws

- A constructive operation starts from an empty `Self()` and calls `add` once for each element it keeps. The conforming type's `add` removes duplicates. The order of the `add` calls is fixed. `union` adds every element of the receiver, then every element of the other set. `intersection` and `subtracting` add in the receiver's iteration order. `symmetricDifference` adds the receiver's elements that are not in the other set, then the other set's elements that are not in the receiver. An insertion-ordered type like the test `Fixture` keeps that order in its result.
- `isStrictSubset`, `isStrictSuperset` and `isEqual` first compare `count`, then check containment in one direction only. So they are correct only when `count` equals the number of distinct elements that iteration yields.
- `isDisjoint` iterates the operand with the smaller `count` and calls `contains` on the other one.
- In `powerset()`, `bottom` is the empty `Self()`, `top` is the receiver, `join` is `union` and `meet` is `intersection`. Nothing checks that the operands are subsets of `top`, so joining sets that have elements outside the receiver gives a result outside the lattice. The complement of `a` in this lattice is `top.subtracting(a)`.
