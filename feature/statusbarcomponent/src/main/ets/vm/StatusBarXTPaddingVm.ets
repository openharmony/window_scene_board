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
import { CutoutPosition, CutoutVm, DeviceInfoVm, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { display } from '@kit.ArkUI';
import { StatusBarCommonPaddingVm } from './StatusBarCommonPaddingVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { XTLayoutType } from '@ohos/systemuicommon';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
// instrument ignore file

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'StatusBarXTPaddingVm');

@ObservedV2
export class StatusBarXTPaddingVm extends StatusBarCommonPaddingVm {
  // XT设备F态屏幕是小圆角，不能使用公式计算，复用5.0的padding值
  private fStatusDefaultPadding = 12;
  public calcStatusBarPadding(): void {
    log.showInfo(`StatusBarXTPaddingVm calcStatusBarPadding, position: ${this.cutoutVm.position}, xtType: ${this.cutoutVm.xtLayoutType}, orientation: ${this.cutoutVm.orientation}`);
    if ((this.cutoutVm.xtLayoutType === XTLayoutType.F &&
        this.cutoutVm.orientation === display.Orientation.PORTRAIT) ||
        (this.cutoutVm.xtLayoutType === XTLayoutType.G &&
        this.cutoutVm.orientation === display.Orientation.LANDSCAPE_INVERTED)) {
      this.computeTopPadding();
    }
    this.computeLeftAndRightPadding();
    log.showInfo(`calcStatusBarPadding: top: ${this.statusBarTopPadding}, left: ${this.statusBarLeftPadding}, rigth: ${this.statusBarRightPadding}`);
  }

  private computeLeftAndRightPadding(): void {
    if (this.cutoutVm.xtLayoutType === XTLayoutType.G) {
      this.computeLeftAndRightPaddingWithGState();
    } else if (this.cutoutVm.xtLayoutType === XTLayoutType.M) {
      this.computeLeftAndRightPaddingWithMState();
    } else {
      this.computeLeftAndRightPaddingWithFState();
    }
  }

  private computeLeftAndRightPaddingWithGState(): void {
    let leftPadding = this.withoutHoleDefaultPadding;
    let rightPadding = this.withoutHoleDefaultPadding;
    if (this.cutoutVm.orientation === display.Orientation.PORTRAIT) {
      leftPadding = this.withoutHoleDefaultPadding;
      rightPadding = ArkUIAdapter.px2vp(this.cutoutVm.displayWidth) - this.cutoutVm.left + this.leftCutoutPadding;
    } else if (this.cutoutVm.orientation === display.Orientation.LANDSCAPE) {
      leftPadding = this.withoutHoleDefaultPadding;
      rightPadding = this.withoutHoleDefaultPadding;
    } else if (this.cutoutVm.orientation === display.Orientation.PORTRAIT_INVERTED) {
      leftPadding = this.cutoutVm.left + this.cutoutVm.width + this.leftCutoutPadding;
      rightPadding = this.withoutHoleDefaultPadding;
    } else if (this.cutoutVm.orientation === display.Orientation.LANDSCAPE_INVERTED) {
      leftPadding = this.withoutHoleDefaultPadding;
      rightPadding = this.withoutHoleDefaultPadding;
    } else {
      log.showWarn(`unknown display orientation: ${this.cutoutVm.orientation}`);
    }
    if (ResourceVm.instance.isRTL) {
      this.statusBarLeftPadding = rightPadding;
      this.statusBarRightPadding = leftPadding;
    } else {
      this.statusBarLeftPadding = leftPadding;
      this.statusBarRightPadding = rightPadding;
    }
  }

  private computeLeftAndRightPaddingWithMState(): void {
    this.statusBarLeftPadding = 16;
    this.statusBarRightPadding = 16;
  }

  private computeLeftAndRightPaddingWithFState(): void {
    let leftPadding = this.fStatusDefaultPadding;
    let rightPadding = this.fStatusDefaultPadding;
    if (this.cutoutVm.position === CutoutPosition.LEFT &&
      (this.cutoutVm.isLandscape || this.checkStatusBarOver())) {
      leftPadding = CutoutVm.instance.left + CutoutVm.instance.width + this.leftCutoutPadding;
    }
    if (this.cutoutVm.position === CutoutPosition.RIGHT &&
      (this.cutoutVm.isLandscape || this.checkStatusBarOver())) {
      rightPadding = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - CutoutVm.instance.left + this.leftCutoutPadding;
    }
    if (ResourceVm.instance.isRTL) {
      this.statusBarLeftPadding = rightPadding;
      this.statusBarRightPadding = leftPadding;
    } else {
      this.statusBarLeftPadding = leftPadding;
      this.statusBarRightPadding = rightPadding;
    }
  }
}