class Sales {
  final String nmCustomer;
  String? nama;
  String? sat;
  final double qty;
  final double hjual;
  final int ecer;
  String? pak;
  final String nota;
  final String tgl;
  String? hbeli;
  final String kdsales;

  Sales({
    required this.nmCustomer,
    this.nama,
    this.sat,
    required this.qty,
    required this.hjual,
    required this.ecer,
    this.pak,
    required this.nota,
    required this.tgl,
    this.hbeli,
    required this.kdsales,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      nmCustomer: json['nmcustomer'] as String,
      nama: json['nama'],
      sat: json['sat'],
      qty: double.parse(json['qty'].toString()),
      hjual: double.parse(json['hjual'].toString()),
      ecer: json['ecer'] as int,
      pak: json['pak'],
      nota: json['nota'] as String,
      tgl: json['tgl'] as String,
      hbeli: json['hbeli'],
      kdsales: json['kdsales'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'nmcustomer': nmCustomer,
        'nama': nama,
        'sat': sat,
        'qty': qty,
        'hjual': hjual,
        'ecer': ecer,
        'pak': pak,
        'nota': nota,
        'tgl': tgl,
        'hbeli': hbeli,
        'kdsales': kdsales,
      };
}
