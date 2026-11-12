/*
 * CSRF 토큰 공통 처리 (Spring Security CookieCsrfTokenRepository 와 짝을 이룬다)
 *
 * 서버는 토큰을 XSRF-TOKEN 쿠키로 내려주고, 상태를 바꾸는 요청(POST 등)에서
 * X-XSRF-TOKEN 헤더 또는 _csrf 파라미터로 같은 값을 돌려받아야 통과시킨다.
 *
 * 이 파일 하나로 기존 화면 코드를 고치지 않고 다음을 처리한다.
 *   1. jQuery $.ajax (XMLHttpRequest) 와 fetch 의 POST 요청에 헤더 추가
 *   2. method="post" 폼에 hidden input 추가 (Ajax 로 나중에 그려지는 폼 포함)
 *   3. <a data-post href="..."> 링크와 postTo(url) 호출을 POST 로 전송
 *
 * 모든 페이지의 <head> 에서 로드한다. 여러 번 로드되어도 한 번만 동작한다.
 */
(function () {
	'use strict';
	if (window.__bookmateCsrf) {
		return;
	}
	window.__bookmateCsrf = true;

	var COOKIE = 'XSRF-TOKEN';
	var HEADER = 'X-XSRF-TOKEN';
	var PARAM = '_csrf';

	function token() {
		var match = document.cookie.match(new RegExp('(?:^|;\\s*)' + COOKIE + '=([^;]*)'));
		return match ? decodeURIComponent(match[1]) : null;
	}

	function isUnsafe(method) {
		return !/^(GET|HEAD|OPTIONS|TRACE)$/i.test(method || 'GET');
	}

	function isSameOrigin(url) {
		try {
			return new URL(url, window.location.href).origin === window.location.origin;
		} catch (e) {
			return false;
		}
	}

	// 1-a. XMLHttpRequest (jQuery $.ajax 포함)
	var originalOpen = XMLHttpRequest.prototype.open;
	var originalSend = XMLHttpRequest.prototype.send;
	XMLHttpRequest.prototype.open = function (method, url) {
		this.__needsCsrf = isUnsafe(method) && isSameOrigin(url);
		return originalOpen.apply(this, arguments);
	};
	XMLHttpRequest.prototype.send = function () {
		var value = this.__needsCsrf ? token() : null;
		if (value) {
			this.setRequestHeader(HEADER, value);
		}
		return originalSend.apply(this, arguments);
	};

	// 1-b. fetch (gura_util.js 의 ajaxPromise, ajaxFormPromise 포함)
	if (window.fetch) {
		var originalFetch = window.fetch;
		window.fetch = function (input, init) {
			init = init || {};
			var isRequest = typeof input !== 'string' && !(input instanceof URL);
			var method = init.method || (isRequest ? input.method : 'GET');
			var url = isRequest ? input.url : String(input);
			var value = isUnsafe(method) && isSameOrigin(url) ? token() : null;
			if (value) {
				var headers = new Headers(init.headers || (isRequest ? input.headers : undefined));
				headers.set(HEADER, value);
				init = Object.assign({}, init, { headers: headers });
			}
			return originalFetch.call(this, input, init);
		};
	}

	// 2. method="post" 폼에 hidden input
	function addTokenInput(form) {
		if ((form.getAttribute('method') || '').toLowerCase() !== 'post') {
			return;
		}
		var value = token();
		if (!value) {
			return;
		}
		var input = form.querySelector('input[name="' + PARAM + '"]');
		if (!input) {
			input = document.createElement('input');
			input.type = 'hidden';
			input.name = PARAM;
			form.appendChild(input);
		}
		input.value = value;
	}

	function scan(root) {
		if (root.tagName === 'FORM') {
			addTokenInput(root);
		}
		if (root.querySelectorAll) {
			Array.prototype.forEach.call(root.querySelectorAll('form'), addTokenInput);
		}
	}

	function watchDom() {
		scan(document);
		new MutationObserver(function (mutations) {
			mutations.forEach(function (mutation) {
				Array.prototype.forEach.call(mutation.addedNodes, function (node) {
					if (node.nodeType === 1) {
						scan(node);
					}
				});
			});
		}).observe(document.documentElement, { childList: true, subtree: true });
	}

	// 제출 직전에도 한 번 더 최신 토큰으로 맞춘다(로그인 후 토큰이 바뀌는 경우 대비).
	document.addEventListener('submit', function (event) {
		if (event.target && event.target.tagName === 'FORM') {
			addTokenInput(event.target);
		}
	}, true);

	if (document.readyState === 'loading') {
		document.addEventListener('DOMContentLoaded', watchDom);
	} else {
		watchDom();
	}

	// 3. POST 로 이동 (삭제, 로그아웃 등 상태를 바꾸는 링크)
	window.postTo = function (url) {
		var form = document.createElement('form');
		form.method = 'post';
		form.setAttribute('method', 'post');
		form.action = url;
		form.style.display = 'none';
		document.body.appendChild(form);
		addTokenInput(form);
		form.submit();
	};

	// onclick="return confirm(...)" 에서 취소하면 defaultPrevented 이므로 전송하지 않는다.
	document.addEventListener('click', function (event) {
		var link = event.target.closest ? event.target.closest('a[data-post]') : null;
		if (!link || event.defaultPrevented) {
			return;
		}
		event.preventDefault();
		window.postTo(link.href);
	});
})();
