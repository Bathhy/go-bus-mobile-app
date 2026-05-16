import 'package:dio/dio.dart';
import 'package:go_bus_express/models/ticket/ticket_detail_model.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/models/ticket/ticket_model.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';

part 'ticket_api.g.dart';

@RestApi()
abstract class TicketApi {
  factory TicketApi(Dio dio, {String baseUrl}) = _TicketApi;

  @GET('/tickets')
  Future<BaseResponse<TicketModel>> getTicket({
    @Query('ticketStatus') required String type,
  });

  @GET('/tickets/{id}')
  Future<BaseResponse<TicketDetailModel>> getTicketDetail({
    @Path('id') required int id,
  });
}
