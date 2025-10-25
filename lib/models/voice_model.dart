import 'package:hive/hive.dart';

part 'voice_model.g.dart';

@HiveType(typeId: 11)
enum VoiceGender {
  @HiveField(0)
  male,
  @HiveField(1)
  female,
}

@HiveType(typeId: 12)
class VoiceConfig extends HiveObject {
  @HiveField(0)
  String voiceId;

  @HiveField(1)
  String name;

  @HiveField(2)
  VoiceGender gender;

  @HiveField(3)
  String language;

  @HiveField(4)
  double speed;

  @HiveField(5)
  double pitch;

  @HiveField(6)
  double volume;

  @HiveField(7)
  bool isEnabled;

  VoiceConfig({
    required this.voiceId,
    required this.name,
    required this.gender,
    this.language = 'en-US',
    this.speed = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.isEnabled = true,
  });

  VoiceConfig copyWith({
    String? voiceId,
    String? name,
    VoiceGender? gender,
    String? language,
    double? speed,
    double? pitch,
    double? volume,
    bool? isEnabled,
  }) {
    return VoiceConfig(
      voiceId: voiceId ?? this.voiceId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

@HiveType(typeId: 13)
class TTSConfig extends HiveObject {
  @HiveField(0)
  VoiceConfig selectedVoice;

  @HiveField(1)
  bool enabled;

  @HiveField(2)
  bool announceResults;

  @HiveField(3)
  bool announceReminders;

  @HiveField(4)
  bool announceErrors;

  @HiveField(5)
  double globalSpeed;

  @HiveField(6)
  double globalPitch;

  @HiveField(7)
  double globalVolume;

  TTSConfig({
    required this.selectedVoice,
    this.enabled = true,
    this.announceResults = true,
    this.announceReminders = true,
    this.announceErrors = false,
    this.globalSpeed = 1.0,
    this.globalPitch = 1.0,
    this.globalVolume = 1.0,
  });

  TTSConfig copyWith({
    VoiceConfig? selectedVoice,
    bool? enabled,
    bool? announceResults,
    bool? announceReminders,
    bool? announceErrors,
    double? globalSpeed,
    double? globalPitch,
    double? globalVolume,
  }) {
    return TTSConfig(
      selectedVoice: selectedVoice ?? this.selectedVoice,
      enabled: enabled ?? this.enabled,
      announceResults: announceResults ?? this.announceResults,
      announceReminders: announceReminders ?? this.announceReminders,
      announceErrors: announceErrors ?? this.announceErrors,
      globalSpeed: globalSpeed ?? this.globalSpeed,
      globalPitch: globalPitch ?? this.globalPitch,
      globalVolume: globalVolume ?? this.globalVolume,
    );
  }
}
