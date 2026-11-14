#!/usr/bin/env bash
# 운영 스모크 테스트 (읽기 전용: 데이터를 만들거나 바꾸는 요청은 보내지 않는다)
#
#   scripts/smoke.sh            # 전체 점검
#   scripts/smoke.sh --quick    # 기동 확인(/main 200)만. 문서만 바뀐 배포용
#   BASE_URL=https://example.com scripts/smoke.sh
#
# 출력: 실패한 항목만 한 줄씩, 마지막에 "스모크: 통과 N/M" 또는 "스모크: 실패 K/M".
# 종료 코드: 0 통과, 1 점검 실패, 2 앱이 뜨지 않음(502 등), 3 연결 불가(네트워크 문제 추정)

BASE_URL="${BASE_URL:-https://bookmate.p-e.kr}"
HOST="${BASE_URL#https://}"; HOST="${HOST%%/*}"
WAIT_TRIES="${WAIT_TRIES:-12}"   # 기동 대기: 10초 간격
QUICK=0; [ "$1" = "--quick" ] && QUICK=1

pass=0; fail=0
ok()  { pass=$((pass+1)); }
bad() { fail=$((fail+1)); echo "FAIL  $1  (기대: $2, 실제: $3)"; }

# 상태코드와 Location 을 "코드 Location" 형태로 돌려준다. 연결 실패면 000.
req() {  # req METHOD URL
	if [ "$1" = HEAD ]; then
		curl -sI -o /dev/null --max-time 10 -w '%{http_code} %{redirect_url}' "$2"
	else
		curl -s -o /dev/null --max-time 10 -X "$1" -w '%{http_code} %{redirect_url}' "$2"
	fi
}

expect_code() {  # expect_code METHOD PATH CODE
	local r; r=$(req "$1" "$BASE_URL$2"); r="${r%% *}"
	[ "$r" = "$3" ] && ok || bad "$1 $2" "$3" "$r"
}

expect_redirect() {  # expect_redirect METHOD URL CODE LOCATION_PREFIX
	local r code loc; r=$(req "$1" "$2"); code="${r%% *}"; loc="${r#* }"
	if [ "$code" = "$3" ] && [ "${loc#"$4"}" != "$loc" ]; then ok; else bad "$1 $2" "$3 -> $4*" "$code -> $loc"; fi
}

# 1. 기동 대기
code=000
for i in $(seq 1 "$WAIT_TRIES"); do
	code=$(curl -s -o /dev/null --max-time 10 -w '%{http_code}' "$BASE_URL/main")
	[ "$code" = 200 ] && break
	[ "$i" -lt "$WAIT_TRIES" ] && sleep 10
done
if [ "$code" != 200 ]; then
	if [ "$code" = 000 ]; then
		echo "스모크: 연결 불가 ($BASE_URL). 앱이 아니라 네트워크/공유기 문제일 가능성이 높다."; exit 3
	fi
	echo "스모크: 앱 미기동 (/main $code, ${WAIT_TRIES}회 확인). 서버 로그 확인 필요: ssh hannoon 'tail -80 ~/app/app.log'"; exit 2
fi
[ "$i" -gt 1 ] && echo "INFO  기동 대기 $(( (i-1)*10 ))초 후 /main 200"

if [ "$QUICK" = 1 ]; then echo "스모크(quick): 통과 1/1"; exit 0; fi

# 2. 공개 페이지: GET/HEAD 200
for p in /main /users/loginform "/group/list?genre=-1" /support/support_notice /support/support_faq; do
	expect_code GET "$p" 200
	expect_code HEAD "$p" 200
done
expect_code GET /resources/js/csrf.js 200
expect_redirect GET "$BASE_URL/" 302 "$BASE_URL/main"

# 3. 비공개 페이지: 로그인 화면으로 (https 유지)
expect_redirect GET "$BASE_URL/users/info" 302 "$BASE_URL/users/loginform?url="
expect_redirect GET "$BASE_URL/support/support_inquire_inquireStatus" 302 "$BASE_URL/users/loginform?url="

# 4. CSRF: 쿠키 발급, 토큰 없는 POST 거부
if curl -s -o /dev/null -D - --max-time 10 "$BASE_URL/main" | grep -qi '^set-cookie: XSRF-TOKEN='; then ok; else bad "XSRF-TOKEN 쿠키" "발급" "없음"; fi
expect_code POST /users/logout 403

# 5. http -> https
expect_redirect GET "http://$HOST/main" 301 "https://$HOST/"

# 6. 인증서 만료 30일 이내 경고 (실패로 세지 않음)
if command -v openssl >/dev/null; then
	end=$(echo | openssl s_client -servername "$HOST" -connect "$HOST:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
	if [ -n "$end" ] && ! echo | openssl s_client -servername "$HOST" -connect "$HOST:443" 2>/dev/null | openssl x509 -noout -checkend $((30*86400)) >/dev/null 2>&1; then
		echo "WARN  인증서 만료 임박: $end"
	fi
fi

total=$((pass+fail))
if [ "$fail" = 0 ]; then echo "스모크: 통과 $pass/$total"; exit 0; fi
echo "스모크: 실패 $fail/$total"; exit 1
