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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneSessionManager } from '../session/SCBSceneSessionManager';
import { SCBSceneMissionManager } from '../manager/SCBSceneMissionManager';
import { SCBSceneSession } from '../session/SCBSceneSession';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';

const TAG = 'SCBKioskModeManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const CLOSE_DELAY_TIME = 1000;

export class SCBKioskModeManager {
  private kioskApps: string[] = [];
  private kioskAppPersistentId: number;
  private kioskMode: boolean = false;
  private kioskModeChangeCallbacks: Map<string, Function> = new Map();

  public static getInstance(): SCBKioskModeManager {
    if (!globalThis.SCBKioskModeManagerInstance) {
      globalThis.SCBKioskModeManagerInstance = new SCBKioskModeManager();
    }
    return globalThis.SCBKioskModeManagerInstance;
  }

  /**
   * 初始化
   */
  public init(): void {
    try {
      sceneSessionManager.on('updateKioskAppList', (kioskAppList: string[]) => {
        log.showInfo(`update kiosk app list: ${kioskAppList.length}`);
        this.kioskApps = kioskAppList;
      });
    } catch (err) {
      log.showError('Fail to register update kiosk app list callback');
    }
    try {
      sceneSessionManager.on('kioskModeChange', (isKioskMode: boolean, persistentId: number) => {
        log.showInfo(`kiosk mode change, isKioskMode:${isKioskMode} persistentId:${persistentId}`);
        this.kioskAppPersistentId = persistentId;
        if (isKioskMode) {
          this.enterKioskMode();
        } else {
          this.exitKioskMode();
        }
      });
    } catch (err) {
      log.showError('Fail to register kiosk mode change callback');
    }
  }

  /**
   * 是否在kiosk模式
   * @returns 是否在kiosk模式
   */
  public isKioskMode(): boolean {
    return this.kioskMode;
  }

  /**
   * 判断指定包名是否kiosk白名单应用
   * @param bundleName 包名
   * @returns 是否kiosk白名单应用
   */
  public isKioskApp(bundleName: string): boolean {
    return this.kioskApps.includes(bundleName);
  }

  /**
   * 进入Kiosk模式
   */
  public enterKioskMode(): void {
    if (this.kioskMode) {
      log.showWarn(`device already in kiosk mode`);
      return;
    }
    this.kioskMode = true;
    this.notifyKioskModeChange(this.kioskMode);
    let sceneSession: SCBSceneSession | null = SCBSceneMissionManager.getInstance()
      .findMainSessionGlobalById(this.kioskAppPersistentId);
    let containerSession: SCBSceneContainerSession | null = SCBSceneMissionManager.getInstance()
      .findMainSessionTupleGlobalByInfo(sceneSession?.sceneInfo)?.containerSession;
    if (sceneSession?.isInSplit() || containerSession?.isMidScene) {
      log.showInfo('maximize split or mid scene in kiosk mode');
      SCBSceneSessionManager.getInstance().maximizeSplit(sceneSession.sceneInfo.screenId, this.kioskAppPersistentId);
    } else if (sceneSession?.isInFloat()) {
      log.showInfo('maximize float in kiosk mode');
      if (SCBSceneSessionManager.getInstance().isPcOrPcMode()) {
        SCBSceneSessionManager.getInstance().maximize(sceneSession.sceneInfo.screenId, this.kioskAppPersistentId);
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
      } else {
        SCBSceneSessionManager.getInstance().maximizeFloating(sceneSession.sceneInfo.screenId, this.kioskAppPersistentId);
      }
    }
    setTimeout(() => {
      SCBSceneMissionManager.getInstance().closeSessionWithCondition((scbSceneSession: SCBSceneSession) =>
        scbSceneSession.session.type === sceneSessionManager.SessionType.TYPE_APP &&
        !this.kioskApps.includes(scbSceneSession.sceneInfo.bundleName));
    }, CLOSE_DELAY_TIME);
  }

  /**
   * 退出kiosk模式
   */
  public exitKioskMode(): void {
    if (!this.kioskMode) {
      log.showWarn(`device already exit kiosk mode`);
      return;
    }
    this.kioskMode = false;
    this.notifyKioskModeChange(this.kioskMode);
  }

  /**
   * kiosk主应用拦截侧滑退出事件
   * @param persistentId
   * @returns 是否拦截
   */
  public shouldIgnoreBackPress(persistentId: number): boolean {
    return this.isKioskMode() && persistentId === this.kioskAppPersistentId;
  }

  /**
   * 获取默认callerPersistentId，kiosk模式下侧滑caller为空使用时返回kiosk主应用
   * @returns 默认callerPersistentId
   */
  public getDefaultCallerPersistentId(): number {
    return this.kioskAppPersistentId;
  }

  /**
   * 通知各模块Kiosk模式变化
   */
  public notifyKioskModeChange(isKioskMode: boolean): void {
    this.kioskModeChangeCallbacks.forEach((value: Function, key: string) => {
      value?.(isKioskMode);
    });
  }

  /**
   * 注册监听Kiosk模式状态变化
   *
   * @param sceneType 注册监听的场景
   * @param callback 注册的回调
   */
  public registerKioskModeChangeEvent(sceneType: string, callback: Function): void {
    if (this.kioskModeChangeCallbacks.has(sceneType)) {
      log.showError(`sceneType=${sceneType} alreay exists`);
      return;
    }
    this.kioskModeChangeCallbacks.set(sceneType, callback);
    log.showInfo(`sceneType=${sceneType} registerKioskModeChangeEvent success.`);
  }

  /**
   * 反注册监听Kiosk模式状态变化
   *
   * @param sceneType 注册监听的场景
   */
  public unregisterKioskModeChangeEvent(sceneType: string): void {
    if (!this.kioskModeChangeCallbacks.has(sceneType)) {
      log.showInfo(`unRegister sceneType=${sceneType} error, no such sceneType`);
      return;
    }
    this.kioskModeChangeCallbacks.delete(sceneType);
    log.showInfo(`sceneType=${sceneType} unRegisterKioskModeChangeEvent success`);
  }
}