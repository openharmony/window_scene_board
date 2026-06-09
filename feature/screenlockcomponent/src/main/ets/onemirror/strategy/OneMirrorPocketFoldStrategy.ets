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

import { OneMirrorDefaultStrategy } from './OneMirrorDefaultStrategy';
import { ScreenOnOffService } from '@ohos/screenlockcommon';
import { OneMirrorService } from '../service/OneMirrorService';
import { slStateHelper } from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';

const TAG = 'OneMirrorPocketFoldStrategy';

/**
 * 一镜到底阔折叠手机策略 (VDE)
 */
export class OneMirrorPocketFoldStrategy extends OneMirrorDefaultStrategy {
  // 时钟组件UI状态管理
  private clockUiBindCtrl: SlClockBindState | undefined = slStateHelper.getSlClockBindState();

  public getName(): string {
    return TAG;
  }

  public onFold(isFold: boolean, isWallpaperAodState: boolean, isAodEnabled: boolean): void {
    if (isFold && !ScreenOnOffService.getInstance().isScreenOn && isAodEnabled) {
      // VDE灭屏折叠场景需要恢复时钟透明度, 避免AOD解锁第一帧时钟不可见
      this.clockUiBindCtrl?.setLayoutOpacity(1);
      if (!isWallpaperAodState) {
        // 需要将壁纸状态设置为AOD, 避免AOD解锁第一帧壁纸不可见
        OneMirrorService.getInstance().setWallpaperStateToAod();
      }
    }
  }
}