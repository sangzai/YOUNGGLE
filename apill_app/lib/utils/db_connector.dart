import 'package:mysql_client/mysql_client.dart';

Future<Iterable<ResultSetRow>?> dbConnector(String sql, [Map<String, dynamic>? params]) async {
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
    var result = await conn.execute(sql,params);

    return result.rows;
    // if (result.isNotEmpty) {
    //   for (final row in result.rows) {
    //     print("row.assoc() : ${row.assoc()}");
    //   }
    // }
  } catch (e) {
    print("쿼리 실행 오류: $e");
    return null;
  } finally {
    // 연결 종료
    await conn.close();
  }
}