# apill_app
apill_app

## 폴더 구조
### assets
모바일 앱에서 사용하는 정적 이미지, 아이콘, 폰트, 다국어, json 데이터 파일을 포함합니다.
※ Font 폴더는 루트 또는 Assets 하위에 생성
※ Assets 폴더는lib 하위에 생성하여도 무관함.(pubspec.yaml 파일에 lib 위치가 없어도 자동으로 폴더를 검색하여 찾아냄)

### lib
Flutter 개발 코드 파일을 포함합니다.

### models
프로젝트에 사용하는 모델 파일을 저장합니다.

### service
외부와 인터페이스를 하기 위한 로직 코드를 저장합니다. (WebAPI, Database, Share prefs 등)

### provider
Provider 패턴을 사용하는 경우 이 폴더에 프로바이더 관련 파일을 저장합니다.

### screens
고유한 화면 파일을 저장합니다. 해당 화면에서만 재사용되는 위젯 또는 비지니스 로직은 하위하위에 wedgets, util 폴더를 추가로 포함시킵니다.

### util
앱 전체에 사용되는 비지니스 로직을 저장합니다.

### widgets
앱 전체에 사용하는 공용 위젯 파일을 저장합니다.

### 기타
main.dart 및 routes.dart 파일은 lib 아래에 보관합니다.