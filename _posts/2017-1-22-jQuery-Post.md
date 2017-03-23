---
layout: post
title: jQuery.post() 방식으로 댓글 등록 구현
date: 2017-01-22
description: jQuery.post() 방식으로 댓글 등록 구현
permalink: /2017/01/22/jQuery-Post/
---
## 1. 댓글 등록 기능을 위한 HTML

``` 
<form>
    <fieldset>
        <input type="checkbox" name="nice" checked>
        <textarea name="text"></textarea>
        <input type="button" onclick="insert_comment()" value = "COMMENT"/>
    </fieldset>
</form>
```
먼저 댓글 입력을 받기 위한 form을 작성했다.

## 2. $.post() 방식을 통해 데이터 전송

``` 
function insert_comment() {
    if (!${empty sessionScope.user}) {
        if ($("textarea[name=text]").length > 0) {
            var nice = 0;
            if ($('input[name=nice]').is(":checked")) {
                nice = 1;
            }
            var commentInfo = JSON.parse('{"item":'+itemId+',"text":"'+$('textarea').val()+'","nice":'+nice+'}');
            $.post("/buyco/api/comment/insert", commentInfo);
        }
    }
}
```
인증된 사용자만 댓글을 등록할 수 있도록 ${empty sessionScope.user} 여부를 검사한 후에 폼에 입력된 데이터를 JSON 형식으로 만들어 보내도록 했다.

jQuery.post()(url [, data] [, success] [, dataType])

* url : 요청을 보낼 URL이 포함 된 문자열
* data : 요청과 함께 서버로 전송되는 일반 객체 또는 문자열
* success : 요청이 성공하면 실행되는 콜백 함수
* dataType : 서버에서 예상되는 데이터 유형

/buyco/api/comment/insert 경로로 요청을 보내며,
commentInfo 데이터를 요청과 함께 보낼 것이다.
요청 결과 콜백 함수는 생략했다.

## 3. Comment Controller 구현

``` 
@RestController
@RequestMapping("/api/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;
    
    @RequestMapping(value = "/insert", method = RequestMethod.POST)
    public boolean insertComment(Comment comment, HttpSession session) {
        comment.setUser((Integer)session.getAttribute("user"));
        return commentService.insertComment(comment);
    }
}
```
$.post() 요청을 받기 위한 Controller다. @RequestMapping을 통해 해당 경로로 오는 요청을 Controller가 받을 수 있도록 했다.
Controller는 적절한 Service 결과를 리턴하도록 작성했다.

## 4. Comment Service 구현

``` 
@Service
public class CommentService {
    @Autowired
    private CommentMapper commentMapper;
    
    public boolean insertComment(Comment comment) {
        return commentMapper.insertComment(comment);
    }
}
```
CommentService는 댓글 데이터 객체를 받아 데이터베이스에 저장할 수 있도록 Mapper를 호출한다.

## 5. Comment Mapper 구현

``` 
@Component
public interface CommentMapper {
    @InsertProvider(type = Provider.class, method = "insertComment")
    public boolean insertComment(Comment comment);
    
    public static class Provider {
        public static String insertComment(Comment comment) {
            BEGIN();
            INSERT_INTO("`comment`");
            VALUES("item", "#{item}");
            VALUES("user", "#{user}");
            VALUES("text", "#{text}");
            VALUES("nice", "#{nice}");
            VALUES("add_time", "now()");
            return SQL();
        }
    }
}
```

## 6. 결과 화면
![2017-1-22.PNG](https://raw.githubusercontent.com/wisesun93/wisesun93.github.io/master/_posts/images/2017-1-22.PNG)

[ 참고 ]

* <https://api.jquery.com/jquery.post/>
