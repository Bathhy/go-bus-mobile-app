import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:go_bus_express/models/refund/refund_model.dart';
import 'package:shared_package/network/base_response.dart';
import 'package:go_bus_express/core/network/parse_error_logger.dart';

part 'refund_api.g.dart';

@RestApi()
abstract class RefundApi {
  factory RefundApi(Dio dio, {String baseUrl}) = _RefundApi;

  @GET('/refunds/my')
  Future<BaseResponse<RefundPage>> getMyRefunds({
    @Query('status') String? status,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @GET('/refunds/{id}')
  Future<BaseResponse<RefundModel>> getRefundDetail({
    @Path('id') required int id,
  });

  @POST('/refunds/request/{bookingId}')
  Future<BaseResponse<RefundModel>> requestRefund({
    @Path('bookingId') required int bookingId,
    @Body() required Map<String, dynamic> body,
  });
}
