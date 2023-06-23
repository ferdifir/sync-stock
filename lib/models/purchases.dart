class Purchases {
  final int idTrans;
  String? nama;
  final String tgl;
  final double qty;
  final double hbeli;
  int? hjualcr;
  final String nmSupplier;

  Purchases({
    required this.idTrans,
    required this.nama,
    required this.tgl,
    required this.qty,
    required this.hbeli,
    required this.hjualcr,
    required this.nmSupplier,
  });

  factory Purchases.fromJson(Map<String, dynamic> json) {
    return Purchases(
      idTrans: json['idtranst'],
      nama: json['nama'],
      tgl: json['tgl'],
      qty: double.parse(json['qty'].toString()),
      hbeli: double.parse(json['hbeli'].toString()),
      hjualcr: json['hjualcr'],
      nmSupplier: json['nmsupplier'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idtranst': idTrans,
        'nama': nama,
        'tgl': tgl,
        'qty': qty,
        'hbeli': hbeli,
        'hjualcr': hjualcr,
        'nmsupplier': nmSupplier,
      };
}
