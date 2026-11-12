package com.acorn.soso.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

/*
 * Spring MVC 가 동작 중에 특정 type의 예외가 발생하면 해당 예외를 여기서 처리할 수 있다.
 */
@ControllerAdvice
public class ExceptionController {
	@ExceptionHandler(NotDeleteException.class)
	public ModelAndView notDelete(NotDeleteException nde) { //메소드의 인자로 예외 객체가 전달된다.
		ModelAndView mView = new ModelAndView();
		//exception이라는 키값으로 예외 객체를 담고
		mView.addObject("exception", nde);
		//view page ( /WEN-INF/views/error/info.jsp ) 로 forward 이동해서 예외정보 응답하기
		mView.setViewName("error/info");
		return mView;
	}
	@ExceptionHandler(DontEqualException.class)
	public ModelAndView IdDontEqual(DontEqualException ide) { //메소드의 인자로 예외 객체가 전달된다.
		ModelAndView mView = new ModelAndView();
		//exception이라는 키값으로 예외 객체를 담고
		mView.addObject("exception", ide);
		//view page ( /WEN-INF/views/error/info.jsp ) 로 forward 이동해서 예외정보 응답하기
		mView.setViewName("group_managing/info");
		return mView;
	}

	@ExceptionHandler(InvalidRequestException.class)
	public ModelAndView invalidRequest(InvalidRequestException ire) {
		ModelAndView mView = new ModelAndView("error/info");
		mView.addObject("exception", ire);
		mView.setStatus(HttpStatus.BAD_REQUEST);
		return mView;
	}
}
