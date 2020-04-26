import Foundation
@testable import Pets

class MockPetsInteractor: PetsInteractorInterface {
    private(set) var spySearchBreed = [String]()
    private(set) var spyImageSource = [Int]()

    func search(breed: String) {
        spySearchBreed.append(breed)
    }

    func imageSource(forBreedId breedId: Int) -> PublicImageSource {
        spyImageSource.append(breedId)
        return .stub
    }
}

extension PublicImageSource {
    static var stub: PublicImageSource {
        return PublicImageSource(
            url: URL(string: "a.a.com")!,
            modifiers: [.waitForCache]
        )
    }
}
