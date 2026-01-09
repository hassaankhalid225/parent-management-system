// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildModelAdapter extends TypeAdapter<ChildModel> {
  @override
  final int typeId = 1;

  @override
  ChildModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      className: fields[2] as String,
      section: fields[3] as String,
      rollNumber: fields[4] as String,
      dateOfBirth: fields[5] as DateTime,
      bloodGroup: fields[6] as String,
      profilePictureUrl: fields[7] as String?,
      gender: fields[8] as String,
      medicalConditions: (fields[9] as List?)?.cast<String>(),
      presentDays: fields[10] as int,
      absentDays: fields[11] as int,
      pendingFees: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ChildModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.className)
      ..writeByte(3)
      ..write(obj.section)
      ..writeByte(4)
      ..write(obj.rollNumber)
      ..writeByte(5)
      ..write(obj.dateOfBirth)
      ..writeByte(6)
      ..write(obj.bloodGroup)
      ..writeByte(7)
      ..write(obj.profilePictureUrl)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.medicalConditions)
      ..writeByte(10)
      ..write(obj.presentDays)
      ..writeByte(11)
      ..write(obj.absentDays)
      ..writeByte(12)
      ..write(obj.pendingFees);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
