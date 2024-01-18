![KakaoTalk_20240117_202700706_01](https://github.com/jiseop9083/madcampWeek3/assets/64767436/358f94ab-4052-4e74-a003-6c389f1801b4)
![KakaoTalk_20240117_202700706](https://github.com/jiseop9083/madcampWeek3/assets/64767436/3a643263-9a4e-47d1-b32f-6e5a0085be4f)


## 1. 소개
** 눈사람이 눈덩이로 변해 굴러다니는 2D 플랫포머 게임입니다**
**굴러다니면서 여러 장애물들을 통과해보세요!**




### 팀원

- **신지섭** 한양대학교 컴퓨터소프트웨어학부
- **이지안** KAIST 전산학부

### 개발 환경

- FE
  <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=Flutter&logoColor=white"/> 
- BE
  <img src="https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=FastAPI&logoColor=white"/>
- DB
  <img src="https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=MySQL&logoColor=white"/> 
- Language
  <img src="https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=Dart&logoColor=white"/> <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"/>








## 2. 규칙

- 눈사람이 주인공이 되어 목적지에 도달하는 간단한 플랫포머 게임입니다.

### 인터페이스

- 화면 상단을 클릭하면 점프를 할 수 있습니다
- 화면 왼쪽 하단을 클릭하면 왼쪽으로 이동할 수 있습니다.
- 화면 오른쪽 하단을 클릭하면 오른쪽으로 이동할 수 있습니다.
- 눈사람 모드(기본 모드)에서 눈사람을 클릭하면 구르기 모드로 전환됩니다.
- 구르기 모드에서 눈사람을 터치하면, 눈사람 모드로 전환할 수 있습니다.
- 오르막길에서 구르기 모드로 올라가면, 천천히 올라가게 됩니다.
- 내리막길에서 구르기 모드로 내려가면, 빠르게 내려 갈 수 있습니다.

### 게임 종료 및 점수

- 눈사람이 물에 빠져 녹으면 게임이 종료됩니다.
- 마지막 도착지점에 도달하면 게임이 종료됩니다.
- 점수는 시간 대비 이동 거리로 계산됩니다.
    - 도착지점에 도달해 게임이 종료되면 점수는 3배가 됩니다.

### 메인화면

- 로그인을 하고 게임을 플레이 할 수 있습니다.
    - 아이디/password 기반의 로그인을 할 수 있습니다.
- 로그인 없이 게임을 플레이 할 수 있습니다.

## 3. 플레이 영상

|영상1|영상2|
|------|---|
| ![로그인1](https://github.com/jiseop9083/madcampWeek3/assets/64767436/9cfa2aa4-0095-4219-9646-51afa350ba89) |  ![로그인3](https://github.com/jiseop9083/madcampWeek3/assets/64767436/aeff01b0-44b0-41eb-8b73-1e22a7440cea) |
| ▲ 로그인 화면 | ▲ 로그인 성공 |
| ![이동1](https://github.com/jiseop9083/madcampWeek3/assets/64767436/8321a001-bcff-440f-87ee-e4e961e36749) |  ![이동2](https://github.com/jiseop9083/madcampWeek3/assets/64767436/1cf41153-b7d5-4638-b486-2978e052df22) |
| ▲ 이동 화면 | ▲ 플랫폼을 이용한 이동 |
|  ![구르기1](https://github.com/jiseop9083/madcampWeek3/assets/64767436/c72ba781-9896-48e8-a73a-2811a7b03c4e) | ![구르기2](https://github.com/jiseop9083/madcampWeek3/assets/64767436/043294cb-3395-40f2-a436-bfc0b005df00) |
| ▲ 구르기 모드 | ▲ 언덕에서 구르기 모드 |
| ![구르기3](https://github.com/jiseop9083/madcampWeek3/assets/64767436/f0ec85f4-f777-472b-a446-a251b2104935) | ![구르기4](https://github.com/jiseop9083/madcampWeek3/assets/64767436/637ad59c-61d3-4dd9-a067-b0c9469065e4) |
| ▲ 구르기 모드로 낮은 곳 통과 | ▲ 가파른 언덕 |
| ![끝1](https://github.com/jiseop9083/madcampWeek3/assets/64767436/8a0ed0a7-6097-45be-b6d3-9a827d091bf1) | ![끝2](https://github.com/jiseop9083/madcampWeek3/assets/64767436/e6ad55f6-f7a3-46b5-bc0b-84d924779c86) | 
| ▲ 목적지 도달 시 게임 오버 | ▲ 물에 빠졌을 시 게임 오버 |





