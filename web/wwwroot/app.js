const button = document.querySelector("#hello-button");
const result = document.querySelector("#result");

button.addEventListener("click", async () => {
  button.disabled = true;
  result.textContent = "載入中…";

  try {
    const response = await fetch(`${window.API_BASE_URL}/hello`);
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
