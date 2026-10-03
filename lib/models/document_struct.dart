enum DocumentType {
  lecture('Bài giảng'),
  assignment('Bài tập'),
  reference('Tài liệu tham khảo');

  const DocumentType(this.label);
  final String label;
}

extension DocumentTypeCodec on DocumentType {
  static DocumentType fromValue(String value) => DocumentType.values.firstWhere(
        (type) => type.name == value,
        orElse: () => DocumentType.reference,
      );
}
