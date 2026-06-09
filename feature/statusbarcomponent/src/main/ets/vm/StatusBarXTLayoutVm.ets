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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { XTLayoutType } from '@ohos/systemuicommon';
import { DeviceInfoVm, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { LiveStyle } from '@ohos/systemuicommon/src/main/ets/live/constants/LiveStyle';
import { StatusBarLayoutVm } from './StatusBarLayoutVm';
import { display } from '@kit.ArkUI';
import lazy {
  SCBTripleStateChange,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
// instrument ignore file

const TAG = 'StatusBarXTLayoutVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// XT设备G态挖孔屏幕镜像位置
interface MirrorCutout {
  top: number;
  right: number;
  width: number;
  height: number;
}

@ObservedV2
export class StatusBarXTLayoutVm extends StatusBarLayoutVm {
  @Monitor('deviceInfoVm.xtLayoutType')
  onXTLayoutTypeChange(): void {
    log.showInfo(`onXTLayoutTypeChange, ${this.deviceInfoVm.xtLayoutType}, ${this.deviceInfoVm.tripleStateChange}, ${this.deviceInfoVm.widthChangeDelta}`);
    if (this.deviceInfoVm.tripleStateChange === SCBTripleStateChange.G_TO_M ||
      this.deviceInfoVm.tripleStateChange === SCBTripleStateChange.M_TO_G ||
      this.deviceInfoVm.tripleStateChange === SCBTripleStateChange.F_TO_G ||
      this.deviceInfoVm.tripleStateChange === SCBTripleStateChange.G_TO_F) {
      this.vmInjector.getStatusBarAnimVm().animateGroupTranslate(
        this.deviceInfoVm.tripleStateChange,
        this.deviceInfoVm.lastOrientation,
        this.deviceInfoVm.widthChangeDelta);
    }
  }

  onLanguageChange(): void {
    this.statusBarPaddingVm.updateStatusBarPadding();
    // F态挖孔不是正居中，G态挖孔不对称，需要更新胶囊位置信息
    if (this.deviceInfoVm.isXTLandscapeInvertedStatus() || this.deviceInfoVm.xtLayoutType === XTLayoutType.F) {
      this.statusbarLayoutRefresh();
      this.recalculateLayout(true);
    }
  }

  protected iconMarginEndCheck(iconLeft: number, iconRight: number): number {
    const mirrorCutout = this.getCutoutMirrorPosition();
    if (this.checkOverlapCutout(iconLeft)) {
      if (this.isSystemIconCrossHoleState()) {
        return mirrorCutout.width + (iconRight - mirrorCutout.right) + this.iconGap;
      }
    }
    return 0;
  }

  protected refreshCapsulePosition(): void {
    if (this.cutoutVm.isXTLandscapeInvertedStatus() && !this.resourceVm.isRTL) {
      this.refreshCapsulePositionWithGStatus();
    } else if (this.cutoutVm.xtLayoutType === XTLayoutType.F &&
      this.cutoutVm.orientation === display.Orientation.PORTRAIT && this.resourceVm.isRTL) {
      // XT设备单屏状态挖孔不在屏幕正居中状态，镜像语言场景需做一些偏移，保证融球和挖孔对齐
      this.refreshCapsulePositionWithFRTLStatus();
    } else {
      super.refreshCapsulePosition();
    }
    log.info('XT device refreshCapsulePosition finish', this.capsulePosition);
  }

  private refreshCapsulePositionWithGStatus(): void {
    this.metaBallPadding = LiveStyle.CAPSULE_HEIGHT / 2 - this.cutoutVm.holeRadius;
    this.capsulePosition.left = this.cutoutVm.right + this.metaBallPadding;
    this.capsulePosition.top = this.cutoutVm.top - this.metaBallPadding;
    this.capsulePosition.width = 0;
    this.capsulePosition.height = this.cutoutVm.height + this.metaBallPadding * 2;
    this.capsulePosition.holes = this.cutoutVm.holes;
    this.capsulePosition.statusBarClockLeftSpace =
      this.cutoutVm.left + this.cutoutVm.holeRadius - LiveStyle.CARD_WIDTH / 2;
  }

  private refreshCapsulePositionWithFRTLStatus(): void {
    this.metaBallPadding = LiveStyle.CAPSULE_HEIGHT / 2 - this.cutoutVm.holeRadius;
    this.capsulePosition.left = this.cutoutVm.left - this.metaBallPadding - this.getDeviceCutoutDelta();
    this.capsulePosition.top = this.cutoutVm.top - this.metaBallPadding;
    this.capsulePosition.width = this.cutoutVm.width + this.metaBallPadding * 2;
    this.capsulePosition.height = this.cutoutVm.height + this.metaBallPadding * 2;
    this.capsulePosition.holes = this.cutoutVm.holes;
  }

  private getDeviceCutoutDelta(): number {
    const leftWidth = this.cutoutVm.left;
    const rightWidth = ArkUIAdapter.px2vp(this.deviceInfoVm.width) - this.cutoutVm.left - this.cutoutVm.width;
    return Math.abs(leftWidth - rightWidth);
  }
  /**
   * 获取XT设备全展开状态挖孔镜像位置，用于适配镜像语言场景状态栏下拉跨孔
   * @returns
   */
  private getCutoutMirrorPosition(): MirrorCutout {
    return {
      width: this.cutoutVm.width,
      right: ArkUIAdapter.px2vp(this.deviceInfoVm.width) - this.cutoutVm.left,
      top: this.cutoutVm.top,
      height: this.cutoutVm.height
    }
  }

  /**
   *挖孔重叠检查
   */
  protected checkOverlapCutout(iconLeft: number): boolean {
    if (this.deviceInfoVm.xtLayoutType !== XTLayoutType.G) {
      return super.checkOverlapCutout(iconLeft);
    }
    if (this.isSystemIconCrossHoleState()) {
      return iconLeft < this.getCutoutMirrorPosition().right + this.iconGap;
    }
    return false;
  }

  private isSystemIconCrossHoleState(): boolean {
    return this.deviceInfoVm.xtLayoutType === XTLayoutType.G &&
      this.deviceInfoVm.orientation === display.Orientation.LANDSCAPE_INVERTED &&
      this.resourceVm.isRTL;
  }

  /**
   * 计算状态栏左侧区域的图标的实际显示情况占用宽度：
   * @returns
   */
  protected computeLeftGroupWidth(): number {
    // 固定形态直接返回孔的位置
    if (DeviceInfoVm.instance.isXTSpecialState()) {
      return this.cutoutVm.right + this.metaBallPadding;
    }
    return super.computeLeftGroupWidth();
  }
}