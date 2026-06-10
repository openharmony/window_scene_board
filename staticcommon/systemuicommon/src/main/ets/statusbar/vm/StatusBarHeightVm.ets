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
import { DeviceHelper, ViewType } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { display } from '@kit.ArkUI';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { WindowAdapter } from '../../adapter/WindowAdapter';
import { StatusBarMaintenance } from '../../maintenance/statusbar/StatusBarMaintenance';
import { StatusBarMaintenanceErrorCode } from '../../maintenance/statusbar/StatusBarMaintenanceErrorCode';

const TAG = 'StatusBarHeightVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const OUTER_HOME_EXTRA_HEIGHT = 4;

class HeightInfo {
  public showHeightValue: number = 0;
  public isChangeHotAreaHeight: boolean = true;
}

@Observed
export class StatusBarHeightVm {
  private static instance?: StatusBarHeightVm = undefined;
  private avoidHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  private cacheUseHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height')); // 状态栏当前的显示高度
  private heightSetMap = new Map<string, HeightInfo>();
  private hotAreaHeight: number = this.cacheUseHeight; // 状态栏的热区高度
  private statueBarUiContext?: UIContext;
  private isForcedEnable: boolean = false;
  private forcedHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  private refreshStatusBarResponseRegion: () => void = () => {};
  private refreshStatusBarRegion: () => void = () => {};

  static getInstance(): StatusBarHeightVm {
    if (StatusBarHeightVm.instance === undefined) {
      StatusBarHeightVm.instance = new StatusBarHeightVm();
    }
    return StatusBarHeightVm.instance;
  }

  /**
   * 获取状态栏页面上下文组件关联的Context对象
   *
   * @return Context对象
   */
  public getStatueBarUiContext(): UIContext | undefined {
    return this.statueBarUiContext;
  }

  public injectStatusBarViewController(uiContext: UIContext,
    refreshStatusBarResponseRegion: (screenWidth?: number) => void, refreshStatusBarRegion:  () => void) {
    this.statueBarUiContext = uiContext;
    this.refreshStatusBarResponseRegion = refreshStatusBarResponseRegion;
    this.refreshStatusBarRegion = refreshStatusBarRegion;
  }

  /**
   * 强制调整状态栏高度，优先级高于 preSetShowHeight 设置的高度
   * @param isEnable
   * @param height
   */
  public forcedSetHeight(isEnable: boolean, height: number = 0): void {
    this.forcedHeight = height;
    this.isForcedEnable = isEnable
    log.showInfo(`forcedSetHeight ${this.forcedHeight} ${this.isForcedEnable}`);
    if (this.isForcedEnable) {
      try {
        this.confirmedStatusBarHeightChange(this.forcedHeight, this.forcedHeight);
      } catch (e) {
        log.error(`on forcedSetHeight property change error`, e);
      }
    } else {
      this.checkHeightChange();
    }
  }

  /**
   * 设置状态栏的避障高度
   */
  public setAvoidHeight(screenId: number, height: number): void {
    this.avoidHeight = height;
    log.showInfo(`setAvoidHeight ${this.avoidHeight}`);
    try {
    SceneSessionAdapter.setStatusBarAvoidHeight(screenId, vp2px(this.avoidHeight));
    } catch (e) {
      new StatusBarMaintenance().reportStatusBarInfo(StatusBarMaintenanceErrorCode.SET_AVOID_HEIGHT_FAIL,
        { avoidHeight: height });
      log.error(`setStatusBarAvoidHeight height ${height} error`, e);
    }

    this.checkHeightChange();
  }

  public getAvoidHeight(): number {
    return this.avoidHeight;
  }

  public getShowHeight(): number {
    return this.cacheUseHeight;
  }

  public getHotAreaHeight(): number {
    return this.hotAreaHeight;
  }

  /**
   * 添加状态栏显示高度数据，实际使用的未最大值
   */
  public preSetShowHeight(newHeight: number, setName: string, changeHotArea: boolean = true): void {
    log.showInfo(`preSetShowHeight setName: ${setName} newHeight: ${newHeight} changeHotArea: ${changeHotArea}`);
    this.heightSetMap.set(setName,  {showHeightValue: newHeight, isChangeHotAreaHeight: changeHotArea });
    this.checkHeightChange();
  }

  /**
   * 通过名称清理设置的状态栏显示高度
   */
  public clearShowHeight(setName: string): void {
    log.showInfo(`clearShowHeight ${setName}`);
    this.heightSetMap.delete(setName);
    this.checkHeightChange();
  }

  /**
   * 检查需要使用的最大高度
   */
  private checkHeightChange(): void {
    if (this.isForcedEnable) {
      return;
    }
    let maxHeight: number = -1;
    let maxHotArea: number = -1;
    this.heightSetMap.forEach((heightInfo: HeightInfo, name: string) => {
      if (maxHeight < heightInfo.showHeightValue) {
        maxHeight = heightInfo.showHeightValue;
      }
      if (heightInfo.isChangeHotAreaHeight) {
        maxHotArea = Math.max(heightInfo.showHeightValue, maxHotArea);
      }
    })
    if (maxHotArea <= -1) {
      maxHotArea = this.avoidHeight;
    }
    if (maxHeight <= -1) {
      maxHeight = this.avoidHeight;
    }
    log.showInfo(`checkHeightChange: cacheUseHeight ${this.cacheUseHeight} maxHeight ${maxHeight} maxHotArea: ${maxHotArea}`);
    if (this.cacheUseHeight !== maxHeight || this.hotAreaHeight !== maxHotArea) {
      try {
        this.confirmedStatusBarHeightChange(maxHeight, maxHotArea);
      } catch (e) {
        log.error(`on checkHeightChange property change error`, e);
      }
    }
  }

  /**
   * 确认状态栏避障高度修改
   */
  private confirmedStatusBarHeightChange(showHeight: number, maxHotArea: number) {
    this.cacheUseHeight = showHeight;
    this.hotAreaHeight = maxHotArea;
    this.refreshStatusBarRegion();

    // 状态栏热区更新
    this.statueBarUiContext?.runScopedTask(() => {
      this.refreshStatusBarResponseRegion();
    });
    log.showInfo(`confirmedStatusBarHeightChange: height ${showHeight} hotArea: ${maxHotArea}`);
  }
}