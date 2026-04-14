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

import { IStatusBarPaddingVm } from '@ohos/systemuicommon/src/main/ets/statusbar/interface/IStatusBarPaddingVm';
import { CutoutVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/CutoutVm';
import { DeviceInfoVm } from '@ohos/systemuicommon/src/main/ets/vm/DeviceInfoVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper} from '@ohos/frameworkwrapper';
import { StatusBarPaddingBaseVm } from './StatusBarPaddingBaseVm';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'StatusbarPaddingVm');

@ObservedV2
export class StatusBarNotchPaddingVm extends StatusBarPaddingBaseVm {
  // UX 对齐方案，padding小于此值的要加4vp
  public readonly MIN_PADDING = 18;
  // UX 对齐方案，padding小于此值的要加4vp
  public readonly PADDING_DELTA = 4;
  // 当top传参异常，时的默认值，此值要尽量大，过小会影响大圆角的产品的显示
  public readonly DEFAULT_PADDING = 20;
  // 平板不走公式
  public readonly PAD_PADDING = 16;

  private getStatusBarUnAvailableArea(): number {
    let radius = DeviceInfoVm.instance.getDeviceRadius();
    log.showInfo(`calcPadding-radius: ${radius}`);
    if (radius < 0) {
      return this.DEFAULT_PADDING;
    }
    let height = CutoutVm.instance.height;
    if (CutoutVm.instance.rect?.left === 0 || ArkUIAdapter.vp2px(CutoutVm.instance.left) +
    ArkUIAdapter.vp2px(CutoutVm.instance.width) === DeviceInfoVm.instance.width) {
      height = CutoutVm.instance.width;
    }
    let unAvailable = Math.round(radius - Math.sqrt((2 * radius + 11 - height / 2) * (height / 2 - 11)));
    if (Number.isNaN(unAvailable)) {
      unAvailable = this.DEFAULT_PADDING;
    }
    if (unAvailable < this.MIN_PADDING) {
      unAvailable += this.PADDING_DELTA;
    }
    log.showInfo(`unAvailableArea: ${unAvailable}`);
    return unAvailable;
  }

  public calcStatusBarPadding(): void {
    /**
     * pad 按固定值
     */
    if (DeviceHelper.isPad()) {
      this.statusBarLeftPadding = this.PAD_PADDING;
      this.statusBarRightPadding = this.PAD_PADDING;
    } else if (this.statusBarLeftPadding === 0) {
      const unAvailableArea: number = this.getStatusBarUnAvailableArea();
      this.statusBarLeftPadding = unAvailableArea;
      this.statusBarRightPadding = unAvailableArea;
    }
    log.showInfo(`calcStatusBarPadding: ${this.statusBarLeftPadding}-${this.statusBarRightPadding}-
      ${this.statusBarTopPadding}`);
  }
}