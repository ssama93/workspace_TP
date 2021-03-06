package net.board.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.board.db.BoardDAO;
import net.board.db.BoardDTO;

import util.actionForward.Action;
import util.actionForward.ActionForward;

public class BoardQnaSearch implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("BoardQnaSearch execute()");
		request.setCharacterEncoding("utf-8");
		ActionForward forward = new ActionForward();
		
		String search = request.getParameter("search");
		if(search == null){
			forward.setPath("./BoardQnaList.cu");
			forward.setRedirect(true);
			return forward;
		}
		
		BoardDAO bDAO = new BoardDAO();
		int count = bDAO.getQSearchCount(search);
		
		int pageSize = 2;	//한 화면에 보여줄 글 개수 설정
		String pageNum = request.getParameter("pageNum");

		if(pageNum == null){	//페이지 번호가 없으면 무조건 "1"페이지 설정
			pageNum = "1";
		}

		int currentPage = Integer.parseInt(pageNum);	// 현재 페이지
		int startRow = (currentPage-1)*pageSize+1;		// 페이지 첫 행 구하기
		int endRow = currentPage*pageSize;				// 마지막행 구하기
		
		List<BoardDTO> searchList = null;
		
		if(count != 0){
			searchList = bDAO.getQSearchList(startRow, pageSize, search);
		}
		
		//게시판 전체 페이지수 구하기 => ex)전체 글 개수(count):50개, 한 화면에 보여줄 글 개수(pageSize):10개
							//count:50 pageSize:10 =>전체 페이지수 : 50/10+나머지0 => 5+0=5페이지
							//count:58 pageSize:10 =>전체 페이지수 : 58/10+나머지1 => 5+1=6페이지
		int pageCount = count/pageSize+(count%pageSize==0? 0:1);
		//한화면에 보여줄 페이지수 설정
		int pageBlock = 3;
		//시작하는 페이지 번호 구하기 : 1~10 => 1, 11~20 => 11, 21~30 => 21 / currentPage, pageBlock 조합
		int startPage = ((currentPage-1)/pageBlock)*pageBlock+1;
		//끝나는 페이지 번호 구하기 : startPage pageBlock 조합
		//1 10 => 10, 11 10 => 20, 21 10 => 30 ...
		int endPage = startPage+pageBlock-1;
		if(endPage > pageCount){
			endPage = pageCount;	
		}
		
		// count, pageNum, searchList, pageCount
		// pageBlock, startPage, endPage 저장
		request.setAttribute("count", count);
		request.setAttribute("pageNum", pageNum);
		request.setAttribute("searchList", searchList);
		request.setAttribute("pageCount", pageCount);
		request.setAttribute("pageBlock", pageBlock);
		request.setAttribute("startPage", startPage);
		request.setAttribute("endPage", endPage);
		request.setAttribute("search", search);
		
		forward.setPath("./board/boardQSearch.jsp");
		forward.setRedirect(false);
		
		return forward;
	}
}