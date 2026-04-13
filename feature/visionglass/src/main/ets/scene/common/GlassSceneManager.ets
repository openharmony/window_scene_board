/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import type { Want } from '@kit.AbilityKit';
import { screen } from '@kit.ArkUI';
import { type BusinessError } from '@kit.BasicServicesKit';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  FocusChangeReason,
  SCBEventId,
  SCBSceneInfo,
  type SCBSceneSession,
  SCBSceneSessionManager
} from '@ohos/windowscene';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassSceneManager');

const DEFAULT_SCREEN_ID = 0;
const MIN_DPI = 80;
const MAX_DPI = 640;
const DEFAULT_DPI = 270;

export interface Rect {
  left?: number;
  top?: number;
  width?: number;
  height?: number;
}

export interface ScenePanelCallback {
  minimizeAllScene: (() => void);
  terminateLastScene: (() => void);
  popSceneSession: ((sceneInfo: SCBSceneInfo) => SCBSceneSession | undefined);
  startScene: ((sceneInfo: SCBSceneInfo) => void);
  getContainerSessionList: (() => SCBSceneSession[]);
  terminateScene: ((persistentId: number) => void);
  getSessionById: ((persistentId: number) => SCBSceneSession | undefined);
  findCurrentActivateScene: (() => number);
  isAliceAppForeground: (() => boolean);
  getActiveWant: (() => Want | undefined);
  getActiveSession: (() => SCBSceneSession | undefined);
}

export enum GlassSystemSceneType {
  UNDEFINED_TYPE,
  SCENE_PANEL,
  GLASS_BANNER,
  GLASS_STATUS_BAR,
  GLASS_CONTROL,
  GLASS_VOLUME,
  GLASS_NOTIFICATION_CENTER,
  GLASS_SCREENSHOT_PREVIEW,
  GLASS_TOAST,
  GLASS_STATUS_BAR_HOVER,
  GLASS_CONTROL_CENTER_SUBPAGE,
}

export class GlassSceneManager {
  private static instance?: GlassSceneManager;
  public scenePanelCallback?: ScenePanelCallback;
  private screenId: number = DEFAULT_SCREEN_ID;
  public isLastCalledHere: boolean = false;
  private screenChangeCallback: Function = () => {
  };

  /*
   * 获取当前窗口管理实例
   *
   * @return GlassSceneManager
   * */
  public static getInstance(): GlassSceneManager {
    if (!GlassSceneManager.instance) {
      GlassSceneManager.instance = new GlassSceneManager();
    }
    return GlassSceneManager.instance;
  }

  /*
   * 销毁窗口管理实例
   *
   * @param screenId
   * */
  public static destroyInstance(screenId: number): void {
    log.info('destroyInstance');
    SCBSceneSessionManager.getInstance().unregisterPopSceneSession(screenId);
    SCBSceneSessionManager.getInstance().unregisterVirtualScreenStartScene(screenId);
    GlassSceneManager.instance?.release();
    GlassSceneManager.instance = undefined;
  }

  /*
   * 处理来电会话回调
   *
   * @param windowId
   * */
  public handleCallingSessionChange(windowId: number): void {
    if (this.getSessionById(windowId) === undefined) {
      if (this.isLastCalledHere && this.screenChangeCallback) {
        this.screenChangeCallback(false);
      }
      this.isLastCalledHere = false;
      return;
    }
    if (this.isLastCalledHere) {
      return;
    }
    this.isLastCalledHere = true;
    if (this.screenChangeCallback) {
      this.screenChangeCallback(true);
    }
  }

  /*
   * 注册来电变更回调
   *
   * @param callback
   * */
  public registerCallingScreenChangeCallback(callback: Function): void {
    this.screenChangeCallback = callback;
  }

  /*
   * 注册应用窗口管理回调集
   *
   * @param scenePanelCallback
   * */
  public registerScenePanelCallback(scenePanelCallback: ScenePanelCallback): void {
    this.scenePanelCallback = scenePanelCallback;
  }

