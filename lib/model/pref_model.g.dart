// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pref_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfilPreferenceModelAdapter extends TypeAdapter<ProfilPreferenceModel> {
  @override
  final int typeId = 0;

  @override
  ProfilPreferenceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfilPreferenceModel(
      walk: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfilPreferenceModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.walk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfilPreferenceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
