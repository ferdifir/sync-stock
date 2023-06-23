class Master {
  final String kdBrg;
  final String nama;
  final String sat;
  final hjual;
  final hjualcr;
  final String akhirG;
  final String pak;
  final aktif;
  String? nmSupplier;
  final String tglBeli;

  Master({
    required this.kdBrg,
    required this.nama,
    required this.sat,
    required this.hjual,
    required this.hjualcr,
    required this.akhirG,
    required this.pak,
    required this.aktif,
    required this.nmSupplier,
    required this.tglBeli,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      kdBrg: json['kd_brg'],
      nama: json['nama'],
      sat: json['sat'],
      hjual: json['hjual'],
      hjualcr: json['hjualcr'],
      akhirG: json['akhir_g'],
      pak: json['pak'],
      aktif: json['aktif'],
      nmSupplier: json['nmsupplier'],
      tglBeli: json['tglbeli'],
    );
  }

  Map<String, dynamic> toJson() => {
        'kd_brg': kdBrg,
        'nama': nama,
        'sat': sat,
        'hjual': hjual,
        'hjualcr': hjualcr,
        'akhir_g': akhirG,
        'pak': pak,
        'aktif': aktif,
        'nmsupplier': nmSupplier,
        'tglbeli': tglBeli,
      };
}
