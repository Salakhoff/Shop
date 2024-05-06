import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct AdsSection {
    var identity: String
    var items: [AdsViewModel.AdListItem]
}

extension AdsSection: AnimatableSectionModelType {
    init(original: AdsSection, items: [AdsViewModel.AdListItem]) {
        self = original
        self.items = items
    }
}

final class AdsViewModel {
    
    enum AdListItem: IdentifiableType, Equatable {
        case activityIndecator
        case ad(Ad)
        
        var identity: String {
            switch self {
            case .activityIndecator: return "activityIndecator"
            case .ad(let ad): return ad.identity
            }
        }
        
    }
    
    private let service: AdsServiceType
    
    let ads: Driver<[AdsSection]>
    let nextPageLoadingTrigger = PublishRelay<Void>()
    
    init(service: AdsServiceType) {
        self.service = service
        
        var page = 1
        
        ads = nextPageLoadingTrigger
            .flatMap{
                service
                    .getAdsList(page: page, limit: 20)
            }
        
            .do(onNext: { _ in
                page += 1
            })
        
            .map { ads in
                [
                    AdsSection(
                        identity: UUID().uuidString,
                        items: ads.map(AdListItem.ad))
                ]
            }
            .asDriver(onErrorJustReturn: [])
            .startWith([AdsSection(identity: UUID().uuidString, items: [.activityIndecator])])
            .scan([], accumulator: +)
    }
}
