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
import { display } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { ThreadSync } from '../../messageChannel/ThreadSync';
import { Singleton } from '../../utils/Singleton';
import { BannerVm } from '../../vm/BannerVm';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { StatusBarHeightVm } from './StatusBarHeightVm'
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';

const TAG = 'CutoutVm'
const SINGLE_HOLE_WIDTH_HEIGHT_OFFSET: number = 2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
export interface Hole {
  centerX: number;
  centerY: number;
  radius: number;
}

export enum CutoutPosition {
  LEFT = 'left',
  MIDDLE = 'middle',
  RIGHT = 'right',
  UNKNOWN = 'unknown'
}

export enum CutoutType {
  NONE,
  WITHOUT_HOLE,
  NOTCH,
  NORMAL
}

/**
 * 屏幕挖孔信息VM，单位均为vp
 * 后续注意适配NOVA非圆球形挖孔
 */
@ThreadSync.VmDecorator
@ObservedV2
export class CutoutVm {

  // instrument ignore next
  @Singleton.decorate() static get instance() {
    return new CutoutVm();
  }

  public holes: Hole[] = [];
  // 物理设备的孔宽度，如果是多孔设备，则包含多孔之间的间隔
  public width: number = 0;
  public height: number = 0;
  @Trace public holeNum: number = 0;
  @Trace public position: CutoutPosition = CutoutPosition.MIDDLE;
  @Trace public left: number = 0;
  @Trace public right: number = 0;
  @Trace public top: number = -1;
  /**
   * 屏幕方向
   */
  @Trace public orientation: display.Orientation = display.Orientation.PORTRAIT;
  @Trace public isLandscape: boolean = false;
  @Trace public xtLayoutType: XTLayoutType = LayoutUtils.getFoldDisplayMode();
  @Trace public displayWidth: number = 0;
  /**
   * 设备的挖孔类型
   */
  @Trace public deviceCutoutType = CutoutType.NONE;
  public holeRadius: number = 0;
  public rect?: display.Rect;


  // 当前根据挖孔矩形长宽是否相等判断单孔、三孔，逻辑可能有缺陷，暂未考虑nova的挖孔形态，后续需完善
  updateCutoutInfoByCutoutRect(cutoutInfo: display.CutoutInfo, screenWidth: number, screenHeight: number) {
    this.calDeviceCutoutType(cutoutInfo, screenWidth, screenHeight);
    if (cutoutInfo.boundingRects.length === 0) {
      this.resetCutoutInfo();
      return;
    }
    let cutoutRect = cutoutInfo.boundingRects[0];
    // 统一转换为vp再计算
    cutoutRect = {
      left: px2vp(cutoutRect.left),
      top: px2vp(cutoutRect.top),
      width: px2vp(cutoutRect.width),
      height: px2vp(cutoutRect.height)
    }
    screenWidth = px2vp(screenWidth);
    let radius = 0;
    let isPortrait: boolean = cutoutRect.width > cutoutRect.height;
    radius = isPortrait ? cutoutRect.height / 2 : cutoutRect.width / 2;
    this.calCutoutHolesParams(cutoutRect, isPortrait, radius);
    this.width = cutoutRect.width;
    this.height = cutoutRect.height;
    this.holeNum = this.holes.length;
    this.left = cutoutRect.left;
    this.right = cutoutRect.left + cutoutRect.width;
    this.top = cutoutRect.top;
    this.holeRadius = radius;
    this.rect = cutoutRect;
    this.updateCutoutPosition(screenWidth);
  }

  private calCutoutHolesParams(cutoutRect: display.Rect, isPortrait: boolean, radius: number) {
    const holeNum: string =
      SystemUICcmConfig.instance.holeNumInfo.length > 0 ? SystemUICcmConfig.instance.holeNumInfo[0] : '';
    if (Math.abs(cutoutRect.width - cutoutRect.height) <= SINGLE_HOLE_WIDTH_HEIGHT_OFFSET || holeNum === '1') {
      this.holes = [{ centerX: cutoutRect.left + radius, centerY: cutoutRect.top + radius, radius: radius }]
    } else if (holeNum === '2') {
      this.holes = isPortrait ? [
      // 左孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + radius, radius: radius },
        // 右孔
        { centerX: cutoutRect.left + cutoutRect.width - radius, centerY: cutoutRect.top + radius, radius: radius }
      ] : [
      // 上孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + radius, radius: radius },
        // 下孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + cutoutRect.height - radius, radius: radius }
      ]
    } else {
      // 默认走三孔逻辑
      this.holes = isPortrait ? [
      // 左孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + radius, radius: radius },
        // 中孔
        { centerX: cutoutRect.left + cutoutRect.width / 2, centerY: cutoutRect.top + radius, radius: radius },
        // 右孔
        { centerX: cutoutRect.left + cutoutRect.width - radius, centerY: cutoutRect.top + radius, radius: radius }
      ] : [
      // 上孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + radius, radius: radius },
        // 中孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + cutoutRect.height / 2, radius: radius },
        // 下孔
        { centerX: cutoutRect.left + radius, centerY: cutoutRect.top + cutoutRect.height - radius, radius: radius }
      ]
    }
  }

