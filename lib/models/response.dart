class Response {
  final String age;

  Response({
    required this.age,
  });

  static Response fromJson(Map<String, dynamic> data) {
    return Response(
      age: data["age"].toString(),
    );
  }
}
