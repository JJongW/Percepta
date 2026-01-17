# Percepta MVP - 프로젝트 구조 문서

## 개요

Percepta는 iPadOS 전용 MVP 앱으로, 사용자가 매일 30초 정도 소요하여 경제 인식을 기록하는 앱입니다. 이 문서는 Clean Architecture 원칙을 따르되 MVP 범위에 맞춘 간단하고 명확한 프로젝트 구조를 설명합니다.

## 프로젝트 구조

```
Percepta/
├── PerceptaApp.swift              # 앱 진입점
├── ContentView.swift              # (사용 안 함, 기본 템플릿)
│
├── Domain/                        # 도메인 레이어
│   └── Models/
│       ├── Mood.swift             # 무드 enum (stable/neutral/anxious)
│       └── PerceptionEntry.swift  # 기록 데이터 모델
│
├── Data/                          # 데이터 레이어
│   └── PerceptionRepository.swift # 로컬 저장소 관리 (UserDefaults)
│
└── Presentation/                  # 프레젠테이션 레이어
    ├── Coordinators/
    │   ├── Coordinator.swift            # Coordinator 프로토콜
    │   └── AppCoordinator.swift         # 앱 네비게이션 관리
    ├── Screens/
    │   ├── TodayCheckInScreen.swift     # 화면 1: 오늘 기록
    │   └── RecordCompleteScreen.swift   # 화면 2: 기록 완료
    └── ViewModels/
        ├── TodayCheckInViewModel.swift  # 화면 1 ViewModel
        └── RecordCompleteViewModel.swift # 화면 2 ViewModel
```

## 레이어 설명

### Domain Layer (도메인 레이어)

비즈니스 로직과 데이터 모델을 포함합니다. 다른 레이어에 의존하지 않는 순수한 Swift 타입들입니다.

#### `Mood.swift`
- **목적**: 사용자가 선택할 수 있는 경제 인식 상태를 나타내는 enum
- **값**: `stable` (안정적), `neutral` (보통), `anxious` (불안)
- **기능**:
  - UI 표시용 이모지 제공 (`emoji` 프로퍼티)
  - 한글 라벨 제공 (`displayName` 프로퍼티)

#### `PerceptionEntry.swift`
- **목적**: 하루의 경제 인식 기록을 나타내는 데이터 모델
- **프로퍼티**:
  - `id: UUID` - 고유 식별자
  - `dateKey: String` - 날짜 키 (yyyy-MM-dd 형식, Asia/Seoul 기준)
  - `mood: Mood` - 선택한 무드
  - `note: String` - 메모 (0-100자, 빈 문자열 허용)
  - `createdAt: Date` - 생성 시각
- **기능**:
  - 오늘 날짜 키 생성 (`todayDateKey()`)
  - UI 표시용 날짜 포맷팅 (`formattedDate`)

### Data Layer (데이터 레이어)

데이터 영속성을 담당합니다. MVP 범위에서는 UserDefaults를 사용하여 간단하게 구현했습니다.

#### `PerceptionRepository.swift`
- **목적**: 경제 인식 기록의 로컬 저장소 관리
- **저장 방식**: UserDefaults + JSON 인코딩/디코딩
- **설계 이유**:
  - MVP 범위에서는 UserDefaults로 충분히 간단하고 빠름
  - Core Data는 과도한 추상화 (MVP에서는 불필요)
  - JSON 인코딩/디코딩으로 충분한 데이터 영속성 제공
- **주요 메서드**:
  - `saveTodayEntry(_:)` - 오늘의 기록 저장/업데이트 (덮어쓰기)
  - `getTodayEntry()` - 오늘의 기록 조회
  - `getRecentEntries(maxCount:)` - 최근 기록 조회 (기본 7일)

### Presentation Layer (프레젠테이션 레이어)

UI와 사용자 상호작용을 담당합니다. Coordinator 패턴을 사용하여 네비게이션을 관리하고, SwiftUI View와 ViewModel로 구성됩니다.

#### Coordinators (네비게이션 관리)

##### `Coordinator.swift`
- **목적**: Coordinator 패턴의 기본 프로토콜 정의
- **역할**: 네비게이션 로직을 View와 ViewModel에서 분리
- **이점**:
  - View는 UI 렌더링에만 집중
  - ViewModel은 비즈니스 로직에만 집중
  - 테스트 가능한 네비게이션 로직

##### `AppCoordinator.swift`
- **목적**: 앱의 전체 네비게이션 흐름 관리
- **기능**:
  - Route enum으로 앱의 모든 화면 정의
  - NavigationPath를 사용한 화면 전환 관리
  - `navigate(to:)` - 특정 화면으로 이동
  - `dismiss()` - 이전 화면으로 돌아가기
  - `popToRoot()` - 루트 화면으로 돌아가기
  - `view(for:)` - Route에 해당하는 View 생성