  private calDeviceCutoutType(cutoutInfo: display.CutoutInfo, screenWidth: number, screenHeight: number) {
    // 无孔
    if (cutoutInfo.boundingRects.length === 0) {
      this.deviceCutoutType = CutoutType.WITHOUT_HOLE;
      return;
    }
    const cutoutRect = cutoutInfo.boundingRects[0];
    // 刘海屏至少有一边和屏幕边缘重叠
    if (cutoutRect.top === 0 || cutoutRect.left === 0 ||
      (cutoutRect.top + cutoutRect.height === screenHeight) ||
      (cutoutRect.left + cutoutRect.width === screenWidth)) {
      this.deviceCutoutType = CutoutType.NOTCH;
      return;
    }
    this.deviceCutoutType = CutoutType.NORMAL;
  }

  // 根据挖孔和屏幕属性，判断孔在屏幕上的位置
  private updateCutoutPosition(screenWidth: number): void {
    let cutoutPosition = CutoutPosition.UNKNOWN;
    // 孔位置和屏幕中间位置误差在3px以内认为是中挖孔(3孔屏可能挖孔不是在屏幕正中间,XT设备直板机形态挖孔左右误差2.1vp)
    if (Math.abs((this.left + this.right) / 2 - screenWidth / 2) < 3) {
      cutoutPosition = CutoutPosition.MIDDLE;
    } else if ((this.left + this.right) / 2 < screenWidth / 2) { // 在误差范围外，如果孔位置在屏幕左边为左挖孔，在屏幕右边为又挖孔
      cutoutPosition = CutoutPosition.LEFT;
    } else {
      cutoutPosition = CutoutPosition.RIGHT;
    }
    log.showWarn(`updateCutoutPosition,position: ${cutoutPosition}, left: ${this.left}, right: ${this.right}, screenWidth: ${screenWidth}`);
    this.position = cutoutPosition;
  }

  /**
   * 判断是否是中挖孔，需满足如下条件：
   * 1. 挖空区必须在状态栏内。排除竖屏导致场景
   * 2. 挖空区必须在屏幕中间。排除折叠屏展开右挖孔场景
   * 3. 挖孔top值必须大于0。排除刘海屏场景
   * @returns
   */
  public isMiddleCutout(): boolean {
    return this.isInStatusBar() && this.position === CutoutPosition.MIDDLE && this.top > 0;
  }

  /**
   * 判断当前屏幕顶部是否有刘海，需满足如下条件：
   * 1. 设备孔类型是刘海屏
   * 2. 挖孔区必须在屏幕中间
   * 3. top为0, 排除旋转180°的情况
   * @returns
   */
  public isNotchedScreen(): boolean {
    return this.deviceCutoutType === CutoutType.NOTCH && this.position === CutoutPosition.MIDDLE && this.top === 0;
  }

  public isXTLandscapeInvertedStatus(): boolean {
    return LayoutUtils.isXTProductType() && this.xtLayoutType === XTLayoutType.G &&
      this.orientation === display.Orientation.LANDSCAPE_INVERTED;
  }

  public isInStatusBar(): boolean {
    if (this.top === -1) {
      return false;
    }
    return this.top < StatusBarHeightVm.getInstance().getAvoidHeight() && this.top > 0;
  }


  private resetCutoutInfo(): void {
    this.position = CutoutPosition.UNKNOWN;
    this.holes = [];
    this.holeNum = 0;
    this.width = 0;
    this.height = 0;
    this.left = 0;
    this.right = 0;
    this.top = -1;
    this.holeRadius = 0;
    this.rect = undefined;
  }
}