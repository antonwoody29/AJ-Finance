import CloudKit
import Foundation
import Observation

// MARK: - Backup Manager
// CloudKit-backed save data backup. No server required — uses Apple's free public CloudKit database.
// Each user has a unique backup code. Code → CKRecord lookup restores all UserDefaults-persisted data.

@Observable
@MainActor
final class BackupManager {
    static let shared = BackupManager()

    var isBusy        = false
    var lastBackupDate: Date?
    var cloudStatus: CloudStatus = .unknown

    private let db = CKContainer.default().publicCloudDatabase
    private let recordType = "AJSaveV1"

    enum CloudStatus {
        case unknown, available, unavailable
    }

    enum BackupError: LocalizedError {
        case encodingFailed, decodingFailed, notFound, iCloudUnavailable

        var errorDescription: String? {
            switch self {
            case .encodingFailed:   return "Could not encode your save data."
            case .decodingFailed:   return "Could not read the backup. It may be corrupted."
            case .notFound:         return "No backup found for that code. Check it and try again."
            case .iCloudUnavailable: return "iCloud is unavailable. Sign in to iCloud in Settings and try again."
            }
        }
    }

    private init() {
        lastBackupDate = UserDefaults.standard.object(forKey: "aj_lastCloudBackup") as? Date
        Task { await checkiCloudStatus() }
    }

    func checkiCloudStatus() async {
        do {
            let status = try await CKContainer.default().accountStatus()
            cloudStatus = (status == .available) ? .available : .unavailable
        } catch {
            cloudStatus = .unavailable
        }
    }

    // MARK: - Save

    func saveBackup(code: String, userName: String, payload: [String: Any]) async throws {
        guard cloudStatus == .available else { throw BackupError.iCloudUnavailable }
        isBusy = true
        defer { isBusy = false }

        let recordID = CKRecord.ID(recordName: "backup_\(cleanCode(code))")
        var record: CKRecord
        do {
            record = try await db.record(for: recordID)
        } catch {
            record = CKRecord(recordType: recordType, recordID: recordID)
        }

        let data    = try JSONSerialization.data(withJSONObject: payload)
        guard let jsonStr = String(data: data, encoding: .utf8) else { throw BackupError.encodingFailed }

        record["saveJSON"] = jsonStr       as CKRecordValue
        record["savedAt"]  = Date()        as CKRecordValue
        record["userName"] = userName.lowercased().trimmingCharacters(in: .whitespaces) as CKRecordValue

        try await db.save(record)
        lastBackupDate = Date()
        UserDefaults.standard.set(lastBackupDate, forKey: "aj_lastCloudBackup")
    }

    // MARK: - Restore by code

    func restoreBackup(code: String) async throws -> [String: Any] {
        isBusy = true
        defer { isBusy = false }

        let recordID = CKRecord.ID(recordName: "backup_\(cleanCode(code))")
        let record: CKRecord
        do {
            record = try await db.record(for: recordID)
        } catch let err as CKError where err.code == .unknownItem {
            throw BackupError.notFound
        }

        guard let jsonStr = record["saveJSON"] as? String,
              let data    = jsonStr.data(using: .utf8),
              let payload = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { throw BackupError.decodingFailed }

        return payload
    }

    // MARK: - Lookup by username

    func findCodeByUserName(_ name: String) async throws -> String? {
        let predicate = NSPredicate(format: "userName == %@",
                                    name.lowercased().trimmingCharacters(in: .whitespaces))
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "savedAt", ascending: false)]

        let result  = try await db.records(matching: query, desiredKeys: ["savedAt"])
        let records = try result.matchResults.compactMap { try? $0.1.get() }
        guard let first = records.first else { return nil }

        let raw  = first.recordID.recordName        // "backup_XXXXXXXX"
        let code = String(raw.dropFirst("backup_".count))
        return formatCode(code)
    }

    // MARK: - Helpers

    func cleanCode(_ code: String) -> String {
        code.uppercased()
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }

    func formatCode(_ raw: String) -> String {
        let clean = cleanCode(raw)
        guard clean.count == 8 else { return clean }
        return "\(clean.prefix(4))-\(clean.suffix(4))"
    }
}
