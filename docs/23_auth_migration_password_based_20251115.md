# 認證系統遷移：從魔法鏈接到密碼認證

**日期：** 2025-11-15  
**狀態：** 規劃中  
**優先級：** 高

## 執行摘要

本文檔描述了將 Geolet 的認證系統從基於魔法鏈接的電子郵件認證遷移到傳統的電子郵件/密碼認證的完整計劃。此遷移將保留 Google OAuth 集成，並添加 Supabase 的註冊確認電子郵件功能。

---

## 目錄

1. [當前系統分析](#1-當前系統分析)
2. [目標系統規範](#2-目標系統規範)
3. [技術架構變更](#3-技術架構變更)
4. [實施路線圖](#4-實施路線圖)
5. [數據庫遷移計劃](#5-數據庫遷移計劃)
6. [UI/UX 變更](#6-uiux-變更)
7. [測試策略](#7-測試策略)
8. [部署計劃](#8-部署計劃)
9. [回滾策略](#9-回滾策略)
10. [風險評估](#10-風險評估)

---

## 1. 當前系統分析

### 1.1 當前認證方式

系統目前支援以下認證方式：

1. **Google OAuth**
   - 使用 `signInWithOAuth(provider: 'google')`
   - 重定向到 `/auth/callback` 進行會話交換
   - 工作正常，將保持不變

2. **電子郵件魔法鏈接**
   - 使用 `signInWithOtp(email)` API
   - 發送一次性密碼 (OTP) 鏈接到用戶電子郵件
   - 用戶點擊鏈接完成認證
   - **此方式將被移除**

3. **GitHub OAuth**
   - 在代碼中提到但未在 UI 中實現
   - 可以在未來添加

### 1.2 當前文件結構

```
src/app/(auth)/
├── auth-actions.ts          # Server actions: signInWithOAuth, signInWithEmail, signOut
├── auth-ui.tsx              # 認證 UI 組件（Collapsible 電子郵件表單）
├── login/page.tsx           # 登錄頁面
├── signup/page.tsx          # 註冊頁面
└── auth/callback/route.ts   # OAuth 回調處理器
```

### 1.3 當前 Supabase 配置

從 `supabase/config.toml`：

```toml
[auth]
enable_signup = true
enable_confirmations = false  # ⚠️ 需要改為 true
minimum_password_length = 6

[auth.email]
enable_signup = true
enable_confirmations = false  # ⚠️ 需要改為 true
double_confirm_changes = true
```

### 1.4 當前數據庫架構

- **auth.users**：Supabase 管理的用戶表
  - 包含：id, email, encrypted_password, email_confirmed_at 等
  - 由 Supabase Auth 自動管理

- **public.users**：應用層用戶資料表
  ```sql
  create table users (
    id uuid references auth.users not null primary key,
    full_name text,
    avatar_url text,
    billing_address jsonb,
    payment_method jsonb
  );
  ```

- **觸發器**：`on_auth_user_created`
  - 當新用戶在 `auth.users` 創建時，自動在 `public.users` 創建對應記錄

### 1.5 當前工作流程

**註冊流程（電子郵件魔法鏈接）：**
1. 用戶輸入電子郵件
2. 調用 `signInWithOtp(email)`
3. Supabase 發送魔法鏈接到電子郵件
4. 用戶點擊鏈接 → 重定向到 `/auth/callback`
5. 交換代碼換取會話
6. 重定向到 `/pricing` 或 `/account`

**登錄流程（電子郵件魔法鏈接）：**
1. 與註冊流程相同（無需區分新舊用戶）
2. `signInWithOtp` 對新舊用戶都有效

---

## 2. 目標系統規範

### 2.1 新認證方式

1. **Google OAuth**（保持不變）
   - 繼續使用現有實現

2. **電子郵件 + 密碼認證**（新增）
   - **註冊**：
     - 用戶提供：電子郵件 + 密碼
     - 調用 `supabase.auth.signUp({ email, password })`
     - Supabase 發送確認電子郵件
     - 用戶點擊確認鏈接
     - 電子郵件確認後可登錄
   
   - **登錄**：
     - 用戶提供：電子郵件 + 密碼
     - 調用 `supabase.auth.signInWithPassword({ email, password })`
     - 如果電子郵件未確認，顯示錯誤訊息
     - 成功後重定向到應用

3. **可選未來功能**：
   - GitHub OAuth
   - 密碼重置流程
   - 修改密碼功能
   - 社交帳號綁定

### 2.2 UI/UX 變更

**註冊頁面** (`/signup`)：
- Google 按鈕（保持）
- "或" 分隔符
- **新增**：展開的表單，包含：
  - 電子郵件輸入
  - 密碼輸入（包含顯示/隱藏切換）
  - 確認密碼輸入
  - 密碼強度指示器
  - 提交按鈕："創建帳號"

**登錄頁面** (`/login`)：
- Google 按鈕（保持）
- "或" 分隔符
- **新增**：展開的表單，包含：
  - 電子郵件輸入
  - 密碼輸入（包含顯示/隱藏切換）
  - "忘記密碼？" 鏈接
  - 提交按鈕："登錄"

### 2.3 用戶體驗流程

**新註冊流程：**
```
用戶訪問 /signup
  ↓
填寫電子郵件 + 密碼
  ↓
點擊 "創建帳號"
  ↓
顯示成功訊息："請檢查電子郵件並點擊確認鏈接"
  ↓
用戶檢查電子郵件
  ↓
點擊確認鏈接 → 重定向到 /auth/callback
  ↓
確認電子郵件並創建會話
  ↓
重定向到 /pricing（新用戶）
```

**新登錄流程：**
```
用戶訪問 /login
  ↓
填寫電子郵件 + 密碼
  ↓
點擊 "登錄"
  ↓
檢查電子郵件是否確認
  ↓
如果未確認：顯示錯誤 + "重新發送確認郵件" 選項
如果已確認：創建會話 → 重定向到 /account
```

---

## 3. 技術架構變更

### 3.1 Supabase 配置變更

**檔案：** `supabase/config.toml`

```toml
[auth]
enable_signup = true
enable_confirmations = true  # ✅ 改為 true
minimum_password_length = 8  # ✅ 提高到 8
password_requirements = "lower_upper_letters_digits"  # ✅ 添加複雜度要求

[auth.email]
enable_signup = true
enable_confirmations = true  # ✅ 改為 true
double_confirm_changes = true
secure_password_change = true  # ✅ 添加安全密碼更改
max_frequency = "1s"
```

### 3.2 Server Actions 變更

**檔案：** `src/app/(auth)/auth-actions.ts`

```typescript
'use server';

import { redirect } from 'next/navigation';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import { ActionResponse } from '@/types/action-response';
import { getURL } from '@/utils/get-url';

// ✅ 保持不變
export async function signInWithOAuth(provider: 'github' | 'google'): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.auth.signInWithOAuth({
    provider,
    options: {
      redirectTo: getURL('/auth/callback'),
    },
  });

  if (error) {
    console.error(error);
    return { data: null, error: error };
  }

  return redirect(data.url);
}

// ❌ 移除舊的 signInWithEmail（魔法鏈接）
// ✅ 新增：註冊功能
export async function signUp(email: string, password: string): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo: getURL('/auth/callback'),
    },
  });

  if (error) {
    console.error(error);
    return { data: null, error: error };
  }

  // 返回成功，但用戶需要確認電子郵件
  return { 
    data: { 
      user: data.user,
      needsEmailConfirmation: true 
    }, 
    error: null 
  };
}

// ✅ 新增：登錄功能
export async function signInWithPassword(email: string, password: string): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    console.error(error);
    
    // 處理未確認電子郵件的情況
    if (error.message?.includes('Email not confirmed')) {
      return { 
        data: null, 
        error: {
          ...error,
          message: 'Please confirm your email address before signing in.'
        }
      };
    }
    
    return { data: null, error: error };
  }

  return { data: data.session, error: null };
}

// ✅ 新增：重新發送確認電子郵件
export async function resendConfirmationEmail(email: string): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();

  const { error } = await supabase.auth.resend({
    type: 'signup',
    email,
    options: {
      emailRedirectTo: getURL('/auth/callback'),
    },
  });

  if (error) {
    console.error(error);
    return { data: null, error: error };
  }

  return { data: { message: 'Confirmation email resent' }, error: null };
}

// ✅ 新增：請求密碼重置
export async function requestPasswordReset(email: string): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();

  const { error } = await supabase.auth.resetPasswordForEmail(email, {
    redirectTo: getURL('/auth/reset-password'),
  });

  if (error) {
    console.error(error);
    return { data: null, error: error };
  }

  return { data: { message: 'Password reset email sent' }, error: null };
}

// ✅ 保持不變
export async function signOut(): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();
  const { error } = await supabase.auth.signOut();

  if (error) {
    console.error(error);
    return { data: null, error: error };
  }

  return { data: null, error: null };
}
```

### 3.3 UI 組件變更

需要創建或修改以下組件：

1. **`auth-ui.tsx`** - 主要變更
   - 移除 Collapsible 電子郵件表單
   - 根據 mode ('login' | 'signup') 顯示不同表單
   - 添加密碼輸入欄位
   - 添加密碼可見性切換
   - 添加密碼強度指示器（註冊時）
   - 添加確認密碼欄位（註冊時）

2. **新增：`password-input.tsx`**（shadcn 自定義組件）
   - 密碼輸入欄位
   - 顯示/隱藏切換按鈕
   - 使用 shadcn Input 和 Button

3. **新增：`password-strength-indicator.tsx`**
   - 顯示密碼強度（弱/中/強）
   - 顏色編碼的進度條
   - 密碼要求檢查清單

4. **可選：`forgot-password-dialog.tsx`**
   - 忘記密碼對話框
   - 電子郵件輸入
   - 提交和取消按鈕

### 3.4 路由變更

**新增路由：**
- `/auth/reset-password` - 密碼重置頁面
- `/auth/confirm-email` - 確認電子郵件提示頁面（可選）

**現有路由（修改）：**
- `/login` - 更新為使用新的密碼表單
- `/signup` - 更新為使用新的密碼表單
- `/auth/callback` - 需要處理電子郵件確認

---

## 4. 實施路線圖

### 階段 1：準備工作（預計 1-2 小時）

**任務：**
1. ✅ 分析當前系統（完成）
2. ✅ 編寫遷移文檔（本文檔）
3. ⬜ 備份當前代碼（創建 feature branch）
4. ⬜ 更新 Supabase 配置（本地和生產環境）

**輸出：**
- Feature branch: `feat/password-based-auth`
- 更新的 `config.toml`

---

### 階段 2：後端實施（預計 2-3 小時）

**任務：**
1. ⬜ 更新 `auth-actions.ts`
   - 添加 `signUp` 函數
   - 添加 `signInWithPassword` 函數
   - 添加 `resendConfirmationEmail` 函數
   - 添加 `requestPasswordReset` 函數
   - 移除舊的 `signInWithEmail` 函數

2. ⬜ 更新 `auth/callback/route.ts`
   - 處理電子郵件確認回調
   - 添加更好的錯誤處理
   - 添加日誌記錄

3. ⬜ 創建密碼重置路由
   - `app/(auth)/auth/reset-password/page.tsx`

**測試：**
- 使用 Supabase CLI 測試本地註冊流程
- 檢查 Inbucket (port 54324) 中的確認電子郵件
- 測試登錄流程
- 測試密碼重置流程

---

### 階段 3：UI/UX 實施（預計 3-4 小時）

**任務：**
1. ⬜ 創建 `password-input.tsx` 組件
   - 使用 shadcn Input
   - 添加顯示/隱藏圖標（使用 react-icons）
   - 適當的 styling

2. ⬜ 創建 `password-strength-indicator.tsx` 組件
   - 密碼強度計算邏輯
   - 進度條（使用 shadcn Progress）
   - 要求檢查清單

3. ⬜ 更新 `auth-ui.tsx`
   - **註冊模式**：
     - 移除 Collapsible
     - 顯示完整表單：email + password + confirm password
     - 集成密碼強度指示器
     - 處理表單驗證
     - 處理 `signUp` 響應
     - 顯示成功訊息（檢查電子郵件）
   
   - **登錄模式**：
     - 移除 Collapsible
     - 顯示完整表單：email + password
     - 添加 "忘記密碼？" 鏈接
     - 處理 `signInWithPassword` 響應
     - 處理未確認電子郵件錯誤
     - 提供重新發送確認郵件選項

4. ⬜ 創建 `forgot-password-dialog.tsx`（可選）
   - 使用 shadcn Dialog
   - 電子郵件輸入
   - 提交處理

5. ⬜ 創建 `/auth/reset-password/page.tsx`
   - 密碼重置表單
   - 新密碼 + 確認密碼
   - 處理 token 驗證

**設計規範（使用 shadcn/ui）：**
- 使用現有的 Card, Input, Button 組件
- 保持一致的間距和 styling
- 錯誤訊息使用 toast notifications
- 成功訊息使用 toast notifications
- 響應式設計

---

### 階段 4：測試（預計 2-3 小時）

**單元測試：**
- [ ] 測試 `signUp` 函數
- [ ] 測試 `signInWithPassword` 函數
- [ ] 測試 `resendConfirmationEmail` 函數
- [ ] 測試 `requestPasswordReset` 函數

**集成測試：**
- [ ] 完整註冊流程
- [ ] 完整登錄流程
- [ ] 電子郵件確認流程
- [ ] 密碼重置流程
- [ ] OAuth 流程（確保未受影響）

**手動測試清單：**
1. [ ] **註冊新用戶**
   - 填寫有效的電子郵件和密碼
   - 提交表單
   - 檢查成功訊息
   - 檢查 Inbucket 中的確認電子郵件
   - 點擊確認鏈接
   - 驗證重定向到 `/pricing`

2. [ ] **未確認用戶登錄**
   - 嘗試在確認前登錄
   - 驗證錯誤訊息
   - 點擊 "重新發送確認郵件"
   - 驗證新郵件已發送

3. [ ] **確認用戶登錄**
   - 使用有效憑證登錄
   - 驗證重定向到 `/account`

4. [ ] **錯誤密碼**
   - 使用錯誤密碼登錄
   - 驗證適當的錯誤訊息

5. [ ] **密碼重置**
   - 點擊 "忘記密碼？"
   - 輸入電子郵件
   - 檢查重置郵件
   - 點擊重置鏈接
   - 設置新密碼
   - 使用新密碼登錄

6. [ ] **Google OAuth**
   - 驗證 Google 登錄仍然有效
   - 驗證新用戶流程
   - 驗證現有用戶流程

7. [ ] **密碼驗證**
   - 測試弱密碼（應被拒絕）
   - 測試中等密碼
   - 測試強密碼
   - 測試密碼不匹配（註冊時）

8. [ ] **UI/UX**
   - 測試所有按鈕和鏈接
   - 測試響應式布局（手機/平板/桌面）
   - 測試鍵盤導航
   - 測試 Tab 順序
   - 測試錯誤狀態顯示
   - 測試加載狀態

---

### 階段 5：數據遷移（預計 1 小時）

**重要說明：**
由於當前使用電子郵件魔法鏈接（OTP），`auth.users` 中的現有用戶 **沒有設置密碼**。他們的 `encrypted_password` 欄位為 NULL 或空。

**遷移策略：**

**選項 A：強制密碼設置（推薦）**

現有用戶首次嘗試使用電子郵件/密碼登錄時：
1. 系統檢測到用戶存在但無密碼
2. 顯示訊息："您需要設置密碼。我們已向您發送密碼設置鏈接。"
3. 自動觸發 `requestPasswordReset` 
4. 用戶通過電子郵件設置密碼
5. 之後可以正常登錄

**選項 B：保持 OAuth 和添加密碼（雙重支持）**

1. OAuth 用戶可以繼續使用 OAuth
2. 他們也可以選擇添加密碼（從帳戶設置）
3. 不需要立即遷移

**選項 C：通知現有用戶**

1. 向所有現有用戶發送通知電子郵件
2. 說明系統已升級到密碼認證
3. 提供設置密碼的鏈接
4. 給予 2-4 週的過渡期

**推薦方案：選項 B + 選項 C**
- 通知現有用戶新功能
- 允許他們選擇添加密碼
- OAuth 繼續有效（無破壞性變更）
- 新用戶必須使用密碼

**遷移腳本：**

```sql
-- supabase/migrations/20251115000000_add_password_migration_notice.sql

-- 此遷移僅用於記錄和未來參考
-- 實際的 auth.users 由 Supabase 管理

-- 可選：添加一個標記來追蹤遷移狀態
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS 
  password_migration_notified_at TIMESTAMP WITH TIME ZONE DEFAULT NULL;

-- 註釋：此欄位可用於追蹤哪些用戶已收到密碼設置通知
COMMENT ON COLUMN public.users.password_migration_notified_at IS 
  '用戶收到密碼遷移通知的時間戳';
```

**通知電子郵件範本：**

```
主題：Geolet 新功能：密碼登錄

親愛的 Geolet 用戶，

我們很高興地宣布 Geolet 現在支持密碼登錄！

您現在可以：
✅ 使用電子郵件和密碼登錄
✅ 繼續使用 Google 登錄（現有方式）
✅ 在兩種方式之間自由切換

如何設置您的密碼：
1. 訪問 [設置密碼鏈接]
2. 創建一個安全的密碼
3. 開始使用新的登錄方式！

您的帳戶完全安全，無需立即採取任何行動。

祝好，
Geolet 團隊
```

**無需數據遷移的原因：**
- `auth.users` 由 Supabase 管理
- 現有用戶記錄保持不變
- `public.users` 已經與 `auth.users` 關聯
- 觸發器繼續有效
- 只是添加新的登錄方式，不是替換

---

### 階段 6：部署（預計 1-2 小時）

**部署檢查清單：**

1. [ ] **本地測試完成**
   - 所有測試通過
   - 手動測試完成
   - 代碼審查完成

2. [ ] **準備生產環境**
   - 更新生產環境的 `config.toml`
   - 設置電子郵件模板（如需自定義）
   - 配置 SMTP（如使用自定義郵件服務）

3. [ ] **數據庫遷移**
   - 運行遷移腳本（如果有）
   - 驗證遷移成功

4. [ ] **部署代碼**
   - 合併 feature branch 到 main
   - 觸發 CI/CD 流程
   - 監控部署日誌

5. [ ] **生產環境測試**
   - 測試新註冊流程
   - 測試登錄流程
   - 測試電子郵件發送
   - 驗證 OAuth 仍然有效

6. [ ] **監控**
   - 監控錯誤日誌
   - 監控用戶註冊率
   - 監控電子郵件送達率
   - 收集用戶反饋

7. [ ] **通知用戶**（如果使用選項 C）
   - 發送通知電子郵件給現有用戶
   - 更新文檔/FAQ
   - 發布更新公告

---

## 5. 數據庫遷移計劃

### 5.1 現有架構

**auth.users** (Supabase 管理)
```sql
-- 簡化表示
id uuid PRIMARY KEY
email text
encrypted_password text  -- 目前為 NULL（OTP 用戶）
email_confirmed_at timestamp
created_at timestamp
updated_at timestamp
raw_user_meta_data jsonb
```

**public.users** (應用層)
```sql
id uuid references auth.users PRIMARY KEY
full_name text
avatar_url text
billing_address jsonb
payment_method jsonb
```

### 5.2 遷移需求

**無需架構變更**：
- `auth.users` 已經有 `encrypted_password` 欄位
- `public.users` 不需要變更
- 觸發器繼續有效

**可選添加（追蹤目的）**：

```sql
-- 遷移檔案：20251115000000_add_auth_metadata.sql

-- 添加密碼遷移追蹤欄位
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS password_migration_notified_at TIMESTAMP WITH TIME ZONE;

-- 添加認證方法追蹤（可選）
ALTER TABLE public.users 
ADD COLUMN IF NOT EXISTS auth_method text DEFAULT 'password';

-- 可能的值：'password', 'oauth_google', 'oauth_github', 'magic_link'
COMMENT ON COLUMN public.users.auth_method IS 
  '用戶首次註冊使用的主要認證方法';

-- 添加索引以便查詢
CREATE INDEX IF NOT EXISTS idx_users_auth_method 
ON public.users(auth_method);
```

### 5.3 數據完整性檢查

部署後運行以下查詢以驗證數據完整性：

```sql
-- 檢查 auth.users 中有多少用戶沒有密碼
SELECT 
  COUNT(*) as total_users,
  COUNT(encrypted_password) as users_with_password,
  COUNT(*) - COUNT(encrypted_password) as users_without_password
FROM auth.users;

-- 檢查 public.users 與 auth.users 的同步
SELECT 
  (SELECT COUNT(*) FROM auth.users) as auth_users_count,
  (SELECT COUNT(*) FROM public.users) as public_users_count,
  (SELECT COUNT(*) FROM auth.users) - (SELECT COUNT(*) FROM public.users) as difference;

-- 列出沒有密碼的用戶（OAuth 用戶）
SELECT 
  id, 
  email, 
  email_confirmed_at, 
  created_at,
  raw_user_meta_data->>'provider' as provider
FROM auth.users
WHERE encrypted_password IS NULL OR encrypted_password = '';
```

### 5.4 回滾數據遷移

如果需要回滾：

```sql
-- 移除新添加的欄位（如果添加了）
ALTER TABLE public.users DROP COLUMN IF EXISTS password_migration_notified_at;
ALTER TABLE public.users DROP COLUMN IF EXISTS auth_method;
DROP INDEX IF EXISTS idx_users_auth_method;
```

---

## 6. UI/UX 變更

### 6.1 設計規範

**使用 shadcn/ui 組件：**
- Button
- Input
- Card, CardContent, CardHeader, CardTitle, CardDescription
- Label
- Separator
- Toast (for notifications)
- Dialog (for forgot password)
- Progress (for password strength)
- Icons from `react-icons`

**配色方案：**
- 使用現有的 Tailwind 配置
- 錯誤：`text-destructive`
- 成功：`text-green-500`
- 警告：`text-yellow-500`

### 6.2 組件規範

#### 6.2.1 PasswordInput 組件

```typescript
// src/components/ui/password-input.tsx

import { useState } from 'react';
import { Eye, EyeOff } from 'lucide-react';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';

interface PasswordInputProps {
  id: string;
  name: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  required?: boolean;
  autoComplete?: string;
}

export function PasswordInput({
  id,
  name,
  value,
  onChange,
  placeholder = "Password",
  required = true,
  autoComplete = "current-password",
}: PasswordInputProps) {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className="relative">
      <Input
        type={showPassword ? "text" : "password"}
        id={id}
        name={name}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
        required={required}
        autoComplete={autoComplete}
        className="pr-10"
      />
      <Button
        type="button"
        variant="ghost"
        size="sm"
        className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
        onClick={() => setShowPassword(!showPassword)}
      >
        {showPassword ? (
          <EyeOff className="h-4 w-4 text-muted-foreground" />
        ) : (
          <Eye className="h-4 w-4 text-muted-foreground" />
        )}
      </Button>
    </div>
  );
}
```

#### 6.2.2 PasswordStrengthIndicator 組件

```typescript
// src/components/ui/password-strength-indicator.tsx

import { Progress } from '@/components/ui/progress';
import { Check, X } from 'lucide-react';

interface PasswordStrengthIndicatorProps {
  password: string;
}

export function PasswordStrengthIndicator({ password }: PasswordStrengthIndicatorProps) {
  const checks = {
    length: password.length >= 8,
    lowercase: /[a-z]/.test(password),
    uppercase: /[A-Z]/.test(password),
    digit: /\d/.test(password),
  };

  const strength = Object.values(checks).filter(Boolean).length;
  const strengthPercent = (strength / 4) * 100;

  const strengthLabel = 
    strength <= 1 ? '弱' :
    strength === 2 ? '中' :
    strength === 3 ? '強' : '非常強';

  const strengthColor =
    strength <= 1 ? 'bg-red-500' :
    strength === 2 ? 'bg-yellow-500' :
    strength === 3 ? 'bg-green-500' : 'bg-green-600';

  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between text-sm">
        <span className="text-muted-foreground">密碼強度：</span>
        <span className={`font-medium ${strengthColor.replace('bg-', 'text-')}`}>
          {strengthLabel}
        </span>
      </div>
      <Progress value={strengthPercent} className={strengthColor} />
      <div className="space-y-1 text-xs text-muted-foreground">
        <div className="flex items-center gap-2">
          {checks.length ? <Check className="h-3 w-3 text-green-500" /> : <X className="h-3 w-3 text-red-500" />}
          <span>至少 8 個字符</span>
        </div>
        <div className="flex items-center gap-2">
          {checks.lowercase ? <Check className="h-3 w-3 text-green-500" /> : <X className="h-3 w-3 text-red-500" />}
          <span>包含小寫字母</span>
        </div>
        <div className="flex items-center gap-2">
          {checks.uppercase ? <Check className="h-3 w-3 text-green-500" /> : <X className="h-3 w-3 text-red-500" />}
          <span>包含大寫字母</span>
        </div>
        <div className="flex items-center gap-2">
          {checks.digit ? <Check className="h-3 w-3 text-green-500" /> : <X className="h-3 w-3 text-red-500" />}
          <span>包含數字</span>
        </div>
      </div>
    </div>
  );
}
```

#### 6.2.3 更新後的 AuthUI 組件（概念）

```typescript
// src/app/(auth)/auth-ui.tsx

// 主要變更：
// 1. 移除 Collapsible
// 2. 添加 password 和 confirmPassword state
// 3. 根據 mode 顯示不同表單
// 4. 集成 PasswordInput 和 PasswordStrengthIndicator
// 5. 處理新的 signUp 和 signInWithPassword actions

export function AuthUI({
  mode,
  signInWithOAuth,
  signUp,
  signInWithPassword,
}: {
  mode: 'login' | 'signup';
  signInWithOAuth: (provider: 'github' | 'google') => Promise<ActionResponse>;
  signUp: (email: string, password: string) => Promise<ActionResponse>;
  signInWithPassword: (email: string, password: string) => Promise<ActionResponse>;
}) {
  // ... state management
  // ... form handlers
  // ... UI rendering
}
```

### 6.3 用戶流程圖

**註冊流程：**
```
┌─────────────────────┐
│  訪問 /signup       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  顯示註冊表單       │
│  - Email           │
│  - Password        │
│  - Confirm Password│
│  - Google 按鈕     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  用戶選擇方式       │
└──────┬──────┬───────┘
       │      │
       │      └──────────────┐
       │                     │
       ▼                     ▼
┌──────────────┐    ┌─────────────────┐
│ Google OAuth │    │ 電子郵件/密碼  │
└──────┬───────┘    └────────┬────────┘
       │                     │
       │                     ▼
       │            ┌─────────────────────┐
       │            │  驗證表單           │
       │            │  - 密碼強度         │
       │            │  - 密碼匹配         │
       │            └────────┬────────────┘
       │                     │
       │                     ▼
       │            ┌─────────────────────┐
       │            │  調用 signUp        │
       │            └────────┬────────────┘
       │                     │
       │                     ▼
       │            ┌─────────────────────┐
       │            │  發送確認郵件       │
       │            │  顯示成功訊息       │
       │            └────────┬────────────┘
       │                     │
       │                     ▼
       │            ┌─────────────────────┐
       │            │  用戶檢查郵件       │
       │            │  點擊確認鏈接       │
       │            └────────┬────────────┘
       │                     │
       └─────────────────────┘
                     │
                     ▼
            ┌─────────────────┐
            │  /auth/callback │
            └────────┬─────────┘
                     │
                     ▼
            ┌─────────────────┐
            │  創建會話       │
            │  重定向 /pricing│
            └─────────────────┘
```

---

## 7. 測試策略

### 7.1 測試環境

**本地開發環境：**
- Supabase 本地實例（`supabase start`）
- Inbucket 郵件測試（http://127.0.0.1:54324）
- Next.js 開發服務器（`npm run dev`）

**測試工具：**
- Inbucket - 電子郵件測試
- Supabase Studio - 數據庫檢查
- Browser DevTools - 網絡請求
- React Developer Tools - 組件狀態

### 7.2 測試案例

#### 7.2.1 註冊測試案例

| 案例 ID | 描述 | 輸入 | 預期結果 |
|---------|------|------|----------|
| REG-001 | 有效註冊 | 有效 email + 強密碼 | 成功，發送確認郵件 |
| REG-002 | 弱密碼 | 有效 email + 弱密碼（<8字符） | 錯誤：密碼不符合要求 |
| REG-003 | 密碼不匹配 | 有效 email + 不匹配的密碼 | 錯誤：密碼不匹配 |
| REG-004 | 無效電子郵件 | 無效 email + 有效密碼 | 錯誤：無效的電子郵件格式 |
| REG-005 | 重複電子郵件 | 已存在的 email | 錯誤：電子郵件已被使用 |
| REG-006 | 空欄位 | 空 email 或 password | 錯誤：必填欄位 |

#### 7.2.2 登錄測試案例

| 案例 ID | 描述 | 輸入 | 預期結果 |
|---------|------|------|----------|
| LOG-001 | 有效登錄 | 正確的 email + password | 成功，重定向到 /account |
| LOG-002 | 錯誤密碼 | 正確 email + 錯誤 password | 錯誤：憑證無效 |
| LOG-003 | 不存在的用戶 | 不存在的 email | 錯誤：憑證無效 |
| LOG-004 | 未確認電子郵件 | 未確認的 email + 正確 password | 錯誤：請確認電子郵件 |
| LOG-005 | 空欄位 | 空 email 或 password | 錯誤：必填欄位 |

#### 7.2.3 電子郵件確認測試案例

| 案例 ID | 描述 | 操作 | 預期結果 |
|---------|------|------|----------|
| CON-001 | 有效確認 | 點擊有效確認鏈接 | 電子郵件已確認，重定向 |
| CON-002 | 過期鏈接 | 點擊過期確認鏈接 | 錯誤：鏈接已過期 |
| CON-003 | 重新發送確認 | 請求重新發送 | 新的確認郵件已發送 |
| CON-004 | 已確認的電子郵件 | 再次點擊確認鏈接 | 已確認，正常重定向 |

#### 7.2.4 密碼重置測試案例

| 案例 ID | 描述 | 操作 | 預期結果 |
|---------|------|------|----------|
| RST-001 | 請求密碼重置 | 輸入有效 email | 重置郵件已發送 |
| RST-002 | 不存在的電子郵件 | 輸入不存在的 email | 無錯誤（安全考慮） |
| RST-003 | 設置新密碼 | 通過鏈接設置新密碼 | 密碼已更新 |
| RST-004 | 使用新密碼登錄 | 使用重置後的密碼登錄 | 成功登錄 |
| RST-005 | 過期重置鏈接 | 點擊過期重置鏈接 | 錯誤：鏈接已過期 |

#### 7.2.5 OAuth 測試案例

| 案例 ID | 描述 | 操作 | 預期結果 |
|---------|------|------|----------|
| OAU-001 | Google 新用戶註冊 | 通過 Google 註冊 | 成功，重定向到 /pricing |
| OAU-002 | Google 現有用戶登錄 | 通過 Google 登錄 | 成功，重定向到 /account |
| OAU-003 | Google 授權取消 | 取消 Google 授權 | 返回登錄頁面 |

### 7.3 性能測試

**目標：**
- 頁面加載時間 < 2 秒
- API 響應時間 < 500ms
- 電子郵件發送時間 < 5 秒

**測試：**
- 使用 Lighthouse 測試頁面性能
- 使用 Network tab 監控 API 調用
- 測試並發註冊/登錄請求

### 7.4 安全測試

**測試項目：**
- [ ] SQL 注入防護
- [ ] XSS 防護
- [ ] CSRF 防護
- [ ] 密碼存儲安全（已由 Supabase 處理）
- [ ] Session 管理安全
- [ ] Rate limiting（Supabase 配置）

---

## 8. 部署計劃

### 8.1 部署前檢查清單

- [ ] 所有測試通過
- [ ] 代碼審查完成
- [ ] 文檔更新
- [ ] 環境變量配置
- [ ] Supabase 配置更新
- [ ] 數據庫備份
- [ ] 回滾計劃準備

### 8.2 部署步驟

**步驟 1：更新 Supabase 配置**
```bash
# 本地測試
supabase start
# 檢查配置
supabase status

# 生產環境（通過 Supabase Dashboard）
# 1. 登錄 Supabase Dashboard
# 2. 選擇項目
# 3. Settings > Auth
# 4. 更新以下設置：
#    - Enable email confirmations: ON
#    - Minimum password length: 8
#    - Password requirements: lower_upper_letters_digits
```

**步驟 2：運行數據庫遷移**
```bash
# 本地測試遷移
supabase migration up

# 生產環境
supabase db push
```

**步驟 3：部署代碼**
```bash
# 合併到 main
git checkout main
git merge feat/password-based-auth
git push origin main

# CI/CD 會自動部署（假設已配置）
# 或手動部署（如 Vercel）
vercel --prod
```

**步驟 4：驗證部署**
```bash
# 檢查生產環境
curl https://your-domain.com/api/health  # 如果有 health check

# 測試註冊
# 測試登錄
# 測試 OAuth
```

**步驟 5：監控**
- 監控錯誤日誌（Vercel/Supabase Dashboard）
- 監控用戶註冊率
- 監控電子郵件送達率
- 檢查用戶反饋

### 8.3 部署時間表

| 階段 | 預計時間 | 活動 |
|------|----------|------|
| 部署窗口開始 | T+0 | 開始部署 |
| 配置更新 | T+10min | 更新 Supabase 配置 |
| 遷移執行 | T+15min | 運行數據庫遷移 |
| 代碼部署 | T+20min | 部署新代碼 |
| 煙霧測試 | T+30min | 基本功能測試 |
| 全面測試 | T+45min | 完整測試所有流程 |
| 監控 | T+60min | 持續監控 1 小時 |
| 部署完成 | T+120min | 確認穩定 |

---

## 9. 回滾策略

### 9.1 回滾觸發條件

**立即回滾：**
- 用戶無法註冊或登錄
- OAuth 流程失敗
- 數據庫錯誤導致服務中斷
- 嚴重的安全漏洞

**計劃回滾：**
- 電子郵件送達率 < 80%
- 錯誤率 > 5%
- 用戶投訴顯著增加
- 性能下降 > 50%

### 9.2 回滾步驟

**步驟 1：暫停新部署**
```bash
# 如果使用 CI/CD，暫停管道
# 或在 Vercel Dashboard 停止部署
```

**步驟 2：回滾代碼**
```bash
# 方法 A：Git revert
git revert <commit-hash>
git push origin main

# 方法 B：回滾到之前的部署（Vercel）
# 在 Vercel Dashboard 選擇之前的部署並回滾
```

**步驟 3：回滾 Supabase 配置**
```
# 在 Supabase Dashboard：
# 1. Settings > Auth
# 2. 恢復以下設置：
#    - Enable email confirmations: OFF
#    - （其他設置恢復到原始值）
```

**步驟 4：回滾數據庫遷移（如果需要）**
```bash
# 運行回滾遷移
supabase migration down

# 或手動執行回滾 SQL
psql -h <host> -U <user> -d <database> -f rollback.sql
```

**步驟 5：驗證回滾**
- 測試 OAuth 登錄
- 測試魔法鏈接登錄
- 檢查錯誤日誌
- 確認用戶可以正常使用

**步驟 6：事後分析**
- 分析失敗原因
- 記錄問題
- 更新計劃
- 重新測試後再次部署

### 9.3 數據備份

**部署前備份：**
```bash
# 備份數據庫
pg_dump -h <host> -U <user> -d <database> -F c -f backup_pre_deploy.dump

# 或使用 Supabase CLI
supabase db dump -f backup_pre_deploy.sql
```

**備份驗證：**
```bash
# 列出備份內容
pg_restore -l backup_pre_deploy.dump

# 測試恢復（在測試環境）
pg_restore -d test_database backup_pre_deploy.dump
```

---

## 10. 風險評估

### 10.1 技術風險

| 風險 | 可能性 | 影響 | 緩解措施 |
|------|--------|------|----------|
| 電子郵件送達失敗 | 中 | 高 | 配置 SMTP，測試多個郵件服務 |
| OAuth 流程中斷 | 低 | 高 | 徹底測試，保持現有實現不變 |
| 密碼安全問題 | 低 | 高 | 使用 Supabase 內建功能，強密碼策略 |
| 性能下降 | 低 | 中 | 性能測試，監控，優化查詢 |
| 數據遷移失敗 | 低 | 高 | 完整備份，回滾計劃，測試環境驗證 |
| UI/UX 問題 | 中 | 中 | 用戶測試，響應式設計，可訪問性測試 |

### 10.2 業務風險

| 風險 | 可能性 | 影響 | 緩解措施 |
|------|--------|------|----------|
| 用戶混淆 | 中 | 中 | 清晰的 UI，幫助文檔，通知郵件 |
| 註冊率下降 | 低 | 中 | 保持 OAuth 選項，簡化流程 |
| 現有用戶不滿 | 低 | 中 | 通知用戶，提供選擇，漸進式遷移 |
| 支持請求增加 | 中 | 低 | 準備 FAQ，培訓支持團隊 |

### 10.3 風險監控

**關鍵指標：**
- 註冊成功率
- 登錄成功率
- 電子郵件確認率
- OAuth 使用率
- 錯誤率
- 頁面加載時間
- 用戶投訴/支持請求

**監控工具：**
- Supabase Dashboard (Auth logs)
- Vercel Analytics
- Error tracking (如 Sentry)
- Email service dashboard
- Google Analytics / Plausible

---

## 11. 後續改進

### 11.1 短期改進（1-2 週）

- [ ] 添加 "記住我" 功能
- [ ] 添加密碼強度要求的工具提示
- [ ] 優化錯誤訊息
- [ ] 添加電子郵件模板自定義
- [ ] 改進密碼重置流程

### 11.2 中期改進（1-2 個月）

- [ ] 添加 GitHub OAuth
- [ ] 添加雙因素認證 (2FA)
- [ ] 添加帳戶設置頁面（修改密碼等）
- [ ] 添加登錄歷史/活動日誌
- [ ] 社交帳號綁定功能

### 11.3 長期改進（3-6 個月）

- [ ] 添加更多 OAuth 提供商
- [ ] 生物識別認證
- [ ] 單點登錄 (SSO)
- [ ] 高級安全功能（異常登錄檢測等）
- [ ] 用戶行為分析

---

## 12. 附錄

### 12.1 相關資源

**Supabase 文檔：**
- [Auth: Email & Password](https://supabase.com/docs/guides/auth/auth-email)
- [Auth: Email Confirmations](https://supabase.com/docs/guides/auth/auth-email#confirming-email-addresses)
- [Auth: Password Reset](https://supabase.com/docs/guides/auth/auth-password-reset)
- [Auth API Reference](https://supabase.com/docs/reference/javascript/auth-signup)

**Next.js 資源：**
- [Server Actions](https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions-and-mutations)
- [Forms and Mutations](https://nextjs.org/docs/app/building-your-application/data-fetching/forms-and-mutations)

**shadcn/ui：**
- [Components Documentation](https://ui.shadcn.com/docs/components)
- [Input Component](https://ui.shadcn.com/docs/components/input)
- [Form Component](https://ui.shadcn.com/docs/components/form)

### 12.2 常見問題解答

**Q: 現有用戶會受到影響嗎？**
A: 通過 OAuth 註冊的現有用戶不會受到影響。他們可以繼續使用 OAuth 登錄，也可以選擇添加密碼。

**Q: 密碼重置需要多久？**
A: 重置郵件應該在幾秒鐘內發送。重置鏈接通常在 1 小時內有效（可配置）。

**Q: 如果用戶忘記密碼會怎樣？**
A: 用戶可以點擊 "忘記密碼？" 鏈接，輸入電子郵件，接收重置郵件，設置新密碼。

**Q: 密碼要求是什麼？**
A: 至少 8 個字符，包含小寫字母、大寫字母和數字。

**Q: 電子郵件確認是否必需？**
A: 是的，新註冊的用戶必須確認電子郵件才能登錄。

**Q: OAuth 用戶需要確認電子郵件嗎？**
A: 不需要，OAuth 提供商已經驗證了電子郵件。

**Q: 如何測試電子郵件？**
A: 本地開發使用 Inbucket (http://127.0.0.1:54324)。生產環境配置真實的 SMTP 服務。

**Q: 遷移需要停機嗎？**
A: 不需要。這是一個添加功能的遷移，不是替換。現有功能繼續工作。

### 12.3 團隊聯絡資訊

**開發團隊：**
- 技術負責人：[姓名]
- 前端開發：[姓名]
- 後端開發：[姓名]

**支持團隊：**
- 客戶支持：[電子郵件]
- 技術支持：[電子郵件]

**緊急聯絡：**
- 緊急熱線：[電話]
- 待命工程師：[姓名]

---

## 13. 簽核

| 角色 | 姓名 | 簽名 | 日期 |
|------|------|------|------|
| 項目經理 | | | |
| 技術負責人 | | | |
| 開發負責人 | | | |
| QA 負責人 | | | |
| 產品負責人 | | | |

---

**文檔版本：** 1.0  
**最後更新：** 2025-11-15  
**下次審查：** 實施後 1 週

---

## 變更歷史

| 版本 | 日期 | 作者 | 變更描述 |
|------|------|------|----------|
| 1.0 | 2025-11-15 | AI Assistant | 初始版本 - 完整遷移計劃 |

---

**備註：** 本文檔是一份全面的遷移計劃。實施前請根據實際情況調整細節。如有疑問，請聯絡技術負責人。

