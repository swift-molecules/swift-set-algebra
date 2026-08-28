public import Iterator
public import Set

extension Membership
where Self: Iterable & ~Copyable, Self.Iterator.Element == Element, Self.Iterator.Failure == Never {

    @inlinable

    public func isDisjoint<Other: Membership & Iterable & ~Copyable>(
        with other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var disjoint = true
        if count <= other.count {
            forEach { element in
                if disjoint, other.contains(element) { disjoint = false }
            }
        } else {
            other.forEach { element in
                if disjoint, self.contains(element) { disjoint = false }
            }
        }
        return disjoint
    }

    @inlinable

    public func isSubset<Other: Membership & Iterable & ~Copyable>(
        of other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = true
        forEach { element in
            if result, !other.contains(element) { result = false }
        }
        return result
    }

    @inlinable

    public func isSuperset<Other: Membership & Iterable & ~Copyable>(
        of other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = true
        other.forEach { element in
            if result, !self.contains(element) { result = false }
        }
        return result
    }

    @inlinable

    public func isStrictSubset<Other: Membership & Iterable & ~Copyable>(
        of other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        count < other.count && isSubset(of: other)
    }

    @inlinable

    public func isStrictSuperset<Other: Membership & Iterable & ~Copyable>(
        of other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        count > other.count && isSuperset(of: other)
    }

    @inlinable

    public func isEqual<Other: Membership & Iterable & ~Copyable>(
        to other: borrowing Other
    ) -> Bool
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        count == other.count && isSubset(of: other)
    }
}
