안녕하세요 @havilog!
은행창구 매니저 리뷰를 맡아주셔서 감사합니다 😊
  
## 모듈화란?
모듈화란 프로젝트를 작은 단위로 쪼개 기능을 분리하고 재사용성을 높이는 개발방식입니다.
하나의 프로젝트에 모든 모듈과 코드가 구현되어 있는 기존 모놀리스 아키텍처 프로젝트와 달리
모듈화의 장점은 코드가 기능에 따라 분리되어 있으므로 수정이 용이해지고 재사용성이 높아진다는 것 입니다.

</br>

## 🤔 고민한점
### 1. 왜 3개의 모듈로 나뉘었을까?
`BankManagerConsoleApp` 와 `BanManagerUIApp` 모두 `BankManager` 모듈을 공통으로 사용하는 구조입니다.
이 두 앱이 기본적인 은행 관리 기능을 공유하고 있습니다. 즉, 이 공통 기능을 기반으로 콘솔 또는 GUI를 통해 상호작용을 제공한다는 것을 의미합니다.
결론적으로 `BankManager` 을 이용하여 각기 다른 방식으로 사용자에게 제공할 수 있음을 보여주는 예시라고 생각합니다.
1. 목적의 분리: 각 모듈의 특정 측면에 초점을 맞추어 코드베이스를 더 조직적이고 유지보수하기 쉽게 만듭니다.
2. 재사용성: 모듈은 다른 프로젝트에서도 재사용될 수 있어 중복을 줄여줍니다.
3. 확장성: 각 모은 독립적으로 업데이트될 수 있기 때문에 쉬운 확장과 유지보수를 가능하게 합니다.
4. 테스트 용이성: 세부적이고 효율적인 테스트 전략을 가능하게 합니다.


### 2. Queue의 구현 위치는?
요구사항에 주어진 `LinkedList`와 `Queue`를 어디에 구현할지 고민하였습니다.</br>
주어진 프로젝트는 두 개의 프로젝트 파일과 하나의 패키지 파일로 구성되어 있었고 두 개의 프로젝트 파일에서 Queue의 기능을 모두 사용하는 듯 하였습니다.
따라서 패키지 파일을 활용하는 것이 좋다고 생각하여 패키지 파일에 `Queue`를 구현하였습니다.

### 3. AccessControl 적용?
패키지 내부에 Queue를 구현하였기 때문에 이후 다른 프로젝트에서 Queue를 사용하기 위해서는 접근제어자 설정이 필요하다 생각하여 고민해보게 되었습니다.
Queue의 경우 외부에서 접근이 필요하기 때문에 `public`을 사용하였고 Queue 내부의 `list`의 경우 Queue 내부에서만 접근이 가능해야 하므로 private을 설정해주었습니다.
</br>

감사합니다🫰


# STEP2 PR
안녕하세요 @havilog!
은행창구 매니저 STEP2 PR 드립니다 🙌
## 🤔 고민한 점
### ✨ 비동기 처리 방식
- 내용: 은행 업무에서 기존의 동기적 방식과 단일 고객 처리 메소드에서 벗어나 더 효율적이고 명확한 비동기 처리 방식을 모색하였습니다. 특히 `async/await` 를 선택하게 된 이유는 swift 에서는 `async/await` 와 함께 `Task`와 같은 동시성 프리미티브를 제공하여 동시성 관리의 용이성이 있기 때문에 선택하게 되었습니다. 그리고 기존 콜백(callback) 방식이나 Promise 기반의 코드에 비해 훨씬 직관적이고 간결하게 비동기 로직을 표현할 수 있어 좋은 선택이라고 생각하였습니다.
- 결과: `async/await` 패턴을 활용하여 은행 업무 처리를 개선하였습니다. 
    - `Bank` 구조체 내의 `processWorkforOneBanker` 메소드를 `preceedBankWork` 로 변경하고, 비동기 처리 방식을 적용하여 은행 업무 처리 로직을 개선했습니다.
    - 기존 로직과의 호환성 및 전환 과정에서 발생할 수 있는 문제들을 예측하고 대비하는 것에도 주의를 기울였습니다.
