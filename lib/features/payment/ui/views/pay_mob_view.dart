// import 'package:chef_hamdy/core/utils/app_strings.dart';
// import 'package:chef_hamdy/core/cubits/bottom_nav_cubit/bottom_nav_cubit.dart';
// import 'package:chef_hamdy/core/functions/floating_snack_bar.dart';
// import 'package:chef_hamdy/core/functions/redirected_snack_bar.dart';
// import 'package:chef_hamdy/core/models/order_data_model.dart';
// import 'package:chef_hamdy/core/routes/app_router.dart';
// import 'package:chef_hamdy/core/services/service_locator.dart';
// import 'package:chef_hamdy/features/cart/data/repos/cart_repo_impl.dart';
// import 'package:chef_hamdy/features/order/data/repos/create_order_repo/create_order_repo_impl.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:go_router/go_router.dart';
// import '../manager/pay_mob_manager.dart';

// class PayMobView extends StatefulWidget {
//   const PayMobView({super.key, required this.orderDataModel});
//   final OrderDataModel orderDataModel;

//   @override
//   PayMobViewState createState() => PayMobViewState();
// }

// class PayMobViewState extends State<PayMobView> {
//   late InAppWebViewController _webViewController;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _pay();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri('about:blank')),
//             onWebViewCreated: (controller) {
//               _webViewController = controller;
//               if(_isLoading == true){
//                 redirectedSnackBar(context,message: AppStrings.redirectingToPayment.tr());
//               }
//             },
//             onLoadStop: (controller, url) async{
//               setState(() {
//                 _isLoading = false;
//               });


//               if (url.toString().contains('success=true')) {
//                 await _createOrderAndClearCart();
//               }
//             },
//           ),
//           if (_isLoading)
//             const Center(
//               child: SizedBox.shrink(),
//             ),
//         ],
//       ),

//     );
//   }

//   Future<void> _pay() async {
//     try {
//       String paymentKey = await PayMobManager().getPaymentKey(widget.orderDataModel.amountToPay, "EGP", "df");
//       String url = "https://accept.paymob.com/api/acceptance/iframes/901221?payment_token=$paymentKey";
//       _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
//     } catch (e) {
//       //print("Error: $e");
//     }
//   }
//   Future<void> _createOrderAndClearCart() async {
//     // print(widget.orderDataModel.orderReceivingOption);
//     // print(2);
//     // print(widget.orderDataModel.branchId);
//     // print(widget.orderDataModel.street);
//     // print(widget.orderDataModel.city);
//     // print(widget.orderDataModel.governorate);
//     final createOrder = getIt<CreateOrderRepoImpl>();
//     final createOrderResult = await createOrder.createOrder(
//       orderReceivingOption: widget.orderDataModel.orderReceivingOption,
//       paymentType: 2,
//       branchId: widget.orderDataModel.branchId ?? 0,
//       street: widget.orderDataModel.street ?? '',
//       city: widget.orderDataModel.city ?? '',
//       governorate: widget.orderDataModel.governorate ?? '',
//     );

//     final cartRepo = getIt.get<CartRepoImpl>();
//     final deleteCartResult = await cartRepo.deleteCart();

//     createOrderResult.fold(
//           (failure) {
//         floatingSnackBar(context, AppStrings.failedToSendOrder.tr());
//       },
//           (_) {
//         floatingSnackBar(context, AppStrings.orderSentSuccessfully.tr(), icon: Icons.check_circle_outline,durationInSeconds: 5);
//         context.read<BottomNavCubit>().changeIndex(0);
//         GoRouter.of(context).go(AppRouter.orderSentSuccessfullyView);
//       },
//     );

//     deleteCartResult.fold(
//           (failure) {
//         floatingSnackBar(context, AppStrings.failedToDeleteCart.tr());
//       },
//           (_) {
//         // floatingSnackBar(context, AppStrings.orderSentSuccessfully.tr(),
//         //     icon: Icons.check_circle_outline);
//         // context.read<BottomNavCubit>().changeIndex(0);
//         // GoRouter.of(context).go(AppRouter.homePage);
//       },
//     );
//   }
// }