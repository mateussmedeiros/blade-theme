---
layout: post
title: TOAST Cloud Object Storage 이용하기
date: 2017-02-19
description: TOAST Cloud Object Storage 이용하기
permalink: /2017/02/19/Object-Storage/
---
## 1. 사전 준비
1. <http://cloud.toast.com/> 접속
2. CONSOLE -> 프로젝트 선택
3. Infrastruture -> Object Storage
4. API Endpoint 설정 확인


## 2. 인증 Token 발급
Token은 Object Storage의 RESTFul API사용을 위해 발급받아야 하는 인증키이다. Token은 Account 별로 관리된다.

[ Method, URL ]

```
POST   https://api-compute.cloud.toast.com/identity/v2.0/tokens
```

[ Request Body Example ]

```
{
  "auth": {
    "tenantName": "X1k372c9",
    "passwordCredentials": {
      "username": "test@nhnent.com",
      "password": "..."
    }
  }
}
```

[ Request Parameters ]

| 이름 | 종류 | 속성 | 설명 |
| --- | --- | --- | --- |
| TenantName | Body or Plain | String | TOAST Cloud의 Project ID |
| Username | Plain | String | TOAST Cloud의 사용자 ID, 현재 Project에 member로 등록된 사용자 |
| Password | Plain | String | 사용자 비밀번호,  대화창에서 지정한 비밀번호 |

[ Code ]

```
@Autowired
private RestTemplate restTemplate;

private String accessTokenId;

public void setAuthToken() throws URISyntaxException {
	URIBuilder uriBuilder = new URIBuilder(CLOUD_STORAGE_TOKEN_URl);

	HttpHeaders headers = new HttpHeaders();
	headers.setContentType(MediaType.APPLICATION_JSON);
	HttpEntity<String> param = new HttpEntity<String>(CLOUD_TOKEN_REQ_JSON, headers);

	String url = uriBuilder.build().toString();

	CloudResult cloudResult = restTemplate.postForObject(url, param, CloudResult.class);
	accessTokenId = cloudResult.getAccess().getToken().getId(); //Id만 사용
	LOGGER.info("Cloud Object Storage Access Token Id : " + accessTokenId);
}
```

[ Request Class ]

```
public class CloudResult {

	private Access access;

	public Access getAccess() {
		return access;
	}

	public void setAccess(Access access) {
		this.access = access;
	}

	public static class Access {

		private Token token;

		public Token getToken() {
			return token;
		}

		public void setToken(Token token) {
			this.token = token;
		}
	}

	public static class Token {
		private String id;

		public String getId() {
			return id;
		}

		public void setId(String id) {
			this.id = id;
		}
	}
}
```

[ Refresh Token ]

```
@Scheduled(fixedDelay = 3000000)
public void refreshCloudToken() {
	try {
		setAuthToken();
		LOGGER.info("Token refresh time : " + (new Date()).getTime());
	} catch (URISyntaxException e) {
		LOGGER.error("Cloud Token Refresh Error!");
	}
}
```

>Token 발급 응답은 “expires” field를 포함하고 있다. 이 field는 발급받은 Token이 언제까지 유효한지를 알려준다. 매번 새로운 Token을 발급받을 필요 없이, 이 정보를 사용해 Token의 유효 기간을 확인하고 갱신할 수 있도록 해아한다.

## 3. Object 올리기
지정한 Container에 새로운 Object를 생성한다. Container은 TOAST Cloud Console이나 PUT요청을 통해 관리할 수 있다.

[ Method, URL ]

```
PUT   https://api-storage.cloud.toast.com/v1/{Account}/{Container}/{Object}
X-Auth-Token: {Token ID}
```

[ Request Parameters ]

| 이름 | 종류 | 속성 | 설명 |
| --- | --- | --- | --- |
| X-Auth-Token | Header | String | 발급 받은 Token의 ID |
| Account | URL | String | 사용자 계정명, <API Endpoint> 대화창에서 확인 |
| Container | URL | Container 이름 |
| Object | URL | String | 생성할 Object 이름 |
| - | Body | Plain | Text 생성할 Object의 내용 |

>요청 시 Header의 Content-type 항목의 값을 Object의 속성에 맞게끔 설정 해야 한다. 정상적으로 요청된 경우 상태코드로 201를 반환한다.

[ Code ]

```
public String uploadFile(MultipartFile file, String fileName) throws URISyntaxException, IOException {
	URIBuilder uriBuilder = new URIBuilder(
			CLOUD_STORAGE_URI + CLOUD_ENDPOINT_ACCOUNT + CLOUD_CONTAINER_NAME + "/" + fileName);

	HttpHeaders headers = new HttpHeaders();
	headers.set("X-Auth-Token", accessTokenId);
	headers.setContentType(MediaType.MULTIPART_FORM_DATA);

	String url = uriBuilder.build().toString();
	HttpEntity<ByteArrayResource> param = new HttpEntity<ByteArrayResource>(new ByteArrayResource(file.getBytes()),
			headers);
	restTemplate.put(url, param);
		
	return url;
}
```

TOAST Cloud의 Object Storage를 통해 이미지 파일을 올리는 코드를 작성했다.
Storage에 올라간 이미지는 Container가 private로 생성되었을 경우에는 Token ID와 함께 GET요청을 보내 내려 받을 수 있다. Container가 public으로 생성된 경우에는 Public URL을 통해 바로 접근이 가능하다.

[ Object 내려 받기 ]

```
https://api-storage.cloud.toast.com/v1/{Account}/{Container}/{Object}
X-Auth-Token: {Token ID} //private의 경우
```

[ 참고 ]

* <http://docs.cloud.toast.com/ko/Infrastructure/Object%20Storage/Developer%60s%20Guide/>
