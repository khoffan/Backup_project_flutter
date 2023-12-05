class Match {
  String? customerid;
  String? customername;
  String? riderid;
  String? ridername;
  String? date;

  Match({
    this.customerid,
    this.customername,
    this.riderid,
    this.ridername,
    this.date,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
        customerid: json["customer_id"],
        customername: json["customer_name"],
        riderid: json["rider_id"],
        ridername: json["rider_name"],
        date: json["date"]);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_id': customerid,
      'customer_name': customername,
      'rider_id': riderid,
      'rider_name': ridername,
      'date': date
    };
  }
}

class MatchList {
  final List<Match> matches;

  MatchList({required this.matches});

  factory MatchList.fromJson(List<dynamic> json) {
    List<Match> matches = json.map((match) => Match.fromJson(match)).toList();
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

class RiderModel {
  String? name;
  String? location;
  String? date;
  String? id;
  String? statususer;

  RiderModel({
    this.name,
    this.location,
    this.date,
    this.id,
    this.statususer,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      name: json['name'],
      location: json['location'],
      date: json['date'],
      id: json['id'],
      statususer: json['statususer'],
    );
  }
}

class Riderlist {
  final List<RiderModel> riders;

  Riderlist({required this.riders});

  factory Riderlist.fromJson(List<dynamic> json) {
    List<RiderModel> riders =
        json.map((rider) => RiderModel.fromJson(rider)).toList();
    return Riderlist(riders: riders);
  }
}
