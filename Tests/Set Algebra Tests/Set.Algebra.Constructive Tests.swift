import Set_Algebra_Test_Support
import Testing

private func toArray<S: Iterable & ~Copyable>(_ set: borrowing S) -> [S.Iterator.Element]
where S.Iterator.Element: Hashable, S.Iterator.Failure == Never {
    var result: [S.Iterator.Element] = []
    set.forEach { result.append($0) }
    return result
}

private func fixture(_ elements: [Int]) -> Fixture<Int> {
    var set = Fixture<Int>()
    for element in elements { set.add(element) }
    return set
}

@Suite
struct `Constructive Algebra Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Constructive Algebra Test`.Unit {
    @Test
    func `union contains elements of both, receiver-first`() {
        let a = fixture([1, 2, 3])
        let b = fixture([3, 4, 5])
        #expect(toArray(a.union(b)) == [1, 2, 3, 4, 5])
    }

    @Test
    func `intersection contains common elements, receiver order`() {
        let a = fixture([1, 2, 3, 4])
        let b = fixture([2, 4, 6])
        #expect(toArray(a.intersection(b)) == [2, 4])
    }

    @Test
    func `subtracting removes elements present in other`() {
        let a = fixture([1, 2, 3, 4, 5])
        let b = fixture([2, 4])
        #expect(toArray(a.subtracting(b)) == [1, 3, 5])
    }

    @Test
    func `symmetric difference contains elements in exactly one`() {
        let a = fixture([1, 2, 3])
        let b = fixture([2, 3, 4])
        #expect(toArray(a.symmetricDifference(b)) == [1, 4])
    }
}

@Suite
struct `Powerset Lattice Test` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Powerset Lattice Test`.Unit {
    @Test
    func `join is union, meet is intersection`() {
        let universe = fixture([1, 2, 3, 4])
        let lattice = universe.powerset()
        let a = fixture([1, 2])
        let b = fixture([2, 3])
        #expect(toArray(lattice.join(a, b)).sorted() == toArray(a.union(b)).sorted())
        #expect(toArray(lattice.meet(a, b)).sorted() == toArray(a.intersection(b)).sorted())
        #expect(toArray(lattice.join(a, b)).sorted() == [1, 2, 3])
        #expect(toArray(lattice.meet(a, b)) == [2])
    }

    @Test
    func `bottom is empty, top is the universe`() {
        let universe = fixture([1, 2, 3])
        let lattice = universe.powerset()
        #expect(toArray(lattice.bottom).isEmpty)
        #expect(toArray(lattice.top) == [1, 2, 3])
    }

    @Test
    func `inclusion: a subset of b iff a join b equals b`() {
        let universe = fixture([1, 2, 3, 4])
        let lattice = universe.powerset()
        let a = fixture([1, 2])
        let b = fixture([1, 2, 3])
        #expect(toArray(lattice.join(a, b)).sorted() == toArray(b).sorted())
        #expect(toArray(lattice.join(b, a)).sorted() != toArray(a).sorted())
    }

    @Test
    func `complement laws via native subtracting`() {
        let universe = fixture([1, 2, 3, 4])
        let lattice = universe.powerset()
        let a = fixture([1, 3])
        let notA = universe.subtracting(a)
        #expect(toArray(notA) == [2, 4])

        #expect(toArray(lattice.join(a, notA)).sorted() == toArray(universe).sorted())
        #expect(toArray(lattice.meet(a, notA)).isEmpty)
    }
}
