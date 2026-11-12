package com.acorn.soso.group;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrlPattern;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

import com.acorn.soso.group.dao.GroupDao;
import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.support.OracleIntegrationTest;

/**
 * Phase 0 에서 고정했던 결함:
 *   비로그인 사용자가 GET /group/delete?num=N 하나로 남의 모임을 삭제할 수 있었다.
 *
 * Phase 1: 이 엔드포인트(화면에서 쓰이지 않는 초기 스캐폴딩)를 제거했다.
 *   - 비로그인 → 로그인 폼으로 이동
 *   - 로그인 사용자 → 404
 *   - 어느 경우에도 모임은 삭제되지 않는다.
 */
@AutoConfigureMockMvc
class GroupDeleteSecurityTest extends OracleIntegrationTest {

	@Autowired MockMvc mvc;
	@Autowired GroupDao groupDao;
	@Autowired JdbcTemplate jdbc;

	int groupNum;

	@BeforeEach
	void setUp() {
		groupNum = groupDao.groupNumSeq();
		groupDao.insert(GroupDto.builder()
				.num(groupNum).name("남의 모임").caption("소개").img_path("/group/images/x.png")
				.start_dt("26/12/01").deadline_dt("26/11/30").ended_dt("27/03/01")
				.manager_id("someone-else").max_people(5).meeting_loc("서울").meeting_time("화 20:00")
				.genre(1).on_off(1).manager_comment("-")
				.build());
	}

	@Test
	void anonymousCannotDeleteGroup() throws Exception {
		mvc.perform(get("/group/delete").param("num", String.valueOf(groupNum)))
				.andExpect(redirectedUrlPattern("/users/loginform?url=*"));

		assertThat(groupExists()).isTrue();
	}

	@Test
	void legacyDeleteEndpointIsGone() throws Exception {
		mvc.perform(get("/group/delete").param("num", String.valueOf(groupNum)).with(user("intruder")))
				.andExpect(status().isNotFound());

		assertThat(groupExists()).isTrue();
	}

	private boolean groupExists() {
		Integer count = jdbc.queryForObject("SELECT COUNT(*) FROM group_tb WHERE num = ?", Integer.class, groupNum);
		return count == 1;
	}
}
