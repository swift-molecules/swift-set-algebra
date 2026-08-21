import Set_Algebra_Primitives_Test_Support
import Testing

@Suite("Membership Relational Defaults")
struct Test {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension Test.Unit {

    @Test
    func `isEmpty is true for the empty set`() {
        let empty = Fixture<Int>([])
        #expect(empty.isEmpty)
    }

    @Test
    func `isEmpty is false for a non-empty set`() {
        let set = Fixture<Int>([1])
        #expect(!set.isEmpty)
    }

    @Test
    func `count reflects the number of unique elements`() {
        let set = Fixture<Int>([1, 2, 3])
        #expect(set.count == 3)
    }

    @Test
    func `count drops duplicates supplied at construction`() {
        let set = Fixture<Int>([1, 2, 2, 3, 3, 3])
        #expect(set.count == 3)
    }

    @Test
    func `disjoint sets report disjoint`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([3, 4])
        #expect(a.isDisjoint(with: b))
    }

    @Test
    func `overlapping sets are not disjoint`() {
        let a = Fixture<Int>([1, 2, 3])
        let b = Fixture<Int>([2, 4])
        #expect(!a.isDisjoint(with: b))
    }

    @Test
    func `a proper subset is a subset`() {
        let small = Fixture<Int>([1, 2])
        let large = Fixture<Int>([1, 2, 3])
        #expect(small.isSubset(of: large))
        #expect(!large.isSubset(of: small))
    }

    @Test
    func `a proper superset is a superset`() {
        let large = Fixture<Int>([1, 2, 3])
        let small = Fixture<Int>([1, 2])
        #expect(large.isSuperset(of: small))
        #expect(!small.isSuperset(of: large))
    }

    @Test
    func `a proper subset is a strict subset`() {
        let small = Fixture<Int>([1, 2])
        let large = Fixture<Int>([1, 2, 3])
        #expect(small.isStrictSubset(of: large))
    }

    @Test
    func `equal sets are not strict subsets`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([1, 2])
        #expect(!a.isStrictSubset(of: b))
    }

    @Test
    func `a proper superset is a strict superset`() {
        let large = Fixture<Int>([1, 2, 3])
        let small = Fixture<Int>([1, 2])
        #expect(large.isStrictSuperset(of: small))
    }

    @Test
    func `equal sets are not strict supersets`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([1, 2])
        #expect(!a.isStrictSuperset(of: b))
    }

    @Test
    func `sets with the same elements are equal`() {
        let a = Fixture<Int>([1, 2, 3])
        let b = Fixture<Int>([3, 2, 1])
        #expect(a.isEqual(to: b))
    }

    @Test
    func `sets with different counts are not equal`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([1, 2, 3])
        #expect(!a.isEqual(to: b))
    }

    @Test
    func `sets with the same count but different elements are not equal`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([2, 3])
        #expect(!a.isEqual(to: b))
    }
}

extension Test.`Edge Case` {

    @Test
    func `the empty set is disjoint with every set`() {
        let empty = Fixture<Int>([])
        let nonEmpty = Fixture<Int>([1])
        #expect(empty.isDisjoint(with: nonEmpty))
        #expect(nonEmpty.isDisjoint(with: empty))
        #expect(empty.isDisjoint(with: empty))
    }

    @Test
    func `the empty set is a subset of every set`() {
        let empty = Fixture<Int>([])
        let nonEmpty = Fixture<Int>([1])
        #expect(empty.isSubset(of: nonEmpty))
        #expect(empty.isSubset(of: empty))
    }

    @Test
    func `every set is a superset of the empty set`() {
        let empty = Fixture<Int>([])
        let nonEmpty = Fixture<Int>([1])
        #expect(nonEmpty.isSuperset(of: empty))
        #expect(empty.isSuperset(of: empty))
    }

    @Test
    func `the empty set is a strict subset of any non-empty set`() {
        let empty = Fixture<Int>([])
        let nonEmpty = Fixture<Int>([1])
        #expect(empty.isStrictSubset(of: nonEmpty))
        #expect(!empty.isStrictSubset(of: empty))
    }

    @Test
    func `empty sets are equal`() {
        let a = Fixture<Int>([])
        let b = Fixture<Int>([])
        #expect(a.isEqual(to: b))
    }

    @Test
    func `a set equals itself`() {
        let set = Fixture<Int>([1, 2, 3])
        #expect(set.isEqual(to: set))
        #expect(set.isSubset(of: set))
        #expect(set.isSuperset(of: set))
        #expect(!set.isStrictSubset(of: set))
        #expect(!set.isStrictSuperset(of: set))
    }
}

extension Test.Integration {

    @Test
    func `subset and superset agree across a pair`() {
        let small = Fixture<Int>([1, 2])
        let large = Fixture<Int>([1, 2, 3, 4])
        #expect(small.isSubset(of: large))
        #expect(large.isSuperset(of: small))
        #expect(small.isStrictSubset(of: large))
        #expect(large.isStrictSuperset(of: small))
        #expect(!small.isDisjoint(with: large))
    }

    @Test
    func `equality implies mutual subset without strictness`() {
        let a = Fixture<Int>([1, 2, 3])
        let b = Fixture<Int>([1, 2, 3])
        #expect(a.isEqual(to: b))
        #expect(a.isSubset(of: b))
        #expect(b.isSubset(of: a))
        #expect(!a.isStrictSubset(of: b))
        #expect(!a.isStrictSuperset(of: b))
    }

    @Test
    func `disjoint non-empty sets are neither subset nor superset`() {
        let a = Fixture<Int>([1, 2])
        let b = Fixture<Int>([3, 4])
        #expect(a.isDisjoint(with: b))
        #expect(!a.isSubset(of: b))
        #expect(!a.isSuperset(of: b))
        #expect(!a.isEqual(to: b))
    }
}
