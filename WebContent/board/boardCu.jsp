<%@page import="net.board.db.BoardDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../css/bootstrap-theme.min.css" rel="stylesheet" type="text/css">
<link href="../css/jquery.fullpage" rel="stylesheet" type="text/css">
<link href="../css/import.css?ver=1" rel="stylesheet" type="text/css">
<script src="../js/jquery-3.3.1.js"></script>
<script src="../js/jquery.bxslider.min.js"></script>
<script src="../js/jquery.fullpage.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/common.min.js"></script>
<script src="../js/fullpage.min.js"></script>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		int count = ((Integer)request.getAttribute("count")).intValue();

		String pageNum =  (String)request.getAttribute("pageNum");
		int pageCount = ((Integer)request.getAttribute("pageCount")).intValue();
		int pageBlock = ((Integer)request.getAttribute("pageBlock")).intValue();
		int startPage = ((Integer)request.getAttribute("startPage")).intValue();
		int endPage = ((Integer)request.getAttribute("endPage")).intValue();
		List<BoardDTO> curationList = (List<BoardDTO>)request.getAttribute("curationList");
	%>
	<div class="wrapper">

		<!-- header -->
		<jsp:include page="../include/header.jsp" />
		<!-- //header -->

		<!-- top_link -->
		<jsp:include page="../include/topmenu.jsp" />
		<!-- //top_link -->

		<!-- container -->
		<div class="container">
			<section class="sub_con_half SEC_HALF">
				<h2 class="hide">Title</h2>
				<article>
					<!-- left_content -->
					<jsp:include page="../include/submenu.jsp" />
					<!-- //left_content -->
	
					<!-- right content -->
					<div class="rgt_con">
						<div class="rgt_con_txt">
							<h3>큐레이션</h3>
							
							<!-- 리스트 -->
							<div class="lst_bx">
							
								<!-- 검색 -->
								<div class="search_bx">
									<input type="text" placeholder="공지사항을 검색해 보세요." class="inp_search" id="TXT_SEARCH_VALUE" value="" onkeydown="if (event.keyCode == 13) SearchPage();" /> 
									<input type="button" value="검색" class="btn_search" onclick="SearchPage()" />
								</div>
								<!-- //검색 -->
								
								<!-- 조회수 -->
								<div class="view_cnt">
									<p>Total_<span>28</span></p>
								</div>
								<!-- //조회수 -->
								<h1>게시판 글목록 [전체글개수 : <%=count %>]</h1>
										<table border="1">
											<tr><td>번호</td><td>작성자</td><td>제목</td><td>내용</td><td>파일</td><td>조회수</td><td>타입</td><td></td></tr>
										<%
										for(int i=0; i<curationList.size(); i++){
											BoardDTO bDTO = curationList.get(i);
										%>
											<tr><td><%=bDTO.getCur_num() %></td><td><%=bDTO.getCur_name() %></td>
											<td><%=bDTO.getCur_subject() %></td><td><%=bDTO.getCur_content() %></td>
											<td><img src="./upload/<%=bDTO.getCur_file()%>" width="100" height="100"></td><td><%=bDTO.getCur_readcount() %></td>
											<td><%=bDTO.getCur_type() %></td>
											<td><input type="button" value="글수정" onclick="location.href='./BoardCurUpdate.cu?cur_num=<%=bDTO.getCur_num()%>&pageNum=<%=pageNum%>'"> 
											<input type="button" value="글삭제" onclick="location.href='./BoardCurDelete.cu?cur_num=<%=bDTO.getCur_num()%>&pageNum=<%=pageNum%>'"></td></tr>
										<%	
										}
										%>
										</table>
								
								<ul class="brd_txt_lst">
									<!-- 글목록 -->
									<li class="view_lst">
									<%	for (BoardDTO bDTO : curationList) {
											out.print(
													"<div class='con_lst DIV_CON_LST'>" + 
														"<ul>" + 
															"<li class='col_tit'><a href='#'><p>" + bDTO.getCur_num() + "</p><p>" + bDTO.getCur_subject() + "</p></a></li>" +
															"<li class='col_date'><span class='tit_date'>조회수 : </span><span>"  + bDTO.getCur_readcount() +"</span></li>" + 
															"<li class='col_date'><span class='tit_date'>작성자 : </span><span>"  + bDTO.getCur_name() +"</span></li>" + 
															"<li class='col_date'><span class='tit_date'>타입 : </span><span>"  + bDTO.getCur_type() +"</span></li>" + 
														"</ul>" + 
														"<div class='con_detail DIV_CON_DETAIL'>" + 
															"<p>" + 
																"<p>"	+ bDTO.getCur_content() + "</p>" + 
																"<p>이미지 첨부<img src='" + bDTO.getCur_file() + "' style='height: 528px; width: 753px' /></p>" + 
															"</p>" + 
														"</div>" + 
													"</div>"
											);
										}
									%>
									</li>
									<!-- //글목록 -->
								</ul>
							</div>
							<!-- //리스트 -->
							<input type="button" value="글쓰기" onclick="location.href='./BoardCurWrite.cu'">
							<form action="./BoardCurSearch.cu" method="post">
								<input type="text" name="search"> <input type="submit" value="검색">
							</form>

							<!-- 페이징 작업부분 -->
							<div class="paginate pc_pg">
							<%
								if(pageCount < endPage)	endPage = pageCount;
							
								if(startPage > pageBlock)	{ %><a href="BoardCurList.cu?pageNum=<%=startPage-pageBlock%>"class="prev"><span class="hide">이전 페이지</span></a><%	}
								for (int p = startPage; p <= endPage; p++) {	
									if(p==Integer.parseInt(pageNum)) {%><strong title="현재 페이지"><%=p %></strong>><%}
									else {%><a href="BoardCurList.cu?pageNum=<%=p%>"><%=p %></a><%}
								}
								if(endPage < pageCount){	%><a href="BoardCurList.cu?pageNum=<%=startPage+pageBlock%>" class="next"><span class="hide">다음 페이지</span></a><% }
							%>
							</div>
							<!-- //페이징 작업부분 -->
							
						</div>
					</div>
					<!-- //right content -->
				</article>
			</section>
		</div>
	</div>
</body>
</html>