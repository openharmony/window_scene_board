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

import { CutoutPosition, CutoutVm,
  DeviceInfoVm,
  EnvVm,
  ResourceVm,
} from '@ohos/systemuicommon/newIndex';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, FoldPhoneTypeValue } from '@ohos/frameworkwrapper';
import display from '@ohos.display';
import DeviceInfo from '@ohos.deviceInfo';
import { StatusBarPaddingBaseVm } from './StatusBarPaddingBaseVm';
import { StatusBarType } from '@ohos/systemuicommon/Index';
import { RotationConstants } from '@ohos/commonconstants';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
// instrument ignore file

export const productSeries: string = DeviceInfo.productSeries;

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'StatusbarCommonPaddingVm');

@ObservedV2
export class StatusBarCommonPaddingVm extends StatusBarPaddingBaseVm {
  // UX 对齐方案，padding小于此值的要加4vp
  public readonly MIN_PADDING = 18;
  // UX 对齐方案，padding小于此值的要加4vp
  public readonly PADDING_DELTA = 4;
  // 当top传参异常，时的默认值，此值要尽量大，过小会影响大圆角的产品的显示
  public readonly DEFAULT_PADDING = 20;
  // 无孔设备
  public readonly WITHOUT_HOLE_PADDING = 16;

  private calPadding = this.DEFAULT_PADDING;

  private diffPadding = 2;

  protected getStatusBarUnAvailableArea(): number {
    let radius = DeviceInfoVm.instance.getDeviceRadius();
    log.showInfo(`calcPadding-radius: ${radius}`);
    // 不满足计算条件
    if (radius < 0) {
      return this.DEFAULT_PADDING;
    }
    let topSpace = this.cutoutVm.top;
    let unAvailable = Math.round(radius - Math.sqrt((2 * radius - topSpace) * topSpace));
    if (Number.isNaN(unAvailable)) {
      unAvailable = this.DEFAULT_PADDING;
    }
    if (unAvailable < this.MIN_PADDING) {
      unAvailable += this.PADDING_DELTA;
    }
    log.showInfo(`unAvailableArea: ${unAvailable}`);
    if (DeviceInfoVm.instance.isCustomDevice) {
      return unAvailable - this.diffPadding;
    }
    return unAvailable;
  }

  public calcStatusBarPadding(): void {
    // 锁屏只支持正向竖屏（除pad、折叠屏展开态），不响应其它角度数据更新
    if (!DeviceHelper.isPad() && EnvVm.instance.isScreenLock && this.cutoutVm.isLandscape &&
      !DeviceHelper.isFoldExpanded() &&
      DeviceHelper.getFoldProductType() !== FoldPhoneTypeValue.EXPANDING_THREE_FOLD_PRODUCT) {
      return;
    }

    if (this.cutoutVm.orientation === display.Orientation.PORTRAIT && this.cutoutVm.isInStatusBar()) {
      this.calPadding = this.getStatusBarUnAvailableArea();
    }

    this.computeTopPadding();

    let leftPadding = this.calPadding;
    let rightPadding = this.calPadding;
    log.showInfo(`cutout position: ${CutoutVm.instance.position} CutoutVm.instance.left ${CutoutVm.instance.left} CutoutVm.instance.width ${CutoutVm.instance.width}`);
    if (CutoutVm.instance.position === CutoutPosition.LEFT && (this.isDisplayLand() || this.checkStatusBarOver())) {
      leftPadding = CutoutVm.instance.left + CutoutVm.instance.width + this.leftCutoutPadding;
    }
    if (CutoutVm.instance.position === CutoutPosition.RIGHT &&
      (this.cutoutVm.orientation === display.Orientation.LANDSCAPE || this.checkStatusBarOver())) {
      rightPadding = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - CutoutVm.instance.left + this.leftCutoutPadding;
    }

    if (productSeries.includes('XYAO') && DeviceInfoVm.instance.orientation === display.Orientation.PORTRAIT) {
      rightPadding += 4;
    }

    if (ResourceVm.instance.isRTL) {
      this.refreshStatusBarPadding(rightPadding, leftPadding);
    } else {
      this.refreshStatusBarPadding(leftPadding, rightPadding);
    }
  }

  private refreshStatusBarPadding(leftPadding: number, rightPadding: number) {
    log.showInfo(`refresh padding: isRTL: ${ResourceVm.instance.isRTL}, left: ${leftPadding}, right: ${rightPadding}` +
      `top: ${this.statusBarTopPadding}`);
    this.statusBarLeftPadding = leftPadding;
    this.statusBarRightPadding = rightPadding;
  }

  protected computeTopPadding(): void {
    log.showInfo(`computeTopPadding ${CutoutVm.instance.orientation}`);
    // 竖屏计算顶部偏移
    if (CutoutVm.instance.orientation !== display.Orientation.PORTRAIT) { // 竖屏特有，左右避让曲面+顶部避让挖孔
      return;
    }
    if (!CommonUtils.isInvalid(CutoutVm.instance.rect) && CutoutVm.instance.rect) {
      this.statusBarTopPadding = this.calculateTopPaddingInV2(CutoutVm.instance.rect);
    }
  }

  private calculateTopPaddingInV2(cutoutArea: display.Rect): number {
    const cutoutCenterY = cutoutArea.top + cutoutArea.height / 2;
    const topPadding = cutoutCenterY - (this.defaultHeight / 2);
    return topPadding > 0 ? topPadding : 0;
  }

  private isDisplayLand(): boolean {
    return this.cutoutVm.orientation === display.Orientation.LANDSCAPE ||
      this.cutoutVm.orientation === display.Orientation.LANDSCAPE_INVERTED;
  }

  protected checkStatusBarOver(): boolean {
    const hasPull = StatusBarType.hasPull(this.envVm.statusBarType);
    const hasSingle = StatusBarType.hasSingle(this.envVm.statusBarType);
    // 下沉状态、单手模式，状态栏不会被遮挡
    if (hasPull || hasSingle || this.deviceInfoVm.realRotateAngle === RotationConstants.ROTATION_180) {
      return false;
    }
    // 状态栏高度超出挖孔top视为被遮挡
    return this.cutoutVm.isInStatusBar();
  }
}