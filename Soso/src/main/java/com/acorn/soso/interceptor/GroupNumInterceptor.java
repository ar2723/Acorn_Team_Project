package com.acorn.soso.interceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.acorn.soso.group_managing.dao.GroupManagingDao;

@Component
public class GroupNumInterceptor implements HandlerInterceptor {

    @Autowired
    private final GroupManagingDao groupManagingDao;

    @Autowired
    public GroupNumInterceptor(GroupManagingDao groupManagingDao) {
        this.groupManagingDao = groupManagingDao;
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String groupNumParameter = request.getParameter("group_num");

        if (groupNumParameter != null) {
            try {
                int group_num = Integer.parseInt(groupNumParameter);
                String user_id = (String) request.getSession().getAttribute("id");
                // 세션에서 사용자 정보를 가져오기
                // 그룹 번호의 유효성을 검사
                // 그룹에 가입된 사용자인지 확인
                if (!isValidAccess(user_id, group_num)) {
                    // 유효하지 않은 경우 예외 처리 로직을 추가
                    // 여기에서는 가입 페이지로 리다이렉트하도록 변경
                    response.sendRedirect("/group_managing/group_errorpage"); // 가입 페이지로 리다이렉트
                    return false;
                }
            } catch (NumberFormatException e) {
                // 숫자 변환에 실패한 경우 예외 처리
                response.sendRedirect("/group_managing/group_errorpage"); // 가입 페이지로 리다이렉트
                return false;
            }
        }

        return true;
    }

    // 사용자의 그룹 가입 여부 및 그룹 번호 유효성을 확인하는 메서드
    private boolean isValidAccess(String user_id, int group_num) {
        // 여기에서 데이터베이스 조회 등을 통해 유효성 검사를 수행
        // 그룹 번호가 유효한지 확인
        // 그룹에 사용자가 가입되어 있는지 확인
        int validGroupCount = groupManagingDao.isGroupValid(group_num);
        int userGroupCount = groupManagingDao.isUserMemberOfGroup(user_id, group_num);
        
        return validGroupCount > 0 && userGroupCount > 0;
    }
}

