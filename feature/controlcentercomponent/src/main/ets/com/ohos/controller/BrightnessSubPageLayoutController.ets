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

import { performanceMonitor } from '@kit.ArkUI';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import {
  HiSysEventUtil,
  obtainLocalEvent,
  obtainStartAbilityWithWant,
  sEventManager,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import { SliderButtonShareData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import sControlCenterBaseController from './ControlCenterBaseController';

const TAG: string = 'BrightnessSubPageLayoutController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum PageMode {
  NONE,
  DETAIL
}

/**
 * 二级页被拉起方式，横向进度条 or 竖向进度条
 */
export enum SubPageMode {
  HORIZONTAL,
  VERTICAL
}

class BrightnessSubPageLayoutController extends BaseController<CommonData> {
  getData(): CommonData {
    return new CommonData();
  }

  isAvailable(): boolean {
    return true;
  }

  private pageMode: PageMode = PageMode.NONE;
  private subpageMode: SubPageMode = SubPageMode.HORIZONTAL;

  public getPageMode(): PageMode {
    return this.pageMode;
  }

  public isHorizontal(): boolean {
    return this.subpageMode === SubPageMode.HORIZONTAL;
  }

  /**
   * 隐藏二级页面窗口
   *
   */
  public hideWindow() {
    log.showInfo('brightness subLayout hideWindow');
    if (this.pageMode === PageMode.NONE) {
      return;
    }
    this.pageMode = PageMode.NONE;
    if (SliderButtonShareData.getInstance().isDragging) {
      log.showInfo('slider is dragging, not hide window');
      return;
    }
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
    performanceMonitor.begin('EXIT_CC_SUB_BRIGHTNESS_ANI', performanceMonitor.ActionType.LAST_UP);
  }

  /**
   * 展示二级页面窗口
   *
   */
  public showWindow(isHorizontal: boolean = true) {
    this.subpageMode = isHorizontal ? SubPageMode.HORIZONTAL : SubPageMode.VERTICAL;
    this.pageMode = PageMode.DETAIL;
    log.showInfo('brightness subLayout showWindow');
    sControlCenterBaseController.handleOnControlCenterWithScreenLockForUIE(() => {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.BRIGHTNESS_SUBPAGE));
      performanceMonitor.begin('INTO_CC_SUB_BRIGHTNESS_ANI', performanceMonitor.ActionType.LAST_UP);
    }, true);
    // 用户行为打点
    HiSysEventUtil.reportCCQuickToggleLongClick({
      LOCKSTATUS: AppStorage.get('lockStatus'),
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      BUTTON_NAME: 'brightness_button',
      STATE: 'true',
      TYPE: 1,
      SCREENTYPE: 0
    });
  }

  /**
   * 息屏时关闭窗口
   */
  public onScreenOff() {
    this.hideWindow();
  }

  /**
   * 返回键，关闭窗口
   *
   * @return true 处理了返回事件，false 未消费事件
   */
  public onBackPress(): boolean {
    if (this.pageMode === PageMode.NONE || SliderButtonShareData.getInstance().isDragging) {
      return false;
    }
    this.hideWindow();
    return true;
  }

  public goBrightnessSetting(): void {
    log.showInfo(`goBrightnessSetting`);
    this.handleGoSettingWithScreenLock(() => {
      EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
        bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
        uri: 'display_settings',
        moduleName: 'phone'
      }));
      DropDownPanelManager.hideWindowDirectly();
    })
  }
}

export let sBrightnessSubPageLayoutController: BrightnessSubPageLayoutController =
  SingletonHelper.getInstance(BrightnessSubPageLayoutController, TAG);
