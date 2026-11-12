package com.acorn.soso.security;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.acorn.soso.users.dao.UsersDao;
import com.acorn.soso.users.dto.UsersDto;

/** USERS_TB 의 아이디/비밀번호/역할로 로그인 사용자를 만든다. */
@Service
public class LoginUserDetailsService implements UserDetailsService {

	private final UsersDao usersDao;

	public LoginUserDetailsService(UsersDao usersDao) {
		this.usersDao = usersDao;
	}

	@Override
	public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException {
		UsersDto user = usersDao.getData(id);
		if (user == null) {
			throw new UsernameNotFoundException("존재하지 않는 아이디입니다.");
		}
		String role = user.getRole() == null ? "USER" : user.getRole();
		return User.withUsername(user.getId())
				.password(user.getPwd())
				.roles(role)
				.build();
	}
}