- **MVP 적용**:
  - 2개 화면(TodayCheckIn, RecordComplete) 간 전환 관리
  - 중앙집중식 네비게이션으로 유지보수 용이

#### Screens (화면)

#### `TodayCheckInScreen.swift`
- **목적**: 오늘의 경제 인식 기록 화면
- **구성 요소**:
  - 날짜 표시 (오늘)
  - 고정된 질문 텍스트
  - 3개의 큰 무드 선택 버튼
  - 한 줄 메모 입력 필드 (최대 100자)
  - "오늘 기록하기" CTA 버튼 (무드 선택 후 활성화)
- **네비게이션**: Coordinator를 통해 기록 저장 후 `RecordCompleteScreen`으로 이동
- **의존성**: `AppCoordinator` 주입받아 사용

#### `TodayCheckInViewModel.swift`
- **목적**: `TodayCheckInScreen`의 비즈니스 로직 관리
- **기능**:
  - 기존 기록 로드 (오늘 이미 기록이 있으면 불러오기)
  - 기록 저장
  - CTA 버튼 활성화 상태 관리
  - 메모 텍스트 업데이트 (100자 제한)

#### `RecordCompleteScreen.swift`
- **목적**: 기록 완료 확인 및 최근 기록 리스트 표시
- **구성 요소**:
  - 확인 메시지
  - 최근 기록 리스트 (최대 7개)
  - 각 행: 날짜 + 무드 이모지 + 메모 미리보기
  - "내일 다시 기록하기" 버튼
- **네비게이션**: Coordinator를 통해 루트 화면(`TodayCheckInScreen`)으로 돌아가기
- **의존성**: `AppCoordinator` 주입받아 사용

#### `RecordCompleteViewModel.swift`
- **목적**: `RecordCompleteScreen`의 비즈니스 로직 관리
- **기능**: 최근 기록 로드 (최대 7일)

## 데이터 흐름

### 데이터 저장 흐름
```
사용자 입력
    ↓
TodayCheckInScreen (View)
    ↓
TodayCheckInViewModel (ViewModel)
    ↓
PerceptionRepository (Repository)
    ↓
UserDefaults (로컬 저장소)
```

### 네비게이션 흐름
```
사용자 액션 (버튼 클릭)
    ↓
Screen (View)
    ↓
AppCoordinator (네비게이션 관리)
    ↓
NavigationStack (화면 전환)
```

## MVP 제약사항

이 프로젝트는 MVP 범위에 맞춰 다음 제약사항을 따릅니다:

1. **iPadOS 전용**: iOS 프로젝트이지만 iPad 타겟만 지원
2. **로컬 저장소만**: 서버/클라우드 없이 UserDefaults만 사용
3. **인증 없음**: 게스트 사용자만 지원
4. **하루 하나 기록**: 같은 날짜의 기록은 덮어쓰기
5. **최대 7일 기록**: 최근 7일 기록만 표시
6. **간단한 UI**: 차트, 그래프, 숫자 없음

## 설계 원칙

### Clean Architecture 준수
- Domain → Data → Presentation 순서의 의존성 방향
- Domain 레이어는 다른 레이어에 의존하지 않음
- Data 레이어는 Domain 레이어에만 의존
- Presentation 레이어는 Domain과 Data 레이어에 의존

### Coordinator 패턴
- 네비게이션 로직을 View와 ViewModel에서 분리
- View는 UI 렌더링에만 집중
- ViewModel은 비즈니스 로직에만 집중
- Coordinator가 화면 전환을 담당하여 관심사 분리
- 테스트 가능하고 유지보수가 쉬운 네비게이션 구조

### MVP 원칙
- 과도한 추상화 지양
- 간단하고 읽기 쉬운 코드 선호
- 명확한 주석과 문서화
- 프로덕션 품질이지만 MVP 범위 유지

## 사용 예시

### 오늘 기록 저장
```swift
let viewModel = TodayCheckInViewModel()
viewModel.selectedMood = .neutral
viewModel.noteText = "오늘은 보통이었어요"
let entry = viewModel.saveEntry()
```

### 최근 기록 조회
```swift
let repository = PerceptionRepository.shared
let recentEntries = repository.getRecentEntries(maxCount: 7)
```

### Coordinator를 통한 네비게이션
```swift
// 기록 완료 화면으로 이동
let savedEntry = viewModel.saveEntry()
coordinator.navigate(to: .recordComplete(savedEntry))

// 루트 화면으로 돌아가기
coordinator.popToRoot()

// 이전 화면으로 돌아가기
coordinator.dismiss()
```

## 향후 확장 가능성

MVP 검증 후 다음 단계에서 고려할 수 있는 확장:
- Core Data로 마이그레이션 (대량 데이터 처리)
- 클라우드 동기화 (iCloud)
- 인증 시스템 추가
- 상세 기록 화면
- 통계 및 차트 기능

하지만 **현재는 MVP 범위를 엄격히 준수**하여 위 기능들은 구현하지 않습니다.

