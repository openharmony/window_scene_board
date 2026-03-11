/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneInfo } from '../../session/SCBSceneInfo';
import sSCBOobeManager from '../../../oobe/SCBOobeManager';
import { INVALID_PANEL_ID, INVALID_SCREEN_ID, SCBSceneSessionManager } from '../../session/SCBSceneSessionManager';

const TAG = 'SCBSceneStartInterceptor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export enum StartInterceptions {
  FROM_ICON = 'FromIcon',
  FROM_TRANSITION = 'FromTransition',
  FROM_OTHER = 'FromOther',
  FROM_NOTIFICATION = 'FromNotification',
  FROM_RECENT = 'FromRecent',
  BY_CALL = 'ByCall',
}
// 定义拦截规则函数类型
export type SceneInterceptorRule = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => boolean;

/**
 * Scene start interceptor
 */
export class SCBSceneStartInterceptor {
  private static instance: SCBSceneStartInterceptor;
  // key1 screenId, key2 panelId
  private interceptorRules: Map<number, Map<number, Array<SceneInterceptorRule>>> = new Map();

  private notifyOobeCallback: Function;

  private constructor() {}

  public static getInstance(): SCBSceneStartInterceptor {
    if (!SCBSceneStartInterceptor.instance) {
      SCBSceneStartInterceptor.instance = new SCBSceneStartInterceptor();
    }
    return SCBSceneStartInterceptor.instance;
  }

  /**
   * 注册窗口启动拦截规则
   * @param rule 拦截规则函数
   * @param screenId
   * @param panelId
   */
  public registerInterceptorRule(rule: SceneInterceptorRule, screenId: number, panelId: number): void {
    log.showInfo(`Registering scene interceptor rule for screenId: ${screenId}, panelId: ${panelId}`);
    if (!rule || screenId <= INVALID_SCREEN_ID || panelId <= INVALID_PANEL_ID) {
      log.showError('Invalid parameters in registerInterceptorRule');
      return;
    }
    if (!this.interceptorRules.has(screenId)) {
      log.showInfo(`registerInterceptorRule: ${screenId} not exists!`);
      this.interceptorRules.set(screenId, new Map());
    }
    let screenRules = this.interceptorRules.get(screenId);
    if (!screenRules?.has(panelId)) {
      log.showInfo(`registerInterceptorRule: screenId: ${screenId}, panelId: ${panelId} not exists.`);
      screenRules.set(panelId, new Array<SceneInterceptorRule>());
    }
    let panelRules = screenRules.get(panelId);
    const index = panelRules.indexOf(rule);
    if (index === -1) {
      log.showInfo(`registerInterceptorRule: screenId: ${screenId}, panelId: ${panelId} success.`);
      panelRules.push(rule);
    } else {
      log.showWarn(`registerInterceptorRule: screenId: ${screenId}, panelId: ${panelId} is exists.`);
    }
  }

  /**
   * 注销窗口启动拦截规则
   * @param rule 拦截规则函数
   * @param screenId
   * @param panelId
   */
  public unregisterInterceptorRule(rule: SceneInterceptorRule, screenId: number, panelId: number): void {
    if (!this.interceptorRules.has(screenId)) {
      log.showWarn(`No interceptor rules found for screenId: ${screenId}`);
      return;
    }
    let screenRules = this.interceptorRules.get(screenId);
    if (!screenRules?.has(panelId)) {
      log.showWarn(`No interceptor rules found for panelId: ${panelId} in screenId: ${screenId}`);
      return;
    }
    let panelRules = screenRules.get(panelId);
    let index = panelRules.indexOf(rule);
    if (index !== -1) {
      panelRules.splice(index, 1);
      log.showInfo(`Successfully unregistered interceptor rule for screenId: ${screenId}, panelId: ${panelId}`);
    }

    // 检查panelRules是否为空，如果为空，移除panelId
    if (panelRules.length === 0) {
      screenRules.delete(panelId);
      log.showInfo(`Removed empty panelId: ${panelId} from screenId: ${screenId}`);
    }
    // 检查screenRules是否为空，如果为空，移除screenId
    if (screenRules.size === 0) {
      this.interceptorRules.delete(screenId);
      log.showInfo(`Removed empty screenId: ${screenId}`);
    }
  }

  /**
   * 清除所有窗口启动拦截规则
   */
  public clearInterceptorRules(): void {
    this.interceptorRules.clear();
    log.showInfo('All scene interceptor rules have been cleared');
  }

  /**
   * 判断是否拦截窗口启动
   * @param sceneInfo
   * @param startFrom
   * @param screenId
   * @param panelId
   * @returns true 表示拦截，false 表示不拦截
   */
  public shouldIntercept(sceneInfo: SCBSceneInfo, startFrom: StartInterceptions, screenId: number, panelId: number): boolean {
    if (!sceneInfo) {
      log.showError('Invalid parameters in shouldIntercept');
      return false;
    }

    if (!this.interceptorRules.has(screenId) || !this.interceptorRules.get(screenId)?.has(panelId)) {
      log.showInfo(`No interceptor rules found for screenId: ${screenId}, panelId: ${panelId}`);
      return false;
    }

    const rules = this.interceptorRules.get(screenId)?.get(panelId);
    if (!rules) {
      log.showInfo(`No interceptor rules found for screenId: ${screenId}, panelId: ${panelId}`);
      return false;
    }

    const shouldIntercept = rules.some(rule => {
      const result = rule(sceneInfo, startFrom);
      if (result) {
        log.showInfo(`[SCBMission] Intercepting start from ${startFrom}, sceneInfo: ${sceneInfo.toJsonString()}`);
      }
      return result;
    });

    return shouldIntercept;
  }

  /**
   * 判断是否需要oobe拦截
   * @param sceneInfo
   * @param isCheckExclusive
   * @returns true 表示拦截，false 表示不拦截
   */
  public isOobeIntercepted(sceneInfo: SCBSceneInfo,
    isCheckExclusive: boolean = true, isNotifyOobe: boolean = false): boolean {
    if (sSCBOobeManager.isOobeActivated() &&
      !sSCBOobeManager.isTrustlistForWms(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName)) {
      log.showWarn('oobe is enabled and uiAbility is not in white list');
      if (isNotifyOobe && this.notifyOobeCallback) { // 只有图标启动会生效
        this.notifyOobeCallback();
      }
      return true;
    }
    if (isCheckExclusive && SCBSceneSessionManager.getInstance().isExclusion(sceneInfo.bundleName, sceneInfo.windowMode)) {
      return true;
    }
    return false;
  }

  /**
   * unregister notifyOobeCallback Callback
   */
  public unregisterNotifyOobeCallback(): void {
    log.showInfo('unregisterNotifyOobeCallback');
    this.notifyOobeCallback = null;
  }

  /**
   * register ExternalScreenInterceptor Callback
   *
   * @param callback
   */
  public registerNotifyOobeCallback(notifyOobeCallback: () => void): void {
    log.showInfo('registerNotifyOobeCallback');
    this.notifyOobeCallback = notifyOobeCallback;
  }
}