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
import common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { KeyguardStatusService } from '@ohos/screenlockcommon';
import { FloatingNavigationManager } from './FloatingNavigationManager';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { NaviBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/NaviBarVisualEffectManager';

const TAG = 'SCBNaviBarProxyManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const INVALID_CONNECTION: number = -1;
const CONNECTED: number = 1;
const INIT: number = 0;

export class SCBNaviBarProxyManager {
  private static instance: SCBNaviBarProxyManager | undefined = undefined;
  private connectStatus: number = INVALID_CONNECTION;
  private connectHaloStatus: number = INVALID_CONNECTION;
  private connectId: number = INVALID_CONNECTION;
  private context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  // 准备执行的方法队列，TS内map有序
  private pendingExecFuncMap: Map<string, Function> = new Map();
  private proxyCallBackMap: Map<string, Function> = new Map();
  public curNotifyType: string = '';

  /**
   * 获取链接状态
   * @returns 链接状态
   */
  public getConnectHaloStatus(): number {
    return this.connectHaloStatus;
  }

  /**
   * 初始化链接状态
   * @returns 链接状态
   */
  public initConnectHaloStatus(): void {
    this.connectHaloStatus = INIT;
  }

  public static getInstance(): SCBNaviBarProxyManager {
    if (SCBNaviBarProxyManager.instance === undefined) {
      SCBNaviBarProxyManager.instance = new SCBNaviBarProxyManager();
    }
    return SCBNaviBarProxyManager.instance;
  }

  /**
   * register GestureEnable Callback
   * @param type
   * @param callback
   */
  public registerProxyCallback(type: string, callback: Function): void {
    log.info(`registerProxyCallback type:${type}`);
    this.proxyCallBackMap.set(type, callback);
  }

  /**
   *  unregister GestureEnable Callback
   * @param type
   */
  public unRegisterProxyCallback(type: string): void {
    if (this.proxyCallBackMap.has(type)) {
      this.proxyCallBackMap.delete(type);
    } else {
      log.info(`${type} has not registerProxyCallback`);
    }
  }

  /**
   * 通过传入方法执行回调
   *
   * @param func 传入的需要回调的方法
   * @param type 传入的可能存在的方法类型
   * @param extra 传入的可能存在的附加参数
   *
   */
  public executeCallbackByType(func: string, type?: string, extra?: string): void {
    log.info(`execute function:${func}`);
    let callback = this.proxyCallBackMap.get(func);
    if (callback) {
      callback(type, extra);
    }
  }

  /**
   * 执行所有回调
   *
   */
  public executeCallback(): void {
    this.proxyCallBackMap.forEach((item: Function) => {
      item();
    });
  }

  private destroyOrFailOrDisconnectCallBack(): void {
    this.connectStatus = INVALID_CONNECTION;
    this.connectHaloStatus = INVALID_CONNECTION;
    this.pendingExecFuncMap?.clear();
    this.executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_EXIT_FUNC);
    this.executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC);
    FloatingNavigationManager.getInstance().setIsHiddenScene(false);
    FloatingNavigationManager.getInstance().setShowVerifyImmersiveState();
  }

  /**
   * Destroy single instance
   */
  public destroy(): void {
    this.curNotifyType = '';
    log.info(`destroy this.connectId:${this.connectId}`);
    this.context?.disconnectServiceExtensionAbility(this.connectId).then(() => {
      log.info('disconnect success.');
    }).catch((err: BusinessError) => {
      log.error(`disconnect failed. Error code: ${err.code}`);
      this.destroyOrFailOrDisconnectCallBack();
    });
  }
}

export enum IdlCode {
  RECEIVE_NAVIBAR_HIDE = 1003,
  RECEIVE_NAVIBAR_SHOW = 1007,
  SEND_FLOATING_NAV_SHOW = 1011,
  SEND_FLOATING_NAV_HIDE = 1012,
  SEND_FLOATING_NAV_IS_DESKTOP = 1013,
  SEND_FLOATING_NAV_IS_IN_APP = 1014,
  SEND_FLOATING_NAV_IS_LOCK = 1015,
}

export enum NaviBarRegisterFunc {
  NAVIBAR_EXIT_FUNC = 'naviBarExit',
  NAVIBAR_SHOW_FUNC = 'naviBarShow',
  NAVIBAR_HIDE_FUNC = 'naviBarHide',
}