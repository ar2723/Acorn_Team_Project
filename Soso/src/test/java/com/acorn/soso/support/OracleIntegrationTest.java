package com.acorn.soso.support;

import java.nio.file.Files;
import java.nio.file.Path;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.transaction.annotation.Transactional;
import org.testcontainers.containers.OracleContainer;
import org.testcontainers.utility.DockerImageName;

/**
 * 실제 Oracle XE 컨테이너 위에서 Flyway 마이그레이션을 적용한 뒤 테스트한다.
 *
 * - 컨테이너는 JVM 당 한 번만 띄운다(singleton container 패턴).
 * - 각 테스트는 @Transactional 로 끝나면 롤백되므로 서로 데이터를 공유하지 않는다.
 */
@SpringBootTest
@Transactional
public abstract class OracleIntegrationTest {

	static final OracleContainer ORACLE = new OracleContainer(
			DockerImageName.parse("gvenzl/oracle-xe:21-slim-faststart"))
			.withDatabaseName("bookmate")
			.withUsername("bookmate")
			.withPassword("bookmate");

	static {
		ORACLE.start();
	}

	@DynamicPropertySource
	static void oracleProperties(DynamicPropertyRegistry registry) throws Exception {
		registry.add("spring.datasource.driver-class-name", () -> "oracle.jdbc.OracleDriver");
		registry.add("spring.datasource.url", ORACLE::getJdbcUrl);
		registry.add("spring.datasource.username", ORACLE::getUsername);
		registry.add("spring.datasource.password", ORACLE::getPassword);
		Path upload = Files.createTempDirectory("bookmate-upload");
		registry.add("file.location", upload::toString);
	}
}
