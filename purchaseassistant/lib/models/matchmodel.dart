class Match {
  String customerid = "";
  String customername = "";
  String riderid = "";
  String ridername = "";
  String date = "";

  Match({
    required this.customerid,
    required this.customername,
    required this.riderid,
    required this.ridername,
    required this.date,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
        customerid: json["customer_id"],
        customername: json["customer_name"],
        riderid: json["rider_id"],
        ridername: json["rider_name"],
        date: json["date"]);
  }
}

class MatchList {
  final List<Match> matches;

  MatchList({required this.matches});

  factory MatchList.fromJson(Map<String, dynamic> json) {
    List<dynamic> matchList = json['matches'];
    List<Match> matches =
        matchList.map((match) => Match.fromJson(match)).toList();

    return MatchList(matches: matches);
  }
}

class DataMatch {
  String? cusId;
  String? cusName;
  String? riderName;
  String? riderId;
  String? date;

  DataMatch({
    this.cusId,
    this.cusName,
    this.riderId,
    this.riderName,
    this.date,
  });
}
