import Foundation

public struct BetterPlayerBufferingConfiguration: Equatable {
    public static let `default` = BetterPlayerBufferingConfiguration(
        minBufferMs: 25_000,
        maxBufferMs: 6_553_600,
        bufferForPlaybackMs: 3_000,
        bufferForPlaybackAfterRebufferMs: 6_000
    )

    public let minBufferMs: Int
    public let maxBufferMs: Int
    public let bufferForPlaybackMs: Int
    public let bufferForPlaybackAfterRebufferMs: Int

    var isCustomized: Bool {
        return self != Self.default
    }

    public init(minBufferMs: Int, maxBufferMs: Int, bufferForPlaybackMs: Int, bufferForPlaybackAfterRebufferMs: Int) {
        self.minBufferMs = minBufferMs
        self.maxBufferMs = maxBufferMs
        self.bufferForPlaybackMs = bufferForPlaybackMs
        self.bufferForPlaybackAfterRebufferMs = bufferForPlaybackAfterRebufferMs
    }

    init?(dictionary: [String: Any]?) {
        guard let dictionary = dictionary else { return nil }
        self.init(
            minBufferMs: BetterPlayerBufferingConfiguration.intValue(dictionary["minBufferMs"]) ?? Self.default.minBufferMs,
            maxBufferMs: BetterPlayerBufferingConfiguration.intValue(dictionary["maxBufferMs"]) ?? Self.default.maxBufferMs,
            bufferForPlaybackMs: BetterPlayerBufferingConfiguration.intValue(dictionary["bufferForPlaybackMs"]) ?? Self.default.bufferForPlaybackMs,
            bufferForPlaybackAfterRebufferMs: BetterPlayerBufferingConfiguration.intValue(dictionary["bufferForPlaybackAfterRebufferMs"]) ?? Self.default.bufferForPlaybackAfterRebufferMs
        )
    }

    private static func intValue(_ value: Any?) -> Int? {
        if let intValue = value as? Int {
            return intValue
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        return nil
    }
}

