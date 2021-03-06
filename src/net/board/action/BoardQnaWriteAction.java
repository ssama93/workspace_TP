package net.board.action;

import java.sql.Timestamp;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.board.db.BoardDAO;
import net.board.db.BoardDTO;
import net.member.db.MemberDAO;
import net.member.db.MemberDTO;

import util.actionForward.Action;
import util.actionForward.ActionForward;

public class BoardQnaWriteAction implements Action{

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("BoardQnaWriteAction execute()");
		request.setCharacterEncoding("utf-8");
		String member_id = request.getParameter("member_id");
		
		BoardDAO bDAO = new BoardDAO();
		BoardDTO bDTO = new BoardDTO();
		
		ActionForward forward = new ActionForward();
		
		int qna_num = bDAO.selectQMaxNum()+1;
		
		bDTO.setQna_num(qna_num);
		bDTO.setQna_subject(request.getParameter("qna_subject"));
		bDTO.setQna_content(request.getParameter("qna_content"));
		bDTO.setQna_date(new Timestamp(System.currentTimeMillis()));
		bDTO.setQna_readcount(0);
		bDTO.setQna_ref(qna_num);
		bDTO.setQna_check("0");
		
		bDAO.insertQna(bDTO, member_id);
		bDAO.insertReply(qna_num);

		forward.setPath("./BoardQnaList.qn");
		forward.setRedirect(true);
		
		return forward;
	}
}