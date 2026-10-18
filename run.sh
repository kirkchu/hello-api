#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$ROOT_DIR/web/bin"
PID_DIR="$ROOT_DIR/.run"

is_running() {
  local pid_file="$1"
  local expected="$2"
  [[ -f "$pid_file" ]] || return 1
  local pid
  pid="$(<"$pid_file")"
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  ps -p "$pid" -o command= | grep -F "$expected" >/dev/null
}

stop_service() {
  local pid_file="$1"
  local expected="$2"
  if is_running "$pid_file" "$expected"; then
    local pid
    pid="$(<"$pid_file")"
    kill "$pid"
  fi
  rm -f "$pid_file"
}

stop_all() {
  stop_service "$PID_DIR/api.pid" "HelloApi.dll"
  stop_service "$PID_DIR/web.pid" "http.server 8000"
  rmdir "$PID_DIR" 2>/dev/null || true
}

case "${1:-start}" in
  start)
    mkdir -p "$PID_DIR"
    if is_running "$PID_DIR/api.pid" "HelloApi.dll" || is_running "$PID_DIR/web.pid" "http.server 8000"; then
      echo "服務已在執行；請先執行 ./run.sh stop。" >&2
      exit 1
    fi

    dotnet publish "$ROOT_DIR/src/HelloApi/HelloApi.csproj" --configuration Release --output "$BIN_DIR"

    ASPNETCORE_URLS="http://127.0.0.1:5080" dotnet "$BIN_DIR/HelloApi.dll" >"$PID_DIR/api.log" 2>&1 &
    echo "$!" >"$PID_DIR/api.pid"
    python3 -m http.server 8000 --bind 127.0.0.1 --directory "$ROOT_DIR/web/wwwroot" >"$PID_DIR/web.log" 2>&1 &
    echo "$!" >"$PID_DIR/web.pid"

    for _ in {1..30}; do
      if curl --silent --fail http://127.0.0.1:5080/hello --output "$PID_DIR/api-response.json" \
        && python3 -c 'import json, pathlib, sys; sys.exit(json.loads(pathlib.Path(sys.argv[1]).read_text()) != {"response": "Hello, World!"})' "$PID_DIR/api-response.json" \
        && curl --silent --fail http://127.0.0.1:8000/ >/dev/null; then
        echo "前端：http://127.0.0.1:8000"
        echo "API：http://127.0.0.1:5080/hello"
        exit 0
      fi
      sleep 1
    done

    echo "服務啟動失敗，請查看 $PID_DIR/api.log 與 $PID_DIR/web.log。" >&2
    stop_all
    exit 1
    ;;
  stop)
    stop_all
    echo "服務已停止。"
    ;;
  *)
    echo "用法：./run.sh [start|stop]" >&2
    exit 2
    ;;
esac
