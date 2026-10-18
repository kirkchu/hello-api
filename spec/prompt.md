# 目的
寫一個前後端分離架構的網站，後端使用 .net core，前端不使用任何框架

# 後端 API 規格
- 目的：傳回ㄧ個 JSON 字串
- 路由：/hello
- 方法：GET
- 輸入：無
- 輸出：
    ```json
        { "response": "Hello, World!" }
    ```

# 前端規格
網頁上有ㄧ個按鈕，按下後呼叫 `/hello` API，並將傳回資料經 JSON 解析後顯示到網頁上

# 測試
開啟瀏覽器並按下按鈕，檢查網頁上是否出現後端傳回的資料

# 部署
測試通過後將網站 push 到 GitHub，並啟動 Actions


# 其他
- 前端網頁儲存到 `/web/wwwroot` 目錄
- 後端編譯後儲存到 `/web/bin` 目錄
- 後端原始碼儲存到 `/src` 目錄
- 將後端啟動指令寫入 `/run.sh`，停止方式為執行 `./run.sh stop`
- `/README.md` 包含 GitHub 上的前端網頁網址以及如何啟動 Actions 上後端服務的指令

