import 'package:hive/hive.dart';

part 'vault_item_model.g.dart';

@HiveType(typeId: 14)
enum VaultItemType {
  @HiveField(0)
  image,
  @HiveField(1)
  video,
  @HiveField(2)
  document,
  @HiveField(3)
  audio,
  @HiveField(4)
  archive,
  @HiveField(5)
  other,
}

@HiveType(typeId: 15)
class VaultItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String originalName;

  @HiveField(2)
  String encryptedName;

  @HiveField(3)
  String filePath;

  @HiveField(4)
  VaultItemType type;

  @HiveField(5)
  int fileSize;

  @HiveField(6)
  DateTime dateAdded;

  @HiveField(7)
  DateTime? dateModified;

  @HiveField(8)
  String? album;

  @HiveField(9)
  List<String> tags;

  @HiveField(10)
  String? thumbnailPath;

  @HiveField(11)
  String? description;

  @HiveField(12)
  bool isFavorite;

  @HiveField(13)
  String encryptionKey;

  @HiveField(14)
  String checksum;

  VaultItem({
    required this.id,
    required this.originalName,
    required this.encryptedName,
    required this.filePath,
    required this.type,
    required this.fileSize,
    required this.dateAdded,
    this.dateModified,
    this.album,
    this.tags = const [],
    this.thumbnailPath,
    this.description,
    this.isFavorite = false,
    required this.encryptionKey,
    required this.checksum,
  });

  String get fileExtension {
    return originalName.split('.').last.toLowerCase();
  }

  String get displayName {
    return originalName;
  }

  bool get hasThumbnail {
    return thumbnailPath != null && thumbnailPath!.isNotEmpty;
  }

  VaultItem copyWith({
    String? id,
    String? originalName,
    String? encryptedName,
    String? filePath,
    VaultItemType? type,
    int? fileSize,
    DateTime? dateAdded,
    DateTime? dateModified,
    String? album,
    List<String>? tags,
    String? thumbnailPath,
    String? description,
    bool? isFavorite,
    String? encryptionKey,
    String? checksum,
  }) {
    return VaultItem(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      encryptedName: encryptedName ?? this.encryptedName,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      album: album ?? this.album,
      tags: tags ?? this.tags,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      checksum: checksum ?? this.checksum,
    );
  }
}

@HiveType(typeId: 16)
class VaultAlbum extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? coverImagePath;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isDefault;

  VaultAlbum({
    required this.id,
    required this.name,
    this.description,
    this.coverImagePath,
    required this.createdAt,
    required this.updatedAt,
    this.isDefault = false,
  });

  VaultAlbum copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDefault,
  }) {
    return VaultAlbum(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
