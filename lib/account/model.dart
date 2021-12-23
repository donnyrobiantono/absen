class MProfile {
  late String username;
  late String namaPegawai;
  late String bagian;
  late String nip;
  late String latitude;
  late String longitude;
  late String atasan;
  late String perangkat;

  MProfile(
      {required this.username,
      required this.namaPegawai,
      required this.bagian,
      required this.nip,
      required this.latitude,
      required this.longitude,
      required this.atasan,
      required this.perangkat});

  factory MProfile.fromJson(Map<String, dynamic> json) {
    return MProfile(
      username: json['username'],
      namaPegawai: json['nama_pegawai'],
      bagian: json['bagian'],
      nip: json['nip'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      atasan: json['atasan'],
      perangkat: json['perangkat'],
    );
  }
}
