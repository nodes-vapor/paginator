import XCTest
import Vapor
@testable import Paginator

final class OffsetMetadataTests: XCTestCase {

    func testInitNoRequest() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 1, perPage: 10)
        let metadata = try OffsetMetadata(parameters: params, total: 200, url: url)

        XCTAssertEqual(metadata.currentPage, 1)
        XCTAssertEqual(metadata.perPage, 10)
        XCTAssertEqual(metadata.total, 200)
        XCTAssertEqual(metadata.totalPages, 20)
    }

    func testZeroInitNoRequest() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 1, perPage: 10)
        let metadata = try OffsetMetadata(parameters: params, total: 0, url: url)

        XCTAssertEqual(metadata.currentPage, 1)
        XCTAssertEqual(metadata.perPage, 10)
        XCTAssertEqual(metadata.total, 0)
        XCTAssertEqual(metadata.totalPages, 1)
    }

    func testZeroPerPageInitNoRequest() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 1, perPage: 0)

        let metadata = try OffsetMetadata(parameters: params, total: 0, url: url)

        XCTAssertEqual(metadata.currentPage, 1)
        XCTAssertEqual(metadata.perPage, 1)
        XCTAssertEqual(metadata.total, 0)
        XCTAssertEqual(metadata.totalPages, 1)
    }

    func testPageZeroInitNoRequest() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 0, perPage: 0)

        let metadata = try OffsetMetadata(parameters: params, total: 0, url: url)

        XCTAssertEqual(metadata.currentPage, 1)
        XCTAssertEqual(metadata.perPage, 1)
        XCTAssertEqual(metadata.total, 0)
        XCTAssertEqual(metadata.totalPages, 1)
    }

    func testInvalidPageInitNoRequest() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 11, perPage: 10)

        let metadata = try OffsetMetadata(parameters: params, total: 100, url: url)

        XCTAssertEqual(metadata.currentPage, 10)
        XCTAssertEqual(metadata.perPage, 10)
        XCTAssertEqual(metadata.total, 100)
        XCTAssertEqual(metadata.totalPages, 10)
    }

    func testNextAndPreviousLinksFirstPage() throws {
        let current = 1
        let total = 10
        let url: URL = URL(string: "https://www.google.com")!

        let links = try OffsetMetadata.nextAndPreviousLinks(
            currentPage: current,
            totalPages: total,
            url: url
        )

        XCTAssertNil(links.previous)
        XCTAssertEqual(
            links.next,
            url.absoluteString + "?page=2"
        )
    }

    func testNextAndPreviousLinksLastPage() throws {
        let current = 10
        let total = 10
        let url: URL = URL(string: "https://www.google.com")!

        let links = try OffsetMetadata.nextAndPreviousLinks(
            currentPage: current,
            totalPages: total,
            url: url
        )

        XCTAssertNil(links.next)
        XCTAssertEqual(
            links.previous,
            url.absoluteString + "?page=9"
        )
    }

    func testNextAndPreviousLinksMiddlePage() throws {
        let current = 5
        let total = 10
        let url: URL = URL(string: "https://www.google.com")!

        let links = try OffsetMetadata.nextAndPreviousLinks(
            currentPage: current,
            totalPages: total,
            url: url
        )

        XCTAssertEqual(
            links.next,
            url.absoluteString + "?page=6"
        )
        XCTAssertEqual(
            links.previous,
            url.absoluteString + "?page=4"
        )
    }

    func testNextAndPreviousLinksInvalidPage() throws {
        let current = 15
        let total = 10
        let url: URL = URL(string: "https://www.google.com")!

        let links = try OffsetMetadata.nextAndPreviousLinks(
            currentPage: current,
            totalPages: total,
            url: url
        )

        XCTAssertNil(links.next)
        XCTAssertEqual(
            links.previous,
            url.absoluteString + "?page=\(total)"
        )
    }

    func testMetadataLink() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 0, perPage: 0)
        let page = 3

        let metadata = try OffsetMetadata(parameters: params, total: 0, url: url)
        let link = try metadata.link(for: page)
        XCTAssertEqual(
            link,
            url.absoluteString + "?page=\(page)"
        )
    }

    func testMetadataLinks() throws {
        let url: URL = URL(string: "https://www.google.com")!
        let params = OffsetParameters(page: 0, perPage: 0)
        let pageRange: CountableClosedRange<Int> = 3...7

        let metadata = try OffsetMetadata(parameters: params, total: 0, url: url)
        let links = try metadata.links(in: pageRange)

        XCTAssertEqual(links.count, pageRange.count)

        XCTAssertEqual(
            links[0],
            url.absoluteString + "?page=3"
        )

        XCTAssertEqual(
            links[1],
            url.absoluteString + "?page=4"
        )

        XCTAssertEqual(
            links[2],
            url.absoluteString + "?page=5"
        )

        XCTAssertEqual(
            links[3],
            url.absoluteString + "?page=6"
        )

        XCTAssertEqual(
            links[4],
            url.absoluteString + "?page=7"
        )
    }
 }
