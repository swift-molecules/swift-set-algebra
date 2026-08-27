public import Algebra_Lattice
public import Builder
public import Iterable
public import Set_Protocol

extension Membership
where
    Self: Buildable & Iterable & Copyable,
    Element: Copyable,
    Self.Failure == Never,
    Self.Iterator.Element == Element,
    Self.Iterator.Failure == Never
{

    @inlinable
    public func powerset() -> Algebra.Lattice<Self> {
        .init(
            bottom: Self(),
            join: { $0.union($1) },
            top: self,
            meet: { $0.intersection($1) }
        )
    }
}
