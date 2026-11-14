// PostToolUse(Bash) 훅: git commit / master push 직후 test-runner 에이전트 호출을 메인 에이전트에게 알린다.
// 훅은 에이전트를 직접 띄울 수 없으므로 additionalContext 로 지시를 주입한다.
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// 진단 로그: 훅이 실행됐는지, 무엇을 출력했는지 남긴다(.gitignore 대상). 64KB 넘으면 새로 시작.
const LOG = path.join(__dirname, 'after-git.log');
const log = (line) => {
  try {
    if (fs.existsSync(LOG) && fs.statSync(LOG).size > 64 * 1024) fs.unlinkSync(LOG);
    fs.appendFileSync(LOG, `${new Date().toISOString()} ${line}\n`);
  } catch {}
};

const git = (args) => {
  try {
    return execSync(`git ${args}`, { cwd: process.env.CLAUDE_PROJECT_DIR || process.cwd(), encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
  } catch {
    return '';
  }
};

let raw = '';
process.stdin.on('data', (c) => (raw += c));
process.stdin.on('end', () => {
  let cmd = '';
  let tool = '?';
  try {
    const input = JSON.parse(raw);
    cmd = input.tool_input?.command || '';
    tool = input.tool_name || '?';
  } catch (e) {
    log(`stdin 파싱 실패: ${e.message} (${raw.length}바이트)`);
    return;
  }
  const brief = cmd.split(/\r?\n/)[0].slice(0, 100);

  // 명령의 시작이나 ; && || | 뒤에 오는 git 만 본다(문자열 안의 "git push" 오탐 방지).
  const GIT = String.raw`(?:^|[;&|(])\s*git(?:\s+-[cC]\s+\S+)*\s+`;
  const isCommit = new RegExp(GIT + String.raw`commit\b`).test(cmd) && !/--dry-run/.test(cmd);
  const pushMatch = cmd.match(new RegExp(GIT + String.raw`push\b([^;&|]*)`));
  const isPush = !!pushMatch && !/--dry-run|\s-n\b/.test(pushMatch[1]);
  if (!isCommit && !isPush) {
    if (/\bgit\b/.test(cmd)) log(`[${tool}] 해당 없음: ${brief}`);
    return;
  }

  const branch = git('rev-parse --abbrev-ref HEAD');
  const head = git('rev-parse --short HEAD');
  const messages = [];

  if (isCommit) {
    const files = git('diff --name-only HEAD~1..HEAD').split('\n').filter(Boolean);
    const docsOnly = files.length > 0 && files.every((f) => /\.md$|^docs\/|^\.claude\/|^scripts\/|^\.git(ignore|attributes)$/.test(f));
    if (docsOnly) {
      messages.push(`[test-runner 훅] 커밋 ${head}(${branch})은 문서/에이전트 설정만 바뀌어 local 테스트를 생략한다.`);
    } else {
      messages.push(
        `[test-runner 훅] 커밋 ${head}(${branch})이 생성됐다. 다음 작업 전에 Agent 도구로 subagent_type "test-runner"를 호출한다. ` +
          `프롬프트: "local 모드, 범위 HEAD~1..HEAD". 변경 파일 ${files.length}개: ${files.slice(0, 15).join(', ')}${files.length > 15 ? ' ...' : ''}`
      );
    }
  }

  // 위치 인자: [remote, refspec...]. refspec 이 있으면 그 목적지로, 없으면 현재 브랜치로 판단한다.
  const pushArgs = isPush ? pushMatch[1].trim().split(/\s+/).filter((a) => a && !a.startsWith('-')) : [];
  const refspecs = pushArgs.slice(1);
  const pushedMaster =
    isPush &&
    !/--delete|\s-d\b/.test(pushMatch[1]) &&
    (refspecs.length
      ? refspecs.some((r) => /^\+?(?:[^:]*:)?(?:refs\/heads\/)?master$/.test(r) || (r === 'HEAD' && branch === 'master'))
      : branch === 'master');
  if (pushedMaster) {
    messages.push(
      `[test-runner 훅] master 가 push 됐다(${head}). 운영 배포가 시작된다. Agent 도구로 subagent_type "test-runner"를 호출한다. ` +
        `프롬프트: "deploy 모드, 대상 커밋 ${head}". 앱 코드 변경 없이 문서/설정만 push 했다면 에이전트 대신 \`bash scripts/smoke.sh --quick\` 만 실행해도 된다.`
    );
  }

  log(`[${tool}] commit=${isCommit} push=${isPush} master=${pushedMaster}: ${brief}\n    -> ${messages.join(' | ') || '(출력 없음)'}`);
  if (messages.length === 0) return;
  process.stdout.write(
    JSON.stringify({ hookSpecificOutput: { hookEventName: 'PostToolUse', additionalContext: messages.join('\n') } })
  );
});
