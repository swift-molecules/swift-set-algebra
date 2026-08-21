public import Builder_Primitives
public import Iterable
public import Set_Protocol_Primitives

extension Membership
where
    Self: Buildable & Iterable & ~Copyable,
    Element: Copyable,
    Self.Failure == Never,
    Self.Iterator.Element == Element,
    Self.Iterator.Failure == Never
{

    @inlinable

    public func union<Other: Membership & Iterable & ~Copyable>(
        _ other: borrowing Other
    ) -> Self
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = Self()
        self.forEach { element in result.add(copy element) }
        other.forEach { element in result.add(copy element) }
        return result
    }

    @inlinable

    public func intersection<Other: Membership & Iterable & ~Copyable>(
        _ other: borrowing Other
    ) -> Self
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = Self()
        self.forEach { element in
            if other.contains(element) { result.add(copy element) }
        }
        return result
    }

    @inlinable

    public func subtracting<Other: Membership & Iterable & ~Copyable>(
        _ other: borrowing Other
    ) -> Self
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = Self()
        self.forEach { element in
            if !other.contains(element) { result.add(copy element) }
        }
        return result
    }

    @inlinable

    public func symmetricDifference<Other: Membership & Iterable & ~Copyable>(
        _ other: borrowing Other
    ) -> Self
    where
        Other.Element == Element, Other.Iterator.Element == Element, Other.Iterator.Failure == Never
    {
        var result = Self()
        self.forEach { element in
            if !other.contains(element) { result.add(copy element) }
        }
        other.forEach { element in
            if !self.contains(element) { result.add(copy element) }
        }
        return result
    }
}
