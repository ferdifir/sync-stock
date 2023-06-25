// Shared Preferences Configurations
const String firstTimePrefKey = 'firstTime';
const String dbUserVersion = 'dbUserVersion';
const String dbMasterVersion = 'dbMasterVersion';
const String dbSalesVersion = 'dbSalesVersion';
const String dbPurchasesVersion = 'dbPurchasesVersion';
const String levelPrefKey = 'level';
const String namePrefKey = 'name';
const String emailPrefKey = 'email';
const String rememberMePrefKey = 'rememberMe';
const String firstTimeSync = 'firstTime';

// HTTP Request
const String baseUrl = 'https://api.syssolution.online';
const String userApi = '/users';
const String masterApi = '/products';
const String salesApi = '/sales';
const String purchaseApi = '/purchases';

// Local Database
const String dbName = 'syssolution.db';
const String dbUsers = 'syssolutionuser.db';
const String dbMaster = 'syssolutionmaster.db';
const String dbSales = 'syssolutionsales.db';
const String dbPurchases = 'syssolutionpurchases.db';

// Query Database
const List<String> dbUsersQuery = [
  'id INTEGER PRIMARY KEY',
  'username TEXT',
  'password TEXT',
  'nama_lengkap TEXT',
  'email TEXT',
  'no_telp TEXT',
  'level TEXT',
  'blokir TEXT',
  'id_session TEXT'
];
const List<String> dbMasterQuery = [
  'kd_brg TEXT PRIMARY KEY',
  'nama TEXT',
  'sat TEXT',
  'hjual INTEGER',
  'hjualcr INTEGER',
  'akhir_g TEXT',
  'pak TEXT',
  'aktif INTEGER',
  'nmsupplier TEXT',
  'tglbeli DATE'
];
const List<String> dbSalesQuery = [
  'idsales INTEGER PRIMARY KEY AUTOINCREMENT',
  'nmcustomer TEXT',
  'nama TEXT',
  'sat TEXT',
  'qty TEXT',
  'hjual TEXT',
  'ecer INTEGER',
  'pak TEXT',
  'nota TEXT',
  'tgl DATE',
  'hbeli TEXT',
  'kdsales TEXT'
];
const List<String> dbPurchasesQuery = [
  'idtranst INTEGER PRIMARY KEY',
  'nama TEXT',
  'tgl DATE',
  'qty TEXT',
  'hbeli TEXT',
  'hjualcr INTEGER',
  'nmsupplier TEXT'
];