  /*
   * 查找当前活跃会话
   *
   * @param number
   * */
  public findCurrentActivateScene(): number | undefined {
    return this.scenePanelCallback?.findCurrentActivateScene();
  }

  /*
   * ִ执行back手势操作
   * */
  public processBackEvent(): void {
    let persistentId = this.findCurrentActivateScene();
    if (persistentId) {
      log.info(`processBackEvent id: ${persistentId}`);
      sceneSessionManager.requestAllAppSessionUnfocus();
      sceneSessionManager.requestFocusStatus(persistentId, true, true);
      sceneSessionManager.processBackEvent();
    } else {
      log.warn(`processBackEvent is not find`);
    }
  }

  /*
   * ִ执行窗口最小化操作
   * */
  public minimizeAllScene(): void {
    this.scenePanelCallback?.minimizeAllScene();
  }

  /*
   * 注销最新会话
   * */
  public terminateLastScene(): void {
    this.scenePanelCallback?.terminateLastScene();
  }

  /*
   * 检查alice是否在前台
   *
   * @return  boolean
   * */
  public isAliceAppForeground(): boolean {
    return !!this.scenePanelCallback?.isAliceAppForeground();
  }

  /*
   * 获取当前活跃会话want
   *
   * @return Want | undefined
   * */
  public getActiveWant(): Want | undefined {
    return this.scenePanelCallback?.getActiveWant();
  }

  /*
   * 获取活跃会话
   *
   * @return SCBSceneSession | undefined
   * */
  public getActiveSession(): SCBSceneSession | undefined {
    return this.scenePanelCallback?.getActiveSession();
  }

  /*
   * 从其他路径打开应用窗口
   *
   * @param sceneInfo 窗口信息
   * */
  public startSceneFromOther = (sceneInfo: SCBSceneInfo): void => {
    this.startScene(sceneInfo);
  };

  /*
   * 从图标打开应用窗口
   *
   * @param want
   * */
  public startSceneFromIcon(want: Want): void {
    log.info(`startSceneFromIcon by want: ${want.bundleName}`);
    let sceneInfo: SCBSceneInfo =
      new SCBSceneInfo(want.bundleName ?? '', want.moduleName ?? '', want.abilityName ?? '');
    sceneInfo.screenId = this.screenId;
    sceneInfo.want = want;
    this.startScene(sceneInfo);
  }

  /*
   * 会话退出回调
   *
   * @param persistentId
   * */
  public onTerminateScene = (persistentId: number): void => {
    this.scenePanelCallback?.terminateScene(persistentId);
  };

  /*
   * 窗口最小化回调
   * */
  public onMinimizeScene = (): void => {
    this.minimizeAllScene();
  };

  /*
   * 通过persistentId获取对应会话
   *
   * @param persistentId
   * @return SCBSceneSession | undefined
   * */
  public getSessionById = (persistentId: number): SCBSceneSession | undefined => {
    return this.scenePanelCallback?.getSessionById(persistentId);
  };

  /*
   * 删除并返回应用窗口管理最后一个会话
   *
   * @param sceneInfo
   * @return SCBSceneSession | undefined
   * */
  public popSceneSession = (sceneInfo: SCBSceneInfo): SCBSceneSession | undefined => {
    const sceneSession = this.scenePanelCallback?.popSceneSession(sceneInfo);
    return sceneSession;
  };

  /*
   * 窗口获焦
   *
   * @param persistentId
   * @param byForeground
   * @param reason
   * */
  public requestFocus(persistentId: number, byForeground: boolean = true,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    sceneSessionManager.requestFocusStatus(persistentId, true, byForeground, reason);
  }

  /*
   * 窗口失焦
   *
   * @param persistentId
   * @param byForeground
   * @param reason
   * */
  public requestUnFocus(persistentId: number, byForeground: boolean = false,
    reason: FocusChangeReason = FocusChangeReason.DEFAULT): void {
    sceneSessionManager.requestFocusStatus(persistentId, false, byForeground, reason);
  }