### 1. Bank와 Customer의 타입 구현
- 내용: 요구사항에 따라 `Bank`와 `Customer`의 타입을 구현하며 각각의 타입을 `class` 또는 `struct` 중 무엇으로 구현해야할지 고민하였습니다.
- 결과: 우선 두 타입 모두 `struct`로 구현한 뒤 `Bank`의 경우 객체를 생성 후 내부 프로퍼티(고객 Queue)를 공유해야한다는 점을 고려하여 `class`로 타입을 변경하였습니다.
### 2. 접근제어자 설정
- 내용: 모듈 내부에 구현한 타입을 다른 모듈에서 접근할 수 있도록 하기 위해 접근제어자 설정을 고민하였습니다.
- 결과: 처음에는 Bank 자체를 public으로 설정하여 외부 모듈에서 직접 접근할 수 있도록 하였습니다.
하지만 이는 모듈의 은닉성을 해친다고 생각하여 Bank를 private로 변경 후 Bank에 접근할 수 있는 public 함수를 생성하여 해당 함수를 통해서 Bank에 접근할 수 있도록 수정하였습니다.

## 📱 실행화면
![img](<https://github.com/Diana-yjh/ios-bank-manager/blob/step2/BankManager_Step2.gif>)

감사합니다 ☺️


# Readme
### 목차
[1. 소개](#1-소개)  
[2. 팀원](#2-팀원)  
[3. 타임라인](#3-타임라인)  
[4. 실행 화면](#4-실행-화면)  
[5. 트러블슈팅](#5-트러블슈팅)  
[6. 팀 회고](#6-팀-회고)  
[7. 참고 자료](#7-참고-자료)  

---
### 1. 소개
#### **🏦은행 창구 매니저🏦**
10명에서 30명 사이의 고객들이 방문하는 은행창구 어플입니다.
총 3명의 직원들이 고객들의 대출, 예금 업무를 친절히 도와줍니다!

### 2. 팀원
| <img src="https://avatars.githubusercontent.com/u/65929788?v=4" width="200"> |<img src = "https://avatars.githubusercontent.com/u/57698939?v=4" width="200">|
| :---: | :---: |
| Hamzzi ([Github](https://github.com/kkomgi)) | Diana([Github](https://github.com/Diana-yjh)) |

### 3. 타임라인
| 날짜         | 커밋 요약                                               |
|------------|-------------------------------------------------------|
| 2024-03-18 | LinkedList 타입 생성 및 구현 등                                   |
| 2024-03-19 | Queue에 AccessControl 적용 등                                   |
| 2024-03-20 | Banker 타입 생성 및 메서드 작성 등                                |
| 2024-03-21 | BankTests 구현                                           |
| 2024-03-22 | BankManager 콘솔 실행을 위한 openBank 생성 등                     |
| 2024-03-23 | 실행화면 gif 추가 등                                         |
| 2024-03-25 | Mac 최소 지원 버전 설정 후 분기 삭제 등                            |
| 2024-03-27 | name을 waitingCustomer로 수정 등                              |


### 4. 실행 화면
<img src= "https://github.com/Diana-yjh/ios-bank-manager/blob/step2/BankManager_Step2.gif?raw=true">

### 5. 트러블슈팅
#### 1) Task Sleep 사용시 iOS와 macOS 버전 오류
##### 문제 상황
Thread 실행에 Delay를 주기 위해 Task.sleep()을 사용하였는데 해당 기능은 iOS 13 및 macOS 10.5 이상에서만 사용 가능한 문제 발생
```
let package = Package(
    ...
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        ...
    ],
    targets: [
        ...
    ]
)
```
Package.swift 파일 내부에서 `platform` 항목에 iOS 및 macOS 버전을 설정하여 해결

#### 2) 고객 추가 로직 변경

**변경 전**:
```swift
// 고정된 수의 고객을 추가
func addCustomer() {
    for number in 1...10 { // 항상 10명의 고객만 추가
        let customer = Customer(number: number)
        waitingCustomers.enqueue(customer)
    }
}
```
- **설명**: 과거 코드는 항상 고정된 10명의 고객만을 대기열에 추가했습니다. 이는 실제 은행에서 발생할 수 있는 다양한 상황을 모사하는 데 제한적이었습니다.

**변경 후**:
```swift
// 주어진 범위 내에서 랜덤한 수의 고객을 생성하여 추가
func addCustomer(with range: ClosedRange<Int>) {
    let totalCustomers = Int.random(in: range)
    for number in 1...totalCustomers {
        let customer = Customer(number: number)
        waitingCustomers.enqueue(customer)
    }
}
```
- **설명**: 변경된 로직은 고객 수를 랜덤화하여, 매일 다른 수의 고객이 은행을 방문하는 현실적인 시나리오를 더 잘 반영합니다.

#### 3) 비동기 업무 처리 로직 도입

**변경 전**:
```swift
// 동기적인 업무 처리
func processCustomer(_ customer: Customer) {
    print("\(customer.waitingNumber) 업무 시작")
    Thread.sleep(forTimeInterval: 0.7) // 예시: 0.7초 동안 스레드 중지
    print("\(customer.waitingNumber) 업무 완료")
}
```
- **설명**: 이전 코드는 `Thread.sleep`을 사용해 동기적으로 고객 업무를 처리했습니다. 이 방식은 현재 작업을 완전히 중단시키고, 동시에 여러 업무를 처리하는 데 비효율적입니다.

**변경 후**:
```swift
// 비동기적인 업무 처리
func processCustomer(_ customer: Customer) async throws {
    print("\(customer.waitingNumber) 업무 시작")
    try await Task.sleep(nanoseconds: 700_000_000)
    print("\(customer.waitingNumber) 업무 완료")
}
```
- **설명**: `async`/`await`와 `Task.sleep`을 사용하는 비동기 처리 방식으로 변경되었습니다. 이를 통해 다른 작업을 차단하지 않고도 비동기적으로 업무 처리를 기다릴 수 있게 되어, 여러 고객을 동시에 처리할 수 있는 능력이 향상됩니다.

#### 4) 데이터 구조 활용 강화

**변경 전**:
```swift
// 단순 배열을 이용한 고객 관리
var waitingCustomers: [Customer] = []

func enqueue(_ customer: Customer) {
    waitingCustomers.append(customer)
}

func dequeue() -> Customer? {
    return waitingCustomers.count > 0 ? waitingCustomers.removeFirst() : nil
}
```
- **설명**: 배열 기반의 구현은 간단하지만, 대기열 앞에서의 요소 추가나 제거 시 시간 복잡도가 O(n)이 되어, 대기열의 길이가 길어질수록 성능이 저하됩니다.

**변경 후**:
```swift
// LinkedList를 기반으로 한 Queue를 사용한 고객 관리
struct Queue<Element> {
    private var list = LinkedList<Element>()
    var isEmpty: Bool { list.isEmpty }
    mutating func enqueue(_ value: Element) { list.append(value) }
    mutating func dequeue() -> Element? { return list.removeFirst() }
}
```
- **설명**: 연결 리스트를 기반으로 한 큐 구현으로 변경되었습니다. 이는 요소의 추가 및 제거 시 상수 시간 O(1) 복잡도를 가지므로, 대기열의 길이에 관계없이 일정한 성능을 유지할 수 있습니다. 이러한 변경은 고객 대기열의 효율적 관리를 가능하게 하여, 전반적인 시스템 성능을 향상시킵니다.

### 6. 팀 회고
- 🎯 우리 팀의 자랑!
   - 꾸준한 소통을 통해 끝까지 같이 으쌰으쌰 할 수 있었습니다!
   - 서로의 의견을 이야기하고 적극 수용해주어 많이 배울 수 있었습니다

- 📝 우리 팀의 반성!
    - STEP 진행도가 미흡하다는 점이 아쉬웠습니다.

### 7. 참고 자료
📍[async/await](<https://developer.apple.com/videos/play/wwdc2021/10132/>)  
📍[async/await 사용법](<https://ios-development.tistory.com/958>)  
📍[TaskSleep](<https://www.hackingwithswift.com/quick-start/concurrency/how-to-make-a-task-sleep>)  
📍[AccessControl](<https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/>)  
📍[DynamicDispatch](<https://babbab2.tistory.com/143>)  
📍[Modularization](<https://www.youtube.com/watch?v=BjK42O8Lt48>)  
📍[SwiftPackageManager](<https://tech.kakao.com/2022/06/02/swift-package-manager/>)  
📍[Package.swift](<https://velog.io/@sean_kk/Package-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-%EC%83%9D%EC%84%B1-%EB%B0%8F-%EB%B0%B0%ED%8F%AC>)  
