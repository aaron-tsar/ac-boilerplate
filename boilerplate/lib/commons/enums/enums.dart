import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

enum ViewMode { standard, quote, comment, detail, goToFullScreen }

enum VideoSourceType { fileData, url }

enum AuthStateType {
  authenticated,
  unAuthenticated,
  initial,
  loading,
}

enum NotificationType {
  system(1),
  discountUpdate(2),
  order(3),
  depositRequest(4),
  paymentBalance(5),
  commissionBalance(6),
  exchangeRate(7),
  changeBalance(8),
  ;

  final int id;

  const NotificationType(this.id);
}

enum TransactionsType {
  depositRequest(1),
  order(2),
  surcharge(3),
  other(4),
  paymentBalance(5);

  final int id;

  const TransactionsType(this.id);

  HeroIcons get asset {
    switch(this) {
      case depositRequest: return HeroIcons.currencyDollar;
      case order: return HeroIcons.shoppingCart;
      case surcharge: return HeroIcons.cube;
      case other: return HeroIcons.banknotes;
      case paymentBalance: return HeroIcons.wallet;
    }
  }
}

enum UserAddressType {
  init(0),
  defaultAddress(1);

  final int id;

  const UserAddressType(this.id);
}

enum UserRoleType {
  superAdmin(1),
  admin(2),
  user(3),
  customerSupport(4);

  final int id;

  const UserRoleType(this.id);
}

enum StatsUserType {
  totalOrder(1),
  totalRefAffiliate(2);

  final int id;

  const StatsUserType(this.id);
}

enum PaymentType {
  bank(1),
  momo(2);

  final int id;

  const PaymentType(this.id);
}

enum DepositRequestStatusType {
  init(0),
  approved(1),
  reject(2);

  final int id;

  const DepositRequestStatusType(this.id);

  String get name => switch(this) {
    init => "Mới",
    approved => "Hoàn tất",
    reject => "Huỷ bỏ",
  };

  Color get color => switch(this) {
    init => Colors.orange,
    approved => Colors.green,
    reject => Colors.red,
  };
}

enum OrderStatusType {
  waitingQuote(0),
  quoted(1),
  accepted(2),
  rejected(3),
  processing(4),
  landing(5),
  delivery(6),
  completed(7),
  ;

  final int id;
  const OrderStatusType(this.id);

  String get name => switch(this) {
    waitingQuote => "Đợi báo giá",
    quoted => "Đã báo giá",
    accepted => "Xác nhận",
    rejected => "Đã huỷ",
    processing => "Đang xử lí",
    landing => "Đã nhập kho",
    delivery => "Đang vận chuyển",
    completed => "Hoàn tất",
  };

  String get lottiePath => switch(this) {
    waitingQuote => "assets/animation/waitingQuote.json",
    quoted => "assets/animation/waitingQuote.json",
    accepted => "assets/animation/accepted.json",
    rejected => "assets/animation/waitingQuote.json",
    processing => "assets/animation/processing.json",
    landing => "assets/animation/processing.json",
    delivery => "assets/animation/delivery.json",
    completed => "assets/animation/completed.json",
  };

  Color get color => switch(this) {
    waitingQuote => Colors.orange,
    quoted => Colors.orange,
    accepted => Colors.green,
    rejected => Colors.red,
    processing => Colors.blue,
    landing => Colors.blue,
    delivery => Colors.deepPurple,
    completed => Colors.black,
  };

  String get longDescription => switch(this) {
    waitingQuote => "Hệ thống đang thực hiện báo giá cho đơn hàng này",
    quoted => "Hệ thống đã cập nhật báo giá cho đơn hàng, hãy kiểm tra và xác nhận báo giá",
    accepted => "Đơn hàng đã được xác nhận",
    rejected => "Đã huỷ",
    processing => "Hệ thống đang xử lí đơn hàng",
    landing => "Đơn hàng đã nhập kho",
    delivery => "Đang giao hàng",
    completed => "Giao hàng thành công",
  };
}