  /*
   * 更新屏幕id
   *
   * @param screenId
   * */
  public updateScreenId(screenId: number): void {
    this.screenId = screenId;
    this.setDpi(this.screenId, DEFAULT_DPI);
    this.registerCallback();
  }

  /*
   * 更新会话设备id
   *
   * @param persistentId
   * @param screenId
   * */
  public updateSessionDisplayId(persistentId: number, screenId: number): void {
    log.info(`[SCBMain]updateSessionDisplayId, persistentId:${persistentId}`);
    try {
      sceneSessionManager.updateSessionDisplayId(persistentId, screenId);
    } catch (err) {
      const error = err as BusinessError;
      log.error(`[SCBMain]updateSessionDisplayId failed, with reason code: ${error.code},message:${error.message}`);
    }
  }

  /*
   * 获取当前屏幕id
   *
   * @return number
   * */
  public getScreenId(): number {
    return this.screenId;
  }

  private setDpi(screenId: number, newDensityDpi: number): void {
    log.info('setDpi');
    if (newDensityDpi < MIN_DPI || newDensityDpi > MAX_DPI) {
      log.error(`newDensityDpi = ${newDensityDpi}, it is out of [80,640]`);
      return;
    }
    screen.getAllScreens((err: BusinessError, data: screen.Screen[]) => {
      const errCode: number = err.code;
      if (errCode) {
        log.error('Failed to get all screens.');
        return;
      }
      log.info('Succeeded in getting all screens.');
      data.forEach((screen) => {
        this.setDpiInner(screen, screenId, newDensityDpi);
      });
    });
  }

  private setDpiInner(screen: screen.Screen, screenId: number, newDensityDpi: number): void {
    if (screen.id === screenId) {
      log.info(`set screen: ${screen.id}, newDensityDpi = ${newDensityDpi}`);
      screen.setDensityDpi(newDensityDpi, (err: BusinessError) => {
        const errCode: number = err.code;
        if (errCode) {
          log.error('Failed to set the pixel density of the screen.');
          return;
        }
        log.info('Succeeded in setting dpi.');
      });
    }
  }

  private startScene(sceneInfo: SCBSceneInfo): void {
    this.scenePanelCallback?.startScene(sceneInfo);
  }

  private registerCallback = (): void => {
    SCBSceneSessionManager.getInstance().registerPopSceneSession(this.popSceneSession, this.screenId);
    SCBSceneSessionManager.getInstance().registerVirtualScreenStartScene(this.startSceneFromOther, this.screenId);
    SCBSceneSessionManager.getInstance().on(SCBEventId.MINIMIZE_SCENE, this.screenId, this.onMinimizeScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.TERMINATE_SCENE, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.CLOSE_SCENE, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_EXCEPTION, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().registerGetVirtualScreenSceneSessionFunc(this.getSessionById, this.screenId);
  };

  private unregisterCallback(): void {
    SCBSceneSessionManager.getInstance().unregisterPopSceneSession(this.screenId);
    SCBSceneSessionManager.getInstance().unregisterVirtualScreenStartScene(this.screenId);
    SCBSceneSessionManager.getInstance().off(SCBEventId.MINIMIZE_SCENE, this.screenId, this.onMinimizeScene);
    SCBSceneSessionManager.getInstance().off(SCBEventId.TERMINATE_SCENE, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().off(SCBEventId.CLOSE_SCENE, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().off(SCBEventId.SESSION_EXCEPTION, this.screenId, this.onTerminateScene);
    SCBSceneSessionManager.getInstance().unregisterGetVirtualScreenSceneSessionFunc(this.screenId);
  }

  private release(): void {
    this.scenePanelCallback?.getContainerSessionList().forEach(
      (containerSession: SCBSceneSession) => {
        containerSession.requestSessionDestruction(true);
      });
    this.scenePanelCallback = undefined;
    this.unregisterCallback();
    if (this.isLastCalledHere && this.screenChangeCallback) {
      this.screenChangeCallback(false);
    }
    this.isLastCalledHere = false;
  }
}