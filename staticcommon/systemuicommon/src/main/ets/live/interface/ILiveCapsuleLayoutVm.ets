/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LiveNotification } from '../model/LiveNotification';

/**
 * 实况胶囊布局VM
 */
export interface ILiveCapsuleListLayoutVm {
  capsuleListWidth?: number;
  capsuleListFixedWidth?: number;
  /**
   * 计算进度类胶囊固定位置和偏移
   * @param liveList
   * @param isUpdateImmediately 是否需要立即更新胶囊的内容
   */
  computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdateImmediately?: boolean): void;

  setRemindCapsuleWidth(live: LiveNotification, isUpdateImmediately: boolean): void;
}
