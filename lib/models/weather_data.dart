import 'dart:convert';

WeatherData weatherDataFromJson(String str) =>
    WeatherData.fromJson(json.decode(str));
String weatherDataToJson(WeatherData data) => json.encode(data.toJson());

class WeatherData {
  int queryCost;
  double latitude;
  double longitude;
  String resolvedAddress;
  String address;
  String timezone;
  double tzoffset;
  List<CurrentConditions> days;
  List<dynamic> alerts;
  CurrentConditions currentConditions;

  WeatherData({
    required this.queryCost,
    required this.latitude,
    required this.longitude,
    required this.resolvedAddress,
    required this.address,
    required this.timezone,
    required this.tzoffset,
    required this.days,
    required this.alerts,
    required this.currentConditions,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        queryCost: json["queryCost"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        resolvedAddress: json["resolvedAddress"],
        address: json["address"],
        timezone: json["timezone"],
        tzoffset: json["tzoffset"].toDouble(),
        days: List<CurrentConditions>.from(
            json["days"].map((x) => CurrentConditions.fromJson(x))),
        alerts: List<dynamic>.from(json["alerts"].map((x) => x)),
        currentConditions:
            CurrentConditions.fromJson(json["currentConditions"]),
      );

  Map<String, dynamic> toJson() => {
        "queryCost": queryCost,
        "latitude": latitude,
        "longitude": longitude,
        "resolvedAddress": resolvedAddress,
        "address": address,
        "timezone": timezone,
        "tzoffset": tzoffset,
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
        "alerts": List<dynamic>.from(alerts.map((x) => x)),
        "currentConditions": currentConditions.toJson(),
      };
}

class CurrentConditions {
  String datetime;
  int datetimeEpoch;
  double temp;
  double feelslike;
  double humidity;
  double dew;
  double precip;
  double snow;
  double snowdepth;
  double windgust;
  double windspeed;
  double winddir;
  double pressure;
  double visibility;
  double cloudcover;
  double solarradiation;
  double solarenergy;
  double uvindex;
  double severerisk;
  Conditions? conditions;
  String? sunrise;
  double? sunriseEpoch;
  String? sunset;
  double? sunsetEpoch;
  double? moonphase;
  double? tempmax;
  double? tempmin;
  double? feelslikemax;
  double? feelslikemin;
  double? precipcover;
  Description? description;
  List<CurrentConditions>? hours;

  CurrentConditions({
    required this.datetime,
    required this.datetimeEpoch,
    required this.temp,
    required this.feelslike,
    required this.humidity,
    required this.dew,
    required this.precip,
    required this.snow,
    required this.snowdepth,
    required this.windgust,
    required this.windspeed,
    required this.winddir,
    required this.pressure,
    required this.visibility,
    required this.cloudcover,
    required this.solarradiation,
    required this.solarenergy,
    required this.uvindex,
    required this.severerisk,
    required this.conditions,
    this.sunrise,
    this.sunriseEpoch,
    this.sunset,
    this.sunsetEpoch,
    this.moonphase,
    this.tempmax,
    this.tempmin,
    this.feelslikemax,
    this.feelslikemin,
    this.precipcover,
    this.description,
    this.hours,
  });

  factory CurrentConditions.fromJson(Map<String, dynamic> json) =>
      CurrentConditions(
        datetime: json["datetime"] as String? ?? 'DefaultTime',
        datetimeEpoch: (json["datetimeEpoch"] as num?)?.toInt() ?? 0,
        temp: (json["temp"] as num?)?.toDouble() ?? 0.0,
        feelslike: (json["feelslike"] as num?)?.toDouble() ?? 0.0,
        humidity: (json["humidity"] as num?)?.toDouble() ?? 0.0,
        dew: (json["dew"] as num?)?.toDouble() ?? 0.0,
        precip: (json["precip"] as num?)?.toDouble() ?? 0.0,
        snow: (json["snow"] as num?)?.toDouble() ?? 0.0,
        snowdepth: (json["snowdepth"] as num?)?.toDouble() ?? 0.0,
        windgust: (json["windgust"] as num?)?.toDouble() ?? 0.0,
        windspeed: (json["windspeed"] as num?)?.toDouble() ?? 0.0,
        winddir: (json["winddir"] as num?)?.toDouble() ?? 0.0,
        pressure: (json["pressure"] as num?)?.toDouble() ?? 0.0,
        visibility: (json["visibility"] as num?)?.toDouble() ?? 0.0,
        cloudcover: (json["cloudcover"] as num?)?.toDouble() ?? 0.0,
        solarradiation: (json["solarradiation"] as num?)?.toDouble() ?? 0.0,
        solarenergy: (json["solarenergy"] as num?)?.toDouble() ?? 0.0,
        uvindex: (json["uvindex"] as num?)?.toDouble() ?? 0.0,
        severerisk: (json["severerisk"] as num?)?.toDouble() ?? 0.0,
        conditions:
            conditionsValues.map[json["conditions"] as String? ?? 'Clear'],
        sunrise: json["sunrise"] as String?,
        sunriseEpoch: (json["sunriseEpoch"] as num?)?.toDouble() ?? 0.0,
        sunset: json["sunset"] as String?,
        sunsetEpoch: (json["sunsetEpoch"] as num?)?.toDouble() ?? 0.0,
        moonphase: (json["moonphase"] as num?)?.toDouble(),
        tempmax: (json["tempmax"] as num?)?.toDouble(),
        tempmin: (json["tempmin"] as num?)?.toDouble(),
        feelslikemax: (json["feelslikemax"] as num?)?.toDouble(),
        feelslikemin: (json["feelslikemin"] as num?)?.toDouble(),
        precipcover: (json["precipcover"] as num?)?.toDouble(),
        description: descriptionValues
            .map[json["description"] as String? ?? 'Description not available'],
        hours: (json["hours"] as List?)
                ?.map((x) => CurrentConditions.fromJson(x))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "datetime": datetime,
        "datetimeEpoch": datetimeEpoch,
        "temp": temp,
        "feelslike": feelslike,
        "humidity": humidity,
        "dew": dew,
        "precip": precip,
        "snow": snow,
        "snowdepth": snowdepth,
        "windgust": windgust,
        "windspeed": windspeed,
        "winddir": winddir,
        "pressure": pressure,
        "visibility": visibility,
        "cloudcover": cloudcover,
        "solarradiation": solarradiation,
        "solarenergy": solarenergy,
        "uvindex": uvindex,
        "severerisk": severerisk,
        "conditions": conditionsValues.reverse[conditions],
        "sunrise": sunrise,
        "sunriseEpoch": sunriseEpoch,
        "sunset": sunset,
        "sunsetEpoch": sunsetEpoch,
        "moonphase": moonphase,
        "tempmax": tempmax,
        "tempmin": tempmin,
        "feelslikemax": feelslikemax,
        "feelslikemin": feelslikemin,
        "precipcover": precipcover,
        "description": descriptionValues.reverse[description],
        "hours": hours == null
            ? []
            : List<dynamic>.from(hours!.map((x) => x.toJson())),
      };
}

enum Conditions {
  CLEAR,
  OVERCAST,
  PARTIALLY_CLOUDY,
  RAINPARTCLOUDY,
  RAIN_OVERCAST,
  SNOW_PARTIALLY_CLOUDY,
  SNOW_OVERCAST
}

final conditionsValues = EnumValues({
  "Clear": Conditions.CLEAR,
  "Overcast": Conditions.OVERCAST,
  "Partially cloudy": Conditions.PARTIALLY_CLOUDY,
  "Rain, Partially cloudy": Conditions.RAINPARTCLOUDY,
  "Rain, Overcast": Conditions.RAIN_OVERCAST,
  "Snow, Overcast": Conditions.SNOW_OVERCAST,
  "Snow, Partially cloudy": Conditions.SNOW_PARTIALLY_CLOUDY,
});

enum Description {
  BECOMING_CLOUDY_IN_THE_AFTERNOON,
  CLEARING_IN_THE_AFTERNOON,
  PARTLY_CLOUDY_THROUGHOUT_THE_DAY,
}

final descriptionValues = EnumValues({
  "Becoming cloudy in the afternoon.":
      Description.BECOMING_CLOUDY_IN_THE_AFTERNOON,
  "Clearing in the afternoon.": Description.CLEARING_IN_THE_AFTERNOON,
  "Partly cloudy throughout the day.":
      Description.PARTLY_CLOUDY_THROUGHOUT_THE_DAY,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }

  String getString(T enumValue) {
    // Assuming that the reverseMap contains a readable string for each enum value
    return reverseMap[enumValue] ?? enumValue.toString().split('.').last;
  }
}
