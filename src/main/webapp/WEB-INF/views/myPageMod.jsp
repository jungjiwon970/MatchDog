<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
 <style></style>
</head>
<body>
	<h3>${myPage.member_name} 님의 마이페이지</h3>
	<a href="logout">로그아웃</a>
	<br></br>
	<a href="myPage">회원정보</a>
	<br></br>
	<a href="myProfile">프로필</a>
	<br></br>
	<a href="myPageMod">수정하기</a>
	<br></br>
 	<br></br>
 	<form action="myPageModUpdate.do" method="post">
 	<div class="inputForm">
     <h2>기본 정보</h2>
 	
 	<p>이름 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${myPage.member_name}</p>
 	<p>아이디 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${myPage.member_id}</p>
 	<p>성별 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ${myPage.member_gender}</p>
 	<p/>닉네임 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="member_nickName" value="${myPage.member_nickName}"/>
      <input type="button" id="overlayNick" value="중복확인"/> <span class="nickChk"></span> <p/>
      <span class="nickValid" style="font-size : 8pt"> ※ 닉네임은 문자와 숫자로 구성하여 2~8자 까지 입력해주세요</span>
     <p>비밀번호 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input type="password" name="member_pw" placeholder="비밀번호를 입력하세요" value="${myPage.member_pw}"/>
      <p>비밀번호 확인 <input type="password" name="member_pwReChk"  placeholder="비밀번호를 한번 더 입력하세요" value=""/>  
 	<p/><span class="pwReChk" style="font-size : 8pt"> ※ 비밀번호를 다시 한 번 입력해주세요</span>
 	<p>이메일 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 	<input type="text" id="usermail" name="member_email" placeholder="메일 주소를 입력 하세요" value="${myPage.member_email}"/>@
	  <select name="emailhost" id="mailhost">
			<option value="naver.com">naver.com</option>	
			<option value="gmail.com">gmail.com</option>
			<option value="daum.net">daum.net</option>
			<option value="nate.com">nate.com</option>
	  </select>
	  
	  <p>전화번호  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="member_phone" value="${myPage.member_phone}"/>
       <p><span class="phoneValid" style="font-size : 8pt"> ※ 전화번호는 -를 포함하여 입력하여 주십시오</span>
	  
	  <p/>주소<input type="text" id="postcode" placeholder="우편번호">
	  <input type="button" id="findpostcode" onclick="execDaumPostcode()" value="우편번호 찾기"><br>
	  <input type="text" id="roadAddress"  name = member_roadAddr placeholder="도로명주소" value="${myPage.member_roadAddr}"><br/>
	  <input type="text" id="jibunAddress" name = member_parcelAddr placeholder="지번주소" value="${myPage.member_parcelAddr}"><br/>
	  <span id="guide" style="color:#999;display:none"></span><br/>
	  <input type="text" id="detailAddress" name = member_detailAddr placeholder="상세주소" value="${myPage.member_detailAddr}">		  
	  <input type="text" id="extraAddress" placeholder="참고항목" value="${myPage.member_dongAddr}">                  
	  
	 	</div>

 		 	<br></br>
 		<input type="button" onclick="location.href='./myPageList.do'" value="수정 취소"/>
 		<input type="submit" id="myPageUpdate" value="수정 완료"/>
 		 </form>
 	<br></br>
 	<br></br>


</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById("postcode").value = data.zonecode;
            document.getElementById("roadAddress").value = roadAddr;
            document.getElementById("jibunAddress").value = data.jibunAddress;
            
            // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
            if(roadAddr !== ''){
                document.getElementById("extraAddress").value = extraRoadAddr;
            } else {
                document.getElementById("extraAddress").value = '';
            }
            
            var guideTextBox = document.getElementById("guide");
            // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
            if(data.autoRoadAddress) {
                var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                guideTextBox.style.display = 'block';

            } else if(data.autoJibunAddress) {
                var expJibunAddr = data.autoJibunAddress;
                guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                guideTextBox.style.display = 'block';
            } else {
                guideTextBox.innerHTML = '';
                guideTextBox.style.display = 'none';
            }
        }

    }).open();
}

//PW 일치 확인(재입력)
$('input[name="member_pwReChk"]').keyup(function(){
	if($(this).val()==''){
		$('.pwReChk').css('color','red');
		$('.pwReChk').html('비밀번호를 다시 입력해주세요.');
	}else if($(this).val()==$('input[name="member_pw"]').val()){
		$('.pwReChk').css('color','green');
		$('.pwReChk').html('비밀번호가 일치합니다.');
	}else{
		$('.pwReChk').css('color','red');
		$('.pwReChk').html('비밀번호를 다시 입력해주세요.');
	}	
});


