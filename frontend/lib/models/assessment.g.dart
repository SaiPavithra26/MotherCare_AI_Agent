// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentAdapter extends TypeAdapter<Assessment> {
  @override
  final int typeId = 1;

  @override
  Assessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assessment(
      transcribedText: fields[0] as String,
      symptoms: (fields[1] as List).cast<String>(),
      urgencyLevel: fields[2] as String,
      responseText: fields[3] as String,
      recommendations: (fields[4] as List).cast<String>(),
      disclaimer: fields[5] as String,
      timestamp: fields[6] as DateTime,
      audioUrl: fields[7] as String?,
      pdfUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Assessment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.transcribedText)
      ..writeByte(1)
      ..write(obj.symptoms)
      ..writeByte(2)
      ..write(obj.urgencyLevel)
      ..writeByte(3)
      ..write(obj.responseText)
      ..writeByte(4)
      ..write(obj.recommendations)
      ..writeByte(5)
      ..write(obj.disclaimer)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.audioUrl)
      ..writeByte(8)
      ..write(obj.pdfUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
