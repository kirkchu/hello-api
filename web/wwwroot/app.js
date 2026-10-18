const button = document.querySelector("#hello-button");
const result = document.querySelector("#result");

// 僅接受 Cloudflare 臨時通道網址，避免被導向任意網站
const apiParam = new URLSearchParams(location.search).get("api");
const apiBase = /^https:\/\/[a-z0-9-]+\.trycloudflare\.com$/.test(apiParam ?? "")
  ? apiParam
  : window.API_BASE_URL;

button.addEventListener("click", async () => {
  button.disabled = true;
  result.textContent = "載入中…";

  try {
    const response = await fetch(`${apiBase}/hello`);
    if (!response.ok) {
      throw new Error(`API 回應錯誤：HTTP ${response.status}`);
    }

    const data = await response.json();
    if (typeof data.response !== "string") {
      throw new Error("API 回應格式不正確。");
    }

    result.textContent = data.response;
  } catch (error) {
    result.textContent = error instanceof Error
      ? `無法取得資料：${error.message}`
      : "無法取得資料。";
  } finally {
    button.disabled = false;
  }
});
