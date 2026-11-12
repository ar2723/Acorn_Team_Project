package com.acorn.soso.exception;

/**
 * 사용자가 보낸 값이 잘못된 경우(필수 항목 누락, 허용되지 않는 값 등).
 * ExceptionController 가 400 상태와 함께 공통 경고 화면(error/info.jsp)을 보여준다.
 */
public class InvalidRequestException extends RuntimeException {

	public InvalidRequestException(String message) {
		super(message);
	}
}
