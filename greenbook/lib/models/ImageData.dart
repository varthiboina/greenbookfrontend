class ImageData {
  String name;
  String type;
  int? id;
  String? url; // This can be the URL of the image

  ImageData({
    required this.name,
    required this.type,
    this.id,
    this.url,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      name: json['name'],
      type: json['type'],
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'url': url,
    };
  }
}
