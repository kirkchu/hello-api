# Hello API

前端為純 HTML、CSS 與 JavaScript；後端為 ASP.NET Core Minimal API。API 的 `GET /hello` 回傳：

```json
{ "response": "Hello, World!" }
```

## 本機啟動

需求：.NET 10 SDK、Python 3 與 `curl`。

```sh
./run.sh
```

開啟 <http://127.0.0.1:8000>，按下「呼叫 /hello」，頁面會顯示 API 回傳的 `Hello, World!`。API 位於 <http://127.0.0.1:5080/hello>。停止兩項服務：

```sh
./run.sh stop
```

啟動時會將後端發佈到 `web/bin`。

## GitHub Actions 與 GitHub Pages

`.github/workflows/deploy.yml` 會在推送至 `main` 或手動執行時建置 API、啟動短暫的 API 程序並驗證 `/hello`，然後將前端部署到 GitHub Pages。

手動啟動工作流程：

```sh
gh workflow run deploy.yml --ref main
gh run watch --exit-status
```

前端網址：<https://kirkchu.github.io/hello-api/>。請先在儲存庫的 **Settings → Pages → Build and deployment** 選擇 **GitHub Actions**。

儲存庫與 GitHub Pages 網站皆為公開，任何人都能瀏覽原始碼與網站。

GitHub-hosted Actions runner 會在工作流程結束後回收，因此其中啟動的 API 只用於 smoke test，並非永久線上服務。若要讓已部署的 Pages 前端也能連線到 API，請將 API 部署到可長期存取的服務，設定其 `CORS_ALLOWED_ORIGINS` 包含 Pages 網址，並將 `web/wwwroot/config.js` 的 `API_BASE_URL` 設為該 API 的基底網址，再重新部署 Pages。
