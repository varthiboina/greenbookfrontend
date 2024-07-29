class Customer {
  int? customerId;
  String customerName;
  String customerMobile;
  String customerEmail;

  Customer({
    this.customerId,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
  });
}