var myPageModNickOveraly = false;
$('#overlayNick').on('click',function(){
	var $nickName = $('input[name="member_nickName"]');
	console.log('member_nickName='+$nickName);

	$.ajax({
		type : 'post',
		url : 'overlayNick.do',
		data : {'member_nickName':$nickName.val()},
		dataType : 'JSON',
		success : function(data){
			console.log(data);
			myPageModNickOveraly = data.use;
			if(data.use){
				$('.nickChk').text("사용 가능한 닉네임 입니다.");
				$('.nickChk').css("color", "green");
				$('.nickChk').css("font-size", "10px");
				
			}else{
				$('.nickChk').text("이미 사용중인 닉네임 입니다.");
				$('.nickChk').css("color", "red");
				$('.nickChk').css("font-size", "10px");
				$nickName.val('');
			}
		},
		error : function(e){
			console.log(e);
		}		
	});	
});


//닉네임 정규표현식
$('input[name="member_nickName"]').keyup(function(){
	var getNickCheck = RegExp(/^[a-zA-Zㄱ-ㅎ가-힣0-9]{2,8}$/);
	if($(this).val()==''){
		$('.nickValid').css('color','red');
		$('.nickValid').html('닉네임은 필수 입력입니다.');
	}else if(!getNickCheck.test($(this).val())){
		$('.nickValid').css('color','red');
		$('.nickValid').html('닉네임이 형식에 어긋납니다.');
	}else{
		$('.nickValid').css('color','green');
		$('.nickValid').html('적합한 닉네임 형식입니다.');
		console.log($('.nickValid').html());
	}
});

//전화번호 정규표현식
$('input[name="member_phone"]').keyup(function(){
	var getPhoneCheck = RegExp(/^\d{2,3}-\d{3,4}-\d{4}$/);
	if($(this).val()==''){
		$('.phoneValid').css('color','red');
		$('.phoneValid').html('전화번호는 필수 입력입니다.');
	}else if(!getPhoneCheck.test($(this).val())){
		$('.phoneValid').css('color','red');
		$('.phoneValid').html('전화번호가 형식에 어긋납니다.');
	}else{
		$('.phoneValid').css('color','green');
		$('.phoneValid').html('적절한 전화번호 형식입니다.');
	}
});


//회원 가입
$('#myPageUpdate').on('click',function(){
	
	var member_pw=$('input[name="member_pw"]').val();
	var member_nickName=$('input[name="member_nickName"]').val();
	var member_phone=$('input[name="member_phone"]').val();	
	var member_roadAddr=$('input[name="member_roadAddr"]').val();
	var member_parcelAddr=$('input[name="member_parcelAddr"]').val();
	var member_detailAddr=$('input[name="member_detailAddr"]').val();
				

	// 비밀번호 검사
	if(member_pw == '') {
	    alert('비밀번호를 입력해 주세요');
	    $('input[name="member_pw"]').focus();
	    return false;
	}
	/* 
	if($('.pwValid').html() != '적합한 비밀번호 형식입니다.') {
	    alert('비밀번호를 정확히 입력해 주세요');
	    $('input[name="member_pw"]').focus();
	    return false;
	}
	*/
	if($('input[name="pwCheck"]').val() == '') {
	    alert('비밀번호 확인을 위해 재입력해 주세요');
	    $('input[name="pwCheck"]').focus();
	    return false;
	}
	
	if($('.pwReChk').html() != '비밀번호가 일치합니다.') {
	    alert('비밀번호를 정확히 입력해 주세요');
	    $('input[name="pwCheck"]').focus();
	    return false;

	}
	 
	// 전화번호 검사
	if(member_phone == '') {
	    alert('전화번호를 입력해 주세요');
	    $('input[name="member_phone"]').focus();
	    return false;
	}
/* 	if($('.phoneValid').html() != '적절한 전화번호 형식입니다.') {
	    alert('전화번호를 정확히 입력해 주세요');
	    $('input[name="member_phone"]').focus();
	    return false;
	} */

	// 닉네임 검사
	if(member_nickName == '') {
	    alert('닉네임을 입력해 주세요');
	    $('input[name="member_nickName"]').focus();
	    return false;
	}
	if($('.nickValid').html() == '닉네임이 형식에 어긋납니다.') {
	    alert('닉네임을 정확히 입력해 주세요');
	    $('input[name="member_nickName"]').focus();
	    return false;
	}
	if(overlayNickChk != true) {
	    alert('닉네임 중복체크를 진행해주세요');
	    return false;
	}

	// 주소 검사
	if(member_roadAddr == '') {
	    alert('주소를 입력해 주세요');
	    return false;
	}
			
	
});	


</script>

<script>
var msg = "${msg}";
if(msg != ""){
	alert(msg);
}
</script>



</html>