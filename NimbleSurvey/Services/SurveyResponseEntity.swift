//
//  SurveyResponseEntity.swift
//  NimbleSurvey
//
//  Created by Vanalite on 5/13/24.
//

import Foundation

class SurveyResponseEntity: BaseCodableResponseEntity {
    var data: [SurveyDataEntity]?
    var meta: SurveyMeta?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyResponseEntity.self)

        if let array = try? values?.decode([SurveyDataEntity].self, forKey: .data) {
            data?.removeAll()
            data?.append(contentsOf: array)
        }

        if let meta = try? values?.decodeIfPresent(SurveyMeta.self, forKey: .meta) {
            self.meta = meta
        }

    }

    required init() {
        super.init()
    }

    private enum CodingKeysSurveyResponseEntity: String, CodingKey {
        case data
        case meta
    }
}

class SurveyDataEntity: BaseCodableResponseEntity {
    var id: String = ""
    var type: String = "survey_simple"
    var attributes: SurveyAttribute?

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let values = try? decoder.container(keyedBy: CodingKeysSurveyDataEntity.self)
        if let id = try? values?.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        }
        if let type = try? values?.decodeIfPresent(String.self, forKey: .type) {
            self.type = type
        }
        if let attributes = try? values?.decodeIfPresent(SurveyAttribute.self, forKey: .attributes) {
            self.attributes = attributes
        }
    }

    required init() {
        super.init()
    }
    
    private enum CodingKeysSurveyDataEntity: String, CodingKey {
        case id
        case type
        case attributes
    }
}

class SurveyMeta: BaseCodableResponseEntity {
    var page: Int = 0
    var pages: Int = 0
    var pageSize: Int = 1
    var records: Int = 20

    private enum CodingKeysSurveyMeta: String, CodingKey {
        case page
        case pages
        case pageSize = "page_size"
        case records
    }
}

class SurveyAttribute: BaseCodableResponseEntity {
    var title: String = "Scarlett Bangkok"
    var descriptionString: String = "We'd love ot hear from you!"
    var isActive: Bool = true
    var coverImageUrl: String = "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_"
    var createdAt: String = "2017-01-23T07:48:12.991Z"
    var activeAt: String = "2015-10-08T07:04:00.000Z"
    var inactiveAt: String = ""
    var surveyType: String = "Restaurant"

    private enum CodingKeysSurveyAttribute: String, CodingKey {
        case title
        case descriptionString = "description"
        case isActive = "is_active"
        case coverImageUrl = "cover_image_url"
        case createdAt = "created_at"
        case activeAt = "active_at"
        case inactiveAt = "inactive_at"
        case surveyType = "survey_type"
    }
}
