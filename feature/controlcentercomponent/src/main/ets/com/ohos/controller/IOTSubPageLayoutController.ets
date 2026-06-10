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

import { SingletonHelper, LogHelper, LogDomain } from '@ohos/basicutils';
import { sEventManager, obtainLocalEvent } from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { LauncherAbilityManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/LauncherAbilityManagerAdapter';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { onAsyncReceiverRegister } from '../common/UIExtensionProxyHelper';
import lazy sControlCenterController from './ControlCenterController';

const TAG: string = 'Ctrl.IOTSubLayoutController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export enum PageMode {
  NONE,
  DETAIL,
}

export class IOTSubPageLayoutController {
  private iotDetailParam: Object | null = null;
  private pageMode: PageMode = PageMode.NONE;
  private mProxy: UIExtensionProxy | null = null;
  private isIotShowDialog: boolean = false;
  private isAiLifeInstalled: boolean = false;

  constructor() {
  }

  public showDetail(param: Object | null): void {
    this.iotDetailParam = param;
    this.pageMode = PageMode.DETAIL;
    this.showWindow();
    this.getAiLifeInstallStatus();
  }

  public onRemoteReady = (proxy: UIExtensionProxy): void => {
    this.mProxy = proxy;
    log.showInfo(`onRemoteReady, proxy is ${proxy}`);
    if (this.pageMode === PageMode.DETAIL) {
      onAsyncReceiverRegister(proxy, (p: UIExtensionProxy) => {
        log.showInfo('onAsyncReceiverRegister');
        p?.send({ 'method': 'postParam', 'param': this.iotDetailParam ?? '' });
      })
    }
  }

  public getPageMode(): PageMode {
    return this.pageMode;
  }

  /**
   * 隐藏二级页面窗口
   *
   * @param toggleSlot 二级页面标识
   */
  hideWindow() {
    this.pageMode = PageMode.NONE;
    this.iotDetailParam = null;
    this.mProxy = null;
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 0));
  }

  /**
   * 息屏时关闭窗口
   */
  onScreenOff() {
    this.hideWindow();
  }

  /**
   * 返回键，关闭窗口
   *
   * @return true 处理了返回事件，false 未消费事件
   */
  onBackPress(): boolean {
    if (this.pageMode === PageMode.NONE) {
      return false;
    }
    if (this.pageMode === PageMode.DETAIL) {
      if (this.isIotShowDialog && this.mProxy) {
        this.mProxy.send({ 'method': 'clickBlank' });
        return false;
      }
      this.hideWindow();
      return true;
    }
    return true;
  }

  public onBlankAreaTouch = (event?: TouchEvent): void => {
    if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
      if (this.isIotShowDialog && this.mProxy) {
        this.mProxy.send({ 'method': 'clickBlank' });
      } else {
        sIOTSubPageLayoutController.hideWindow();
      }
    }
  };
  public onRemoteReceive = (data: object) => {
    let obj: object;
    if (typeof data === 'string') {
      obj = JSON.parse(data);
    } else {
      obj = data;
    }
    let methodObj: string = obj['method'];
    log.showInfo(`detail receive: ${methodObj}`);
    if (methodObj === 'back') {
      this.hideWindow();
    } else if (methodObj === 'closeControlCenter') {
      sControlCenterController.setDelayReleaseIot(true);
      DropDownPanelManager.hideWindowDirectly();
    } else if (methodObj === 'iotShowDialog') {
      this.isIotShowDialog = obj['param'] === 1;
    } else if (methodObj === 'showToast') {
      let msg = String(obj['message']);
      sControlCenterController.showToast(msg);
    }
  };

  private showWindow(): void {
    sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.IOT_SUB_PAGE));
  }

  private getAiLifeInstallStatus() {
    LauncherAbilityManagerAdapter.isAbilityInstalledAsync({
      bundleName: 'com.ohos.ailife',
      callback: (isInstalled: boolean) => {
        log.showInfo(`ailife installed: ${isInstalled}`);
        this.isAiLifeInstalled = isInstalled;
      }
    }, `${TAG}_isAbilityInstalledAsync`);
  }
}

export let sIOTSubPageLayoutController = SingletonHelper.getInstance(IOTSubPageLayoutController, TAG);
