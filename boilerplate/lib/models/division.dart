class VNDivision {
  List<Province> provinces = [];

  VNDivision();

  VNDivision.fromJson(Map<String, dynamic> json) {
    if (json['province'] != null) {
      json['province'].forEach((v) {
        provinces.add(Province.fromJson(v));
      });
    }
    if (json['district'] != null) {
      json['district'].forEach((v) {
        final district = District.fromJson(v);
        for(final p in provinces) {
          if(p.idProvince == district.idProvince) {
            p.districts.add(district);
            break;
          }
        }
      });
    }
    if (json['commune'] != null) {
      json['commune'].forEach((v) {
        final commune = Commune.fromJson(v);
        for(final p in provinces) {
          for(final d in p.districts) {
            if(d.idDistrict == commune.idDistrict) {
              d.communes.add(commune);
              break;
            }
          }
        }
      });
    }
  }
}

class Province {
  String? idProvince;
  String? name;
  List<District> districts = [];

  Province({this.idProvince, this.name});

  Province.fromJson(Map<String, dynamic> json) {
    idProvince = json['idProvince'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idProvince'] = idProvince;
    data['name'] = name;
    return data;
  }
}

class District {
  String? idProvince;
  String? idDistrict;
  String? name;

  List<Commune> communes = [];

  District({this.idProvince, this.idDistrict, this.name});

  District.fromJson(Map<String, dynamic> json) {
    idProvince = json['idProvince'];
    idDistrict = json['idDistrict'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idProvince'] = idProvince;
    data['idDistrict'] = idDistrict;
    data['name'] = name;
    return data;
  }
}

class Commune {
  String? idDistrict;
  String? idCommune;
  String? name;

  Commune({this.idDistrict, this.idCommune, this.name});

  Commune.fromJson(Map<String, dynamic> json) {
    idDistrict = json['idDistrict'];
    idCommune = json['idCommune'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idDistrict'] = idDistrict;
    data['idCommune'] = idCommune;
    data['name'] = name;
    return data;
  }
}