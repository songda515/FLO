# FLO
- [프로그래머스 과제관 - FLO iOS 앱](https://programmers.co.kr/skill_check_assignments/2)의 요구사항을 바탕으로 개발한 앱입니다.
- 런치 스크린, 음악 재생 화면, 전체 가사 화면으로 구성된 하나의 음악 파일을 재생하는 앱을 개발했습니다.
- MVVM 구조로 앱을 구성했으며, Observable 클래스를 만들어 데이터 바인딩을 구현했습니다.
- 사용 라이브러리 : UIKit(Storyboard), AVPlayer, URLSession

## Demo (iPhone 11, iOS14.5)

<p align="center">
  <img src = "Images/Demo_iPhone11_iOS14_5.GIF" width="30%" height="30%">
</p>
 
## 👀 화면 구성 요소
- 스플래시 스크린
- 음악 재생 화면
  - 재생 중인 음악 정보(제목, 가수, 앨범 커버 이미지, 앨범명)
  - 현재 재생 중인 부분의 가사 하이라이팅
  - Seekbar, Play/Stop 버튼
- 전체 가사 보기 화면
  - 특정 가사로 이동할 수 있는 토글 버튼
  - 전체 가사 화면 닫기 버튼
  - Seekbar, Play/Stop 버튼

## 👣 Dev History
### [LaunchScreen] UI 개발 #1
1. LaunchScreen 스토리보드에 UIImageView 생성, 이미지 Asset 추가
2. iOS 13 이하버전에서 실행되도록 AppDelegate/SceneDelegate 에서 호환성 고려

### [Player] 음악 재생 화면 개발 #2
1. Storyboard와 Autolayout을 이용한 UIKit 기반의 UI 개발 
2. Network(APIManager) - 음악 정보 받아오기, Test code 작성해보기
3. MVVM 구조로 구현 & Observable 패턴 이용해 UI 업데이트하기
4. 재생 버튼을 누르면 음악이 재생되고, 일시정지 버튼을 누르면 음악이 일시정지되도록 개발
5. seekbar(slider)를 조작하여 재생 시작 시점을 이동시킬 수 있도록 개발
6. 재생 시 현재 재생되고 있는 구간대의 가사가 실시간으로 표시되도록 개발
7. 음악 재생 화면에서 가사 전체 화면으로 이동되도록 개발 (PlayerVC → LyricsVC)
8. 음악 재생 종료시 다시 재생되도록 개발

### [Lyrics] 전체 가사 화면 개발 #3
1. UITableView 를 이용해서 전체 가사 화면 UI 개발, 현재 가사의 Cell 하이라이팅
2. seekbar(slider)를 조작하여 재생 시작 시점을 이동시킬 수 있으며, 가사의 하이라이팅도 변경되도록 개발
3. 토글 버튼 on - 특정 가사 터치 시 해당 구간부터 재생되도록 개발
4. 토글 버튼 off - 특정 가사 터치 시 전체 가사 화면 닫기
5. 전체 가사 화면 닫기 버튼을 누르면, 음악 재생 화면으로 이동되도록 개발

## FLO 앱 개발 일지
### [#1. MVVM 패턴과 Data Binding](https://jellysong.tistory.com/105)
### [#2. TableView 로 가사 화면 개발하기](https://jellysong.tistory.com/106)

<details>
<summary>해결하지 못한 이슈</summary>
  <ul>
    <li>iOS 13 이하 버전의 시뮬레이터에서 앱이 작동되고 화면이 전환되지만, AVPlayer가 재생되지 않는 문제를 해결하지 못했다.</li>
    <li>또한, 프로그래머스의 페이지에서 제출후 실행한 웹 시뮬레이터의 iOS13 이하 버전에서는 앱이 실행되지 않는다.</li>
    <li>Error: halb_iobuffermanager::getiobuffer: the stream index is out of range</li>
    <li><a href="https://stackoverflow.com/questions/65918157/avplayer-is-not-working-for-ios-12-2-while-its-working-with-ios-14-3-with-xcode">[관련 링크1]</a> <a href="https://developer.apple.com/forums/thread/667921?page=2">[관련 링크2]</a></li>
  </ul>
</details>
