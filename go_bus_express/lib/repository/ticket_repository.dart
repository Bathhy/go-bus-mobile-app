import 'package:go_bus_express/data/ticket/ticket_api.dart';
import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:shared_package/network/x_result.dart';

abstract class TicketRepository {
  Future<XResult<TicketModel?>> getTicket({required String type});
  Future<XResult<TicketDetailModel?>> getTicketDetail({required int id});
}

class TicketRepositoryImpl implements TicketRepository {
  final TicketApi _ticketApi;

  TicketRepositoryImpl(this._ticketApi);

  @override
  Future<XResult<TicketModel?>> getTicket({required String type}) {
    return xResultHandler(() async {
      final res = await _ticketApi.getTicket(type: type);
      return res.data;
    });
  }
    @override
  Future<XResult<TicketDetailModel?>> getTicketDetail({required int id}) {
    return xResultHandler(() async {
      final res = await _ticketApi.getTicketDetail(id: id);
      return res.data;
    });
  }
}
