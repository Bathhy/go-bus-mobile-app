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

  @GET('/ticket/getTicket')
  Future<BaseResponse<TicketModel>> getTicket({
    @Query('type') required String type,
  });

  @GET('/ticket/{id}')
  Future<BaseResponse<TicketDetailModel>> getTicketDetail({
    @Path('id') required int id,
  });
}
