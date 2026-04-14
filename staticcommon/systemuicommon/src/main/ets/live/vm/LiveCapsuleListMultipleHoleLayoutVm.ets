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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCapsuleListMiddleHoleLayoutVm } from './LiveCapsuleListMiddleHoleLayoutVm';

const TAG = 'LiveCapsuleListMultipleHoleLayoutVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCapsuleListMultipleHoleLayoutVm extends LiveCapsuleListMiddleHoleLayoutVm {
  /**
   * 计算进度类胶囊固定位置和偏移
   *
   * @param liveList 实况通知列表
   * @param isUpdate 是否需要立即更新胶囊的内容
   */
  public computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdate: boolean = true): void {
    log.showInfo('computeCapsuleFixedWithAndOffset');
    super.computeCapsuleFixedWithAndOffset(liveList, isUpdate);
  }

  /**
   * 设置进度类胶囊宽度
   *
   * @param liveList 实况通知列表
   * @param isUpdateImmediately 是否需要立即更新胶囊的内容
   */
  public setRemindCapsuleWidth(live: LiveNotification, isUpdateImmediately: boolean): void {
    log.showInfo('setRemindCapsuleWidth');
    super.setRemindCapsuleWidth(live, isUpdateImmediately);
  }
}