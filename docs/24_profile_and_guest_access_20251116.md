# 登入導覽與 Rapid 匿名遊玩更新說明

**日期：** 2025-11-16  
**狀態：** 已完成  
**版本：** v1.0

---

## 1. 變更摘要

- `/auth/callback` 不再檢查訂閱狀態，所有登入流程一律回到 Dashboard（`/`）。
- Header 會顯示使用者的 `full_name` 與 `avatar_url`，並以真實頭像取代預設圖示。
- 若 `users.full_name` 為空，系統會強制顯示全頁覆蓋對話框，要求填寫稱呼後才可繼續。
- Rapid Mode 支援匿名試玩：未登入玩家可免費玩 3 場，超過即彈出對話框導向登入/註冊。
- Queue / Grade API 允許無會話呼叫；匿名玩家不會寫入個人 SRS 資料，只回傳當次成績。

---

## 2. Header 與導覽列

| 項目 | 說明 |
| --- | --- |
| 顯示名稱 | `Navigation` 由 `layout.tsx` 提供 `userProfile`，左側顯示 `users.full_name`，若未設定顯示「請設定稱呼」。 |
| 頭像 | `AccountMenu` 接收 `avatarUrl`，若存在則以 `next/image` 呈現，並在下拉選單頂部顯示目前名稱。 |
| 登出流程 | 保持既有 server action `signOut`，點擊後仍刷新頁面並 toast。 |

主要檔案：
- `src/app/layout.tsx`
- `src/app/navigation.tsx`
- `src/components/account-menu.tsx`

---

## 3. 名稱補全覆蓋層

| 項目 | 說明 |
| --- | --- |
| 顯示條件 | 只要 session 存在且 `users.full_name` 為空字串/NULL，即顯示覆蓋層。 |
| UI | 使用 `ProfileCompletionDialog`（自訂 overlay）避免被關閉，包含 Input + Button。 |
| 儲存 | 新 server action `updateFullName`（`app/(account)/account-actions.ts`），使用 Supabase server client 寫入並 `router.refresh()`。 |

UX 重點：
- 文字、toast 皆為繁體中文，符合整體語系需求。
- 成功儲存後即關閉覆蓋層並重新整理，以更新 Header。

---

## 4. Rapid 匿名試玩

| 功能 | 詳細內容 |
| --- | --- |
| Provider | `RapidGuestProvider`（context）集中管理 `guestSessions`（localStorage：`rapid_guest_sessions`）、上限（3）與遞增函式。 |
| Tabs | `RapidExperience` 轉為包裝 `PickModeTab` / `MapModeTab`，並透過 provider 傳遞登入狀態。 |
| Queue API | 放寬未登入使用，但不載入 `user_fact_stats`，改以通用排序。 |
| Grade API | 未登入時僅回傳結果，不寫 `user_fact_stats` 或 `game_sessions`。 |
| 前端限制 | 若 guest 數 ≥ 3，阻擋開始新 session 並顯示 `GuestLimitDialog`（包含登入/註冊 CTA）。 完成第 3 場後也會自動彈出提示。 |

主要檔案：
- `src/features/rapid/components/rapid-experience.tsx`
- `src/features/rapid/components/pick-mode-tab.tsx`
- `src/features/rapid/components/map-mode-tab.tsx`
- `src/features/rapid/components/guest-limit-dialog.tsx`
- `src/features/rapid/context/rapid-guest-context.tsx`
- `src/app/api/rapid/queue/route.ts`
- `src/app/api/rapid/grade/route.ts`
- `src/features/rapid/controllers/build-queue.ts`

---

## 5. Supabase / Server 端調整

| 項目 | 內容 |
| --- | --- |
| Browser Client | 新增 `createSupabaseBrowserClient`，供重設密碼等 client-only 流程使用。 |
| Server Action | `updateFullName` 以 server client 寫入 `users` 表並 revalidate layout。 |
| API | Queue / Grade route 改為容忍 `user === null`，僅在有登入時才寫入 SRS 與 game_sessions。 |
| 未來可選 | 若需要將匿名場次也歸屬到特定帳號，可在 API 中加入環境變數（例如 `RAPID_ANONYMOUS_USER_ID`）並改用 service role client。 |

---

## 6. 測試建議

1. **登入流程**：Google / Email 密碼登入後皆應回到 `/`，且 Header 顯示正確姓名與頭像。
2. **首次登入**：確保全頁對話框無法關閉，輸入名稱後才會進入系統。
3. **名稱更新**：多裝置測試，確認 `router.refresh()` 後 Header 即時更新。
4. **匿名 Rapid**：
   - 清除 localStorage 後測試 3 場以內可正常開始。
   - 第 4 次點選主題時會攔截並彈出登入提示。
   - 切換到 Map/Pick Tab 仍共用剩餘場次。
5. **已登入 Rapid**：不應再看到警示，也不會受場次限制。
6. **API Fallback**：未登入呼叫 `/api/rapid/queue`、`/api/rapid/grade` 應得到 200 回應，但不會新增 `user_fact_stats`/`game_sessions` 紀錄。

---

## 7. 待辦 / 建議

1. **匿名統計**：若未來需要保存匿名玩家的練習資料，可依照上方建議指定匿名帳號並於 API 以 service role 寫入。
2. **名稱編輯入口**：目前只能透過覆蓋層設定一次，建議在 `Account` 頁面提供再次修改的表單。
3. **Guest 限制設定化**：可將上限數量抽成環境變數或 CMS 設定，便於行銷活動調整。
4. **Email 驗證提醒**：現在只要求名稱；未來可在覆蓋層加入 email 驗證提示（例如 resend 功能）。 

---

## 8. 相關檔案一覽

```
src/app/layout.tsx
src/app/navigation.tsx
src/components/account-menu.tsx
src/components/profile-completion-dialog.tsx
src/app/(account)/account-actions.ts
src/app/(auth)/auth/callback/route.ts
src/app/(account)/rapid/page.tsx
src/features/rapid/components/rapid-experience.tsx
src/features/rapid/components/pick-mode-tab.tsx
src/features/rapid/components/map-mode-tab.tsx
src/features/rapid/components/guest-limit-dialog.tsx
src/features/rapid/context/rapid-guest-context.tsx
src/app/api/rapid/queue/route.ts
src/app/api/rapid/grade/route.ts
src/features/rapid/controllers/build-queue.ts
```

---  
**作者：** AI Assistant  
**最後更新：** 2025-11-16

