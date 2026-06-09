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

import { curves } from '@kit.ArkUI';
import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import sControlCenterBaseController from './ControlCenterBaseController';
import { BrightnessSharedViewData } from '../viewModel/BrightnessViewModel';
import { BackgroundBlurOpacity, BackgroundOpacity } from '../model/BrightnessViewData';

const TAG = 'Ctrl.MultimediaSubPageLayoutController';
const log: Logger = Logger.getLogHelper(LogDomain.CC);
const SLIDER_CHOSEN_TIMEOUT: number = 2000;

export enum PageMode {
  NONE,
  DETAIL
}

class MultimediaSubPageLayoutController {
  private pageMode: PageMode = PageMode.NONE;
  private mProxy: UIExtensionProxy | null = null;
  private backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  private blurOpacity: BackgroundBlurOpacity = BrightnessSharedViewData.getInstance().getBlurOpacity();
  private timerId: number | null = null;

  public getPageMode(): PageMode {
    return this.pageMode;
  }

  /**
   * 隐藏二级页面窗口
   *
   */
  public hideWindow() {
    this.pageMode = PageMode.NONE;
    this.mProxy = null;
    log.showInfo(TAG, 'multimedia subLayout hideWindow');
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MAIN_LAYOUT));
  }

  /**
   * 展示二级页面窗口
   *
   */
  public showWindow(availableList?: number[]) {
    ControlCenterHiSysEventUtil.reportCCClickMultimediaSensor({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      AVAILABLELIST: availableList?.join(',') ?? '',
    });
    this.pageMode = PageMode.DETAIL;
    log.showInfo(TAG, 'multimedia subLayout showWindow');
    sControlCenterBaseController.handleOnControlCenterWithScreenLockForUIE(() => {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.MULTIMEDIA_SUB_PAGE));
    }, true);
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
    if (this.pageMode === PageMode.NONE) {
      return false;
    }
    this.hideWindow();
    return true;
  }

  public onRemoteReady = (proxy: UIExtensionProxy): void => {
    this.mProxy = proxy;
    log.showInfo(TAG, `onRemoteReady, proxy is ${proxy}`);
  };

  public onRemoteReceive = (data: object) => {
    let obj: object;
    try {
      if (typeof data === 'string') {
        obj = JSON.parse(data);
      } else {
        obj = data;
      }
      let methodObj: string = obj['method'];
      log.showInfo(TAG, `detail receive: ${methodObj}, ${obj['param']}`);
      if (methodObj === 'isSliderChosen') {
        this.handleSliderChosen(obj);
      }
    } catch (err) {
      log.showError(TAG, `onRemoteReceive error: ${err}`);
    }
  };

  private handleSliderChosen(obj: object): void {
    if (typeof obj['param'] === 'boolean' && obj['param']) {
      this.clearTimeout();
      this.blurOpacity.blurOpacity = 0;
      animateTo({
        curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
        duration: 150
      }, () => {
        this.backgroundOpacity.backgroundOpacity = 0;
      });
      this.timerId = setTimeout(() => {
        this.resetOpacity();
      }, SLIDER_CHOSEN_TIMEOUT);
    } else {
      this.resetOpacity();
    }
  }

  private resetOpacity(): void {
    this.clearTimeout();
    this.blurOpacity.reset();
    animateTo({
      curve: curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0),
      duration: 150,
    }, () => {
      this.backgroundOpacity.reset();
    });
  }

  private clearTimeout(): void {
    if (this.timerId !== null) {
      clearTimeout(this.timerId);
      this.timerId = null;
    }
  }
}

export let sMultimediaSubPageLayoutController = SingletonHelper.getInstance(MultimediaSubPageLayoutController, TAG);
