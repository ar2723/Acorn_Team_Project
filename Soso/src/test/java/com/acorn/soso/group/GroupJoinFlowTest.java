package com.acorn.soso.group;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockHttpServletRequest;

import com.acorn.soso.exception.DontEqualException;
import com.acorn.soso.group.dao.GroupDao;
import com.acorn.soso.group.dao.GroupJoinDao;
import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.group.dto.GroupJoinDto;
import com.acorn.soso.group.service.GroupService;
import com.acorn.soso.group_managing.dao.GroupManagingDao;
import com.acorn.soso.group_managing.dto.GroupManagingDto;
import com.acorn.soso.group_managing.service.GroupManagingService;
import com.acorn.soso.support.OracleIntegrationTest;
import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

/**
 * 모임 생성 → 모임장 자동 가입 → 가입 신청 → 승인 흐름의 "현재 동작"을 고정하는 특성 테스트.
 * 리팩토링 중에 이 테스트가 깨지면 동작이 바뀐 것이다.
 *
 * 가입 상태(ISJOIN): 0 승인, 1 대기, 2 거절, 3 탈퇴, 4 추방 / 이력 없음은 -1
 */
class GroupJoinFlowTest extends OracleIntegrationTest {

	static final int APPROVED = 0;
	static final int PENDING = 1;
	static final int NO_HISTORY = -1;

	@Autowired UsersDao usersDao;
	@Autowired GroupDao groupDao;
	@Autowired GroupJoinDao joinDao;
	@Autowired GroupManagingDao managingDao;
	@Autowired GroupService groupService;
	@Autowired GroupManagingService managingService;
	@Autowired JdbcTemplate jdbc;

	int groupNum;

	@BeforeEach
	void setUp() {
		signUp("manager");
		signUp("member");

		groupNum = groupDao.groupNumSeq();
		GroupDto group = GroupDto.builder()
				.num(groupNum).name("월요 독서 모임").caption("함께 읽어요").img_path("/group/images/x.png")
				.start_dt("26/12/01").deadline_dt("26/11/30").ended_dt("27/03/01")
				.manager_id("manager").max_people(10).meeting_loc("서울").meeting_time("월 19:00")
				.genre(1).on_off(1).manager_comment("환영합니다")
				.build();
		groupDao.insert(group);
		joinDao.managerJoin(group);
	}

	@Test
	void managerIsAutomaticallyAMember() {
		assertThat(joinDao.getIsJoin(join("manager"))).isEqualTo(APPROVED);
		assertThat(nowPeople()).isEqualTo(1);
	}

	@Test
	void userWithoutHistoryHasNoJoinState() {
		assertThat(joinDao.getIsJoin(join("member"))).isEqualTo(NO_HISTORY);
	}

	@Test
	void applyThenApprove() {
		groupService.joinGroup(joinRequest("member", "잘 부탁드려요"));

		assertThat(joinDao.getIsJoin(join("member"))).isEqualTo(PENDING);
		List<GroupManagingDto> applicants = managingDao.getApplicantList(groupNum);
		assertThat(applicants).extracting(GroupManagingDto::getUser_id).containsExactly("member");
		assertThat(applicants.get(0).getIntro()).isEqualTo("잘 부탁드려요");

		managingService.joinApprove(applicants.get(0).getNum(), groupNum);

		assertThat(joinDao.getIsJoin(join("member"))).isEqualTo(APPROVED);
		assertThat(managingDao.getApplicantList(groupNum)).isEmpty();
		assertThat(managingDao.getMemberList(groupNum))
				.extracting(GroupManagingDto::getUser_id).containsExactlyInAnyOrder("manager", "member");
		assertThat(nowPeople()).isEqualTo(2);
	}

	@Test
	void cannotApplyTwice() {
		groupService.joinGroup(joinRequest("member", "first"));

		assertThatThrownBy(() -> groupService.joinGroup(joinRequest("member", "second")))
				.isInstanceOf(DontEqualException.class);
		assertThat(managingDao.getApplicantList(groupNum)).hasSize(1);
	}

	/** 참고: group.getData 는 now_people 컬럼을 조회하지 않으므로 DB 값을 직접 읽는다. */
	private int nowPeople() {
		return jdbc.queryForObject("SELECT now_people FROM group_tb WHERE num = ?", Integer.class, groupNum);
	}

	private void signUp(String id) {
		usersDao.insert(UsersDto.builder().id(id).pwd("pwd").email(id + "@example.com").name(id).build());
	}

	private GroupJoinDto join(String userId) {
		GroupJoinDto dto = new GroupJoinDto();
		dto.setGroup_Num(groupNum);
		dto.setUser_Id(userId);
		return dto;
	}

	private MockHttpServletRequest joinRequest(String userId, String intro) {
		MockHttpServletRequest request = new MockHttpServletRequest();
		request.getSession().setAttribute("id", userId);
		request.setParameter("num", String.valueOf(groupNum));
		request.setParameter("intro", intro);
		return request;
	}
}
