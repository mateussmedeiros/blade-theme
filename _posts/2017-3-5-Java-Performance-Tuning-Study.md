---
layout: post
title: 자바 성능 튜닝 스터디
date: 2017-03-05
description: 자바 성능 튜닝 스터디
permalink: /2017/03/05/Object-Storage/
---
### 1. Map, Set, List, Queue 의 차이점을 서술하시오.
* Map
    * Key와 Value의 쌍으로 구성된 객체이ㅡ 집합을 처리하기 위한 인터페이스이다. 이 객체는 중복되는 키를 허용하지 않는다.
    * 일반적으로 HashMap 클래스가 사용된다.
* Set
    * 중복을 허용하지 않는 집합을 처리하기 위한 인터페이스이다.
    * 일반적으로 HashSet 클래스가 사용된다.
* List
    * 순서가 있는 집합을 처리하기 위한 인터페이스이기 때문에 인덱스가 있어 위치를 지정하여 값을 찾을 수 있다. 중복을 허용한다.
    * 일반적으로 ArrayList 클래스가 사용된다.
* Queue
    * 여러 개의 객체를 처리하기 전에 담아서 처리할 때 사용하기 위한 인터페이스이다. 기본적으로 FIFO를 따른다.
    * 일반적으로 LinkedList 클래스가 사용된다.

### 2. reflection API 를 이용하여 매개변수로 넘어온 클래스의 종류 및 메소드 목록을 출력하는 메소드를 작성하시오.
```
public void getClassInfo(Class demoClass) {
  String className = demoClass.getName();
  System.out.format("Class Name: %s\n", className);

  String classConnicalName = demoClass.getCanonicalName();
  System.out.format("Class Canonical Name: %s\n", classConnicalName);

  String classSimpleName = demoClass.getSimpleName();
  System.out.format("Class Simple Name: %s\n", classSimpleName);

  String packageName = demoClass.getPackage().getName();
  System.out.format("Package Name: %s\n", packageName);

  String toString = demoClass.toString();
  System.out.format("toString: %s\n", toString);
  System.out.println("----------------------------");
  // method info
  Method[] method = demoClass.getDeclaredMethods();
  System.out.format("Declared methods: %d\n", method.length);
  for (Method met : method) {
    String methodName = met.getName();
    int modifier = met.getModifiers();
    String modifierStr = Modifier.toString(modifier);
    String returnType = met.getReturnType().getSimpleName();

    Class params[] = met.getParameterTypes();
    StringBuilder paramStr = new StringBuilder();
    int paramLen = params.length;
    if (paramLen != 0) {
      paramStr.append(params[0].getSimpleName()).append(" arg");
      for (int loop = 1; loop < paramLen; loop++) {
        paramStr.append(",").append(params[loop].getName()).append(" arg").append(loop);
      }
    }

    // method exception info
    Class exceptions[] = met.getExceptionTypes();
    StringBuilder exceptionStr = new StringBuilder();
    int exceptionLen = exceptions.length;
    if (exceptionLen != 0) {
      exceptionStr.append("throws").append(exceptions[0].getSimpleName());
      for (int loop = 1; loop < exceptionLen; loop++) {
        exceptionStr.append(",").append(exceptions[loop].getSimpleName());
      }
      System.out.format("%s %s %s(%s) %s\n", modifierStr, returnType, methodName, paramStr);
    }
  }
}
```

### 3. XML 파서인 SAX 와 DOM 파서의 특징 및 장단점을 서술하시오.
* SAX
    * 순차적 방식으로 XML을 처리한다.
    * 각 XML의 노드를 읽는 대로 처리하기 때문에 메모리에 부담이 DOM에 미해서 많지 않다.
    * Content 핸들러, Error 핸들러, DTD 핸들러, Entity 리졸버를 통해서 순차적인 이벤트를 처리하므로, 이미 읽은 데이터의 구조를 수정하거나 삭제하기 어렵다.
* DOM
    * 모든 XML을 읽어서 트리로 만든 후 XML을 처리한다.
    * 모든 XML을 메모리에 올려서 작업하기 때문에 메모리에 부담이 가게 된다.
    * 읽은 XML을 통하여 노드를 추가, 수정, 삭제하기 쉬운 구조로 되어있다.

### 4. JMX 에 대하여 서술하시오.
JMX(Java Management Extensions)는 자바 애플리케이션을 모니터링하기 위해서 만든 기술이다.


