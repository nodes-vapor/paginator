import Fluent
import Vapor

extension OffsetPaginator: RawSQLBuilderPaginatable {
    // This shouldn't be called directly - please use the extension on QueryBuilder instead.
    public static func paginate<D: Database, Result>(
        source: RawSQLBuilder<D, Result>,
        count: Future<Int>,
        on req: Request
    ) throws -> Future<([Result], OffsetMetaData)> {
        return count.flatMap { count in
            try offsetMetaData(count: count, on: req) { metadata in
                source.sqlRawBuilder.sql.append("\nLIMIT \(metadata.perPage)\nOFFSET \(metadata.lower)")
                return source.sqlRawBuilder.all(decoding: Result.self)
            }
        }
    }
}
