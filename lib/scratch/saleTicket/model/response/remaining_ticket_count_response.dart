class RemainingTicketCountResponse {
  final int responseCode;
  final String responseMessage;
  final Map<String, int> responseData;

  RemainingTicketCountResponse({
    required this.responseCode,
    required this.responseMessage,
    required this.responseData,
  });

  RemainingTicketCountResponse.fromJson(Map<String, dynamic> json)
      : responseCode = json['responseCode'],
        responseMessage = json['responseMessage'],
        responseData = Map<String, int>.from(json['response'] ?? {});

// Additional methods or properties can be defined here if needed
}
