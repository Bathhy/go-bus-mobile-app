// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingPaymentModelAdapter extends TypeAdapter<PendingPaymentModel> {
  @override
  final int typeId = 0;

  @override
  PendingPaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingPaymentModel(
      bookingId: fields[0] as int,
      amount: fields[1] as double,
      currency: fields[2] as String,
      qrData: fields[3] as String,
      md5: fields[4] as String,
      createdAt: fields[5] as DateTime,
      direction: fields[6] as String,
      selectedSeats: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PendingPaymentModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bookingId)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.currency)
      ..writeByte(3)
      ..write(obj.qrData)
      ..writeByte(4)
      ..write(obj.md5)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.direction)
      ..writeByte(7)
      ..write(obj.selectedSeats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingPaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
