package com.acorn.soso.group;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;

import com.acorn.soso.group.dao.GroupDao;
import com.acorn.soso.group.dto.GroupDto;
import com.acorn.soso.support.OracleIntegrationTest;

/**
 * [알려진 보안 결함을 고정하는 테스트]
 *
 * /group/delete 는 GET 으로도 호출되고 로그인·작성자 검증이 없어서,
 * 비로그인 사용자가 URL 하나로 남의 모임을 삭제할 수 있다.
 *
 * Phase 1(Spring Security 도입)에서 이 테스트를 "거부되어야 한다"로 뒤집는다.
 */
@AutoConfigureMockMvc
class GroupDeleteSecurityTest extends OracleIntegrationTest {

	@Autowired MockMvc mvc;
	@Autowired GroupDao groupDao;
	@Autowired JdbcTemplate jdbc;

	@Test
	void KNOWN_BUG_anonymousGetRequestDeletesSomeoneElsesGroup() throws Exception {
		int groupNum = groupDao.groupNumSeq();
		groupDao.insert(GroupDto.builder()
				.num(groupNum).name("남의 모임").caption("소개").img_path("/group/images/x.png")
				.start_dt("26/12/01").deadline_dt("26/11/30").ended_dt("27/03/01")
				.manager_id("someone-else").max_people(5).meeting_loc("서울").meeting_time("화 20:00")
				.genre(1).on_off(1).manager_comment("-")
				.build());

		mvc.perform(get("/group/delete").param("num", String.valueOf(groupNum)))
				.andExpect(redirectedUrl("/group/list"));

		Integer remaining = jdbc.queryForObject(
				"SELECT COUNT(*) FROM group_tb WHERE num = ?", Integer.class, groupNum);
		assertThat(remaining).isZero();
	}
}
