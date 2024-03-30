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
- **설명**: 과거 코드는 항상 고정된 10명의 고객만을 대기열에 추가해 제한적이었습니다.

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
- **설명**: 변경된 로직은 고객 수를 랜덤화하여 매일 다른 수의 고객이 은행을 방문하는 시나리오를 만들었습니다.

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
- **설명**: 배열 기반의 구현은 간단하지만, 대기열 앞에서의 요소 추가나 제거 시 시간 복잡도가 O(n)이 되어, 대기열의 길이가 길어질수록 성능이 저하되는 문제가 있었습니다.

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
- **설명**: 연결 리스트를 기반으로 한 큐 구현으로 변경되었습니다. 이는 요소의 추가 및 제거 시 상수 시간 O(1) 복잡도를 가지므로, 대기열의 길이에 관계없이 일정한 성능을 유지할 수 있습니다. 이러한 변경은 고객 대기열의 효율적 관리를 가능하게 하게 하였습니다.

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
