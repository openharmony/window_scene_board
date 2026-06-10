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
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ScreenBp, SizeBp } from '../immersivekgcommon/base/utils/ScreenBreakPoint';
import { DisplayStateListener, DisplayStateManager } from '../manager/DisplayStateManager';
import { UltraScreenStatus } from '../utils/DisplayUtils';
import { StateTransferable } from './StateTransferable';

const TAG = 'SlViewController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const IS_ULTRA_SCREEN = DeviceHelper.isUltraScreenProduct();

/**
 * 基础锁屏视图控制器
 *
 * @since 2024-08-31
 */
export abstract class SlViewController<T> extends StateTransferable<T> implements DisplayStateListener {

  /**
   * 执行初始化
   */
  protected doInit(_params?: object | number): void {
    DisplayStateManager.getInstance().registerObserver(this);
  }

  /**
   * 执行释放
   */
  protected doRelease(): void {
    super.doRelease();
    DisplayStateManager.getInstance().unRegisterObserver(this);
  }

  /**
   * 是否使能
   */
  protected isEnable(): boolean {
    return true;
  }

  /**
   * 当前是否为竖屏
   */
  public isPortrait(): boolean {
    return DisplayStateManager.getInstance().isPortrait();
  }

  /**
   * 当前是否为折叠屏展开态
   */
  public isFoldExpanded(): boolean {
    return DisplayStateManager.getInstance().isFoldExpanded();
  }

  public onOrientationChange(orientation: number): void {
    log.showDebug(`onOrientationChange ${orientation}`);
  }

  public onScreenSizeChange(width: number, height: number): void {
    log.showDebug(`onScreenSizeChange ${width}, ${height}`);
  }

  /**
   * 屏幕折叠状态发生改变（透传）
   * @param isFoldExpand 折叠状态
   */
  public onFoldStateChange(isFoldExpand: boolean): void {
    log.showDebug(`onFoldStateChange ${isFoldExpand}`);
  }

  /**
   * 获得超大屏当前状态
   *
   * @returns 折展状态
   */
  public getUltraScreenStatus(screenBp: ScreenBp): UltraScreenStatus | undefined {
    if (!IS_ULTRA_SCREEN) {
      return undefined;
    }
    if (!screenBp) {
      return DeviceHelper.isFState() ? UltraScreenStatus.F_STATUS :
        (DeviceHelper.isMState() ? UltraScreenStatus.M_STATUS : UltraScreenStatus.G_STATUS)
    }
    if (screenBp.widthBp === SizeBp.SM && screenBp.heightBp === SizeBp.LG) {
      return UltraScreenStatus.F_STATUS;
    } else if (screenBp.widthBp === SizeBp.MD && screenBp.heightBp === SizeBp.MD) {
      return UltraScreenStatus.M_STATUS;
    } else {
      return UltraScreenStatus.G_STATUS;
    }
  }
}