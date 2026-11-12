package com.acorn.soso;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import com.acorn.soso.support.OracleIntegrationTest;

class SosoApplicationTests extends OracleIntegrationTest {

	@Autowired
	JdbcTemplate jdbc;

	@Test
	void contextLoadsAndFlywayAppliesBaseline() {
		Integer applied = jdbc.queryForObject(
				"SELECT COUNT(*) FROM \"flyway_schema_history\" WHERE \"version\" = '1' AND \"success\" = 1",
				Integer.class);
		assertThat(applied).isEqualTo(1);
	}
}
