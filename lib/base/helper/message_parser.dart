abstract final class MessageParser {
  const MessageParser._();

  /// Parses the `message` field, handling both String and List<String> types.
  static List<String> parse(dynamic messageField) {
    if (messageField is String) {
      return [messageField];
    } else if (messageField is List) {
      return messageField.cast<String>();
    } else {
      return [];
    }
  }
}
