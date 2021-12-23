class mAbsen {
  mAbsen({
    required this.nip,
    required this.tanggal,
    required this.bulan,
    required this.tahun,
    required this.jam,
    required this.status,
    required this.story,
  });
  late final String? nip;
  late final String tanggal;
  late final String bulan;
  late final String tahun;
  late final String jam;
  late final String status;
  late final String story;
  
  mAbsen.fromJson(Map<String, dynamic> json){
    nip = json['nip'];
    tanggal = json['tanggal'];
    bulan = json['bulan'];
    tahun = json['tahun'];
    jam = json['jam'];
    status = json['status'];
    story = json['story'];
  }

}