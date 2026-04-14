/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * 锁屏Trace Tag点
 */
export class TraceTag {
  // 进入密码页
  public static readonly SHOW_PSD = 'showPSD';

  // 解锁回调
  public static readonly NOTIFY_UNLOCK = 'notifyUnlock';

  // 上锁回调
  public static readonly NOTIFY_LOCK = 'notifyLock';

  // 取消认证
  public static readonly CANCEL_VERIFY = 'cancelVerify'
}