### 5. JMX를 모니터링할 수 있는 도구를 3개 이상 나열하고 링크도 포함시키시오.
* JVisualVM - [https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jvisualvm.html](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jvisualvm.html)
* JConsole - [http://docs.oracle.com/javase/7/docs/technotes/guides/management/jconsole.html](http://docs.oracle.com/javase/7/docs/technotes/guides/management/jconsole.html)
* Java Mission Control - [http://www.oracle.com/technetwork/java/javaseproducts/mission-control/index.html](http://www.oracle.com/technetwork/java/javaseproducts/mission-control/index.html)

### 6. Web access log 의 패턴을 확인해 보고, 각 패턴에 대하여 서술하시오.
로그 포맷 설정은 다음과 같이 되어있다.

>LogFormat "%h %1 %u %t \"%r\" %>s %b" common

위와 같이 % 뒤에 표시하고자 하는 데이터의 지시어를 지정하도록 되어 있다.

>127.0.0.1 - - [22/Oct/20XX:14:04:43 +0900] "GET /a.gif HTTP/1.1" 200 2326

* 127.0.0.1 (%h) - 서버에 요청을 한 클라이언트의 IP 주소이다.
* -(%1) - '-'로 표시되어 있기 때문에 요청한 정보가 없음을 의미한다. identd라는 사용자 인식 데몬이 클라이언트에서 동작하고 있을 경우에만 이 정보가 나타난다.
* -(%u) - HTTP 인증을 통하여 확인된 문서를 요청한 사용자의 ID가 표시된다.
* [22/Oct/20XX:14:04:43 +0900] (\"%r\") -  서버가 요청을 마친 시간이다. 즉, 웹 서버에서 해당 요청이 처리되어 종료된 시간으로 보면 된다.
* "GET /a.gif HTTP/1.1" (%>s) - 클라이언트에서 요청한 Request의 정보를 나타낸다.
* 200 (%>s) - 서버에서 클라이언트로 보낸 최종 상태 코드를 의미한다.
* 2326 (%b) - 클라이언트로 전송한 데이터의 크기가 표신된다.

### 7. 자바 GC 종류를 모두 나열 하시오.
1. Serial Collector - Young 영역과 Old 영역이 시리얼하게 처리되며 하나의 CPU를 사용한다.
2. Parralel Collector - Throughput Collector로도 알려진 방식이다. 이 방식의 목표는 다른 CPU가 대기 상태로 남아 있는 것을 최소화하는 것이다. 시리얼 콜렉터와 달리 Young 영역에서의 콜렉션을 병렬로 처리한다.
3. Parallel Compacting Collector - 병렬 콜렉터와 달리 Old영역 GC에서 새로운 알고리즘을 사용한다.
4. Concurrent Mark-Sweep (CMS) Collector - Low-Latency Collector로도 알려져 있으며, 힙 메모리의 영역의 크기가 클 때 적합하다. Young 영역에 대한 GC는 병렬 콜렉터와 동일하다.
5. Garbage First Collector - 앞서 소개된 콜렉터들은 모두 Young과 Old 영역의 주소가 물리적으로 Linear하게 나열되지만 G1은 그렇지 않다. CMS GC의 단점을 보완하지 위해 만들어졌으며 GC성능도 매우 빠르다.

### 8. GC 상황을 모니터링할 수 있는 도구를 3개 이상 나열하고, 링크도 포함시키시오.
* Visual GC - [http://www.oracle.com/technetwork/java/visualgc-136680.html](http://www.oracle.com/technetwork/java/visualgc-136680.html)
* Jstatd - [https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstat.html](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/jstat.html)
* HPJMeter - [https://h20392.www2.hpe.com/portal/swdepot/displayProductInfo.do?productNumber=HPJMETER](https://h20392.www2.hpe.com/portal/swdepot/displayProductInfo.do?productNumber=HPJMETER)

### 9. JMH 를 사용하여 Java SE 에 있는 List 를 구현한 클래스들의 추가/조회/삭제 기능의 성능을 비교하시오.

### 10. JMH 를 사용하여 Java SE 에 있는 Map을 구현한 클래스들의 추가/조회/삭제 기능의 성능을 비교하시오.

[ 참고 ]

* 개발자가 반드시 알아야 할 자바 성능 튜닝 이야기
