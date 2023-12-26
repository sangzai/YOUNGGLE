import 'package:mysql_client/mysql_client.dart';

Future<void> dbConnector(String sql) async {
  print("sql접속중");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: 'project-db-campus.smhrd.com',
    port: 3307,
    userName: 'ttap',
    password: '1234',
    databaseName: 'ttap', // optional
  );

  await conn.connect();

  print("Connected");

  try {
    // 전달받은 SQL 쿼리 실행
    var result = await conn.execute(sql);

    if (result.isNotEmpty) {
      for (final row in result.rows) {
        print("row.assoc() : ${row.assoc()}");
      }
    }
  } catch (e) {
    print("Error executing query: $e");
  } finally {
    // 연결 종료
    await conn.close();
  }
}

// 페이지 임포트 후 밑에와 같이 실행 ^^
//
// void main() {
//   // 다른 페이지에서 SQL 문 전달
//   var sql = 'select * from mibandinterval';
//   dbConnector(sql);
// }