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

import lazy base from '@ohos.base';
import lazy commonEventManager from '@ohos.commonEventManager';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { ThemeConstant, DesktopModeEnum } from '../utils/ThemeConstant';
import lazy { EngineAnimationHandler } from './EngineAnimationHandler';
import { WallpaperViewController } from '../pages/WallpaperViewController';
import { ScbState } from '../pages/WallpaperConstants';
import { Log } from '../utils/Log';
import { DeviceUtil } from '../utils/DeviceUtil';
import { GlobalContext } from '../utils/GlobalContext';
import { PathReloadStrategy } from '../utils/PathReloadStrategy';
import { Constants } from '../utils/Constants';

const TAG: string = 'EngineProxy';

/**
 * EngineProxy is responsible for processing IPC request from SCB and map and define specific behaviours
 * On receiving IPC, it may notify engine wallpaper to alter params in certain scenarios.
 *
 * @since 2024-01-06
 */
export class EngineProxy {
  private static instance: EngineProxy;

  private session?: UIExtensionContentSession;

  private ipcFunctionMap: Map<string, (message: object) => Promise<void>> = new Map();

  private wallpaperViewController: WallpaperViewController = WallpaperViewController.getInstance();

  private animationHandler: EngineAnimationHandler = new EngineAnimationHandler();

  private isPandoraTheme: boolean = false;

  private currentSceneState: number = -1;

  private preSceneState: number = -1;

  private scbState: ScbState = ScbState.UNKNOWN;

  private messageTime: number | undefined = 0;

  // 桌面应用状态 true: 桌面打开了应用，false: 桌面无应用
  private isAppOpenedOnDesktop: boolean = false;

  private onScbStateChange: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      Log.info(TAG, `New SCB state: ${message['scbState']}`);
      this.scbState = message['scbState'] as ScbState;
      if (message['scbState'] === 0) {
        this.onAnimationFinish();
      }
      AppStorage.setOrCreate<number>(ThemeConstant.KEY_ENGINE_STATE_SCB, message['scbState']);
      const isSafeMode: boolean = message['isSafeMode'] ?? false;
      const needSetSafeMode: boolean = isSafeMode && this.scbState === ScbState.DESKTOP &&
        message['srcState'] !== undefined && (message['srcState'] as ScbState) === ScbState.LOCKSCREEN;
      AppStorage.setOrCreate<boolean>('isSafeMode', needSetSafeMode);
      Log.info(TAG, `scbStateChange need set isSafeMode: ${isSafeMode}`);
      this.wallpaperViewController.onScbUpdate(this.scbState);
    });

  private updateDynamicAnimation: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      // Reset Task id each time, prevent last used id being floated in the context
      GlobalContext.getContext().setObject('animationTaskId', -1);
      const taskId: number = message['taskId'] ?? -1;
      const sender: string = message['sender'] ?? '';
      this.animationHandler.onTransitionAnimation(message['srcState'], message['dstState'], message['isPlayAnimation'],
        taskId, sender);
    });

  private updateBaseScale: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      if (message['baseScale'] === 0) {
        Log.warn(TAG, 'Refuse to adapt with base scale 0');
        return;
      }
      AppStorage.setOrCreate<number>(ThemeConstant.KEY_ENGINE_BASE_SCALE, message['baseScale']);
    });

  private updateRootPath: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      if (!message['rootPath']) {
        Log.warn(TAG, 'rootPath is invalid');
        return;
      }
      PathReloadStrategy.getInstance().updateRootPath(message['rootPath'] as string);
    });

  private updateOpacityCoefficient: () => Promise<void> =
    () => new Promise<void>(async () => {
      this.wallpaperViewController.parseDimKs();
    });

  private onDeskTopState: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      let onDeskTopState: number = message['onDeskTopState'] as number;
      Log.info(TAG, `onDeskTopState ${onDeskTopState}`);
      AppStorage.setOrCreate<number>('onDeskTopState', onDeskTopState);
    });

  private handleAodOffsetUpdate: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      if (!message['offsetX'] || !message['offsetY'] ||
        Number.isNaN(message['offsetX'] as number) || Number.isNaN(message['offsetY'] as number)) {
        Log.warn(TAG, 'aod message is invalid');
        GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_X', 0);
        GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_Y', 0);
        return;
      }
      GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_X', message['offsetX'] as number);
      GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_Y', message['offsetY'] as number);
    });

  private handleAnimationEvent: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      let animationType: number = message['animationType'] as number;
      Log.info(TAG, `handleAnimationEvent ${animationType}`);

      // 拦截不支持的动画类型
      if (!Constants.animationCanPlay(animationType)) {
        Log.warn(TAG, `Unsupported animation type ${animationType}.`)
        return;
      }
      AppStorage.setOrCreate<number>('animationState', animationType);
    });

  private updateDesktopAppState: (message: object) => Promise<void> =
    (message: object) => new Promise<void>(async () => {
      if (message['isAppOpenedOnDesktop'] === undefined) {
        Log.warn(TAG, 'updateDesktopAppState message is invalid');
        return;
      }
      const isAppOpenedOnDesktop: boolean = message['isAppOpenedOnDesktop'] as boolean;
      this.wallpaperViewController.setAppDesktopState(isAppOpenedOnDesktop);
      Log.info(TAG, `updateDesktopAppState ${isAppOpenedOnDesktop}`);
    });

  private dataReceiveCallback(): (data: Object) => void {
    return (data) => {
      Object.keys(data).forEach(key => {
        if (this.ipcFunctionMap.has(key)) {
          Log.info(TAG, `Receiving IPC call with matched key ${key}`);
          this.ipcFunctionMap.get(key)?.(data);
          return;
        }
      });
    }
  };

  private constructor() {
    this.initIpcMap();
  }

  public static getInstance(): EngineProxy {
    if (!EngineProxy.instance) {
      EngineProxy.instance = new EngineProxy();
    }
    return EngineProxy.instance;
  }

  /**
   * Set UIExtensionContentSession instance for setting data receive callback.
   *
   * @param session UIExtensionContentSession instance of ThemeEngine
   */
  public setUiExtSession(session: UIExtensionContentSession): void {
    this.session = session;
    this.session?.setReceiveDataCallback(this.dataReceiveCallback());
    this.wallpaperViewController.setUiExtSession(this.session as UIExtensionContentSession);
  }

  /**
   * Set whether current theme is pandora theme
   *
   * @param isPandoraTheme current theme is pandora theme
   */
  public setPandoraThemeState(isPandoraTheme: boolean): void {
    Log.info(TAG, `current theme is Pandora Theme: ${isPandoraTheme}`);
    this.isPandoraTheme = isPandoraTheme
  }

  private initIpcMap(): void {
    this.ipcFunctionMap.set('dynamicAnimation', this.updateDynamicAnimation);
    this.ipcFunctionMap.set('scbStateChange', this.onScbStateChange);
    this.ipcFunctionMap.set('baseScaleChange', this.updateBaseScale);
    this.ipcFunctionMap.set('animationType', this.handleAnimationEvent);
    this.ipcFunctionMap.set('rootPath', this.updateRootPath);
    this.ipcFunctionMap.set('aodStateChange', this.updateOpacityCoefficient);
    this.ipcFunctionMap.set('aodOffsetUpdate', this.handleAodOffsetUpdate);
    this.ipcFunctionMap.set('onDeskTopState', this.onDeskTopState);
    this.ipcFunctionMap.set('updateDesktopAppState', this.updateDesktopAppState);
  }

  /**
   * Send a broadcast for subscribers when theme has finished loading.
   */
  public publishThemeLoaded(): void {
    try {
      commonEventManager.publish('ThemeFinishLoading', this.onPublish);
    } catch (err) {
      Log.error(TAG, `Error on publishing ThemeFinishLoading event, ${err.code} - ${err.message}`);
    }
  }

  /**
   * 设置scb状态
   *
   * @param scbState scb状态
   */
  public setScbState(scbState: ScbState): void {
    this.scbState = scbState;
    AppStorage.setOrCreate<number>(ThemeConstant.KEY_ENGINE_STATE_SCB, this.scbState);
    Log.info(TAG, `scb init state: ${this.scbState}`);
  }

  /**
   * 获取当前窗口状态
   */
  public getSceneState(): number {
    return this.currentSceneState;
  }

  private onPublish(err: base.BusinessError): void {
    if (err) {
      Log.error(TAG, `publishThemeLoaded failed, code is ${err.code}, message is ${err.message}`);
      return;
    }
    Log.info(TAG, 'Succeeded publish event:ThemeFinishLoading');
  }

  private onAnimationFinish(): void {
    Log.info(TAG, 'Notifying AOD to start.');
    try {
      this.session?.sendData({ 'isAnimationFinish': true });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying animation finish, ${err.code} - ${err.message}`);
    }
  }
}
