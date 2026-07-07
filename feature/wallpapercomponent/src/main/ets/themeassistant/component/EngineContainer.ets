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

import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { EngineContainerManager } from './EngineContainerManager';
import { ThemeServiceHelper } from '../ThemeServiceHelper';
import { DualInstanceHandler } from '../handler/DualInstanceHandler';
import { MultiProxyHandler } from '../handler/MultiProxyHandler';
import { ScbState } from '../ThemeConstant';

const TAG: string = 'EngineContainer';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Sub component to declare the UIExtensionComponent which would contain TE's render content
 *
 * @since 2024-07-11
 */
@Component
export struct EngineContainer {
  @Link
  public screenProp: SCBScreenProperty;

  private screenWidth: number = 0;

  private screenHeight: number = 0;

  @State engineWidth: number = this.screenProp.width;

  @State engineHeight: number = this.screenProp.height;

  private screenOrientation: number = 0;

  private instanceHandler: DualInstanceHandler = DualInstanceHandler.getInstance();

  private themePath: string = '';

  private themeSrvHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();

  private initEngineState: number = 0;

  private onDeskTopState: number = 0;

  private isChangeThemeAll: boolean = false;

  private persistentId: number = 0;

  private proxy: UIExtensionProxy | null = null;

  private uiContext: UIContext | undefined = undefined;

  @StorageLink('themeEngineRestartTrigger')
  public themeSwitch: boolean = true;

  public outerScreenFlag: boolean = false;

  public proxyId: string = 'DefaultProxy';

  private isStatic: boolean = true;

  private isUseEngineSize(): boolean {
    return false;
  }

  /**
   * 当壁纸大小和屏幕大小不一致时，需要计算engineSize来初始化
   */
  private initEngineSize(): void {
    // 非superfold设备或扩展屏使用默认大小即可，无需调整
    if (!this.isUseEngineSize()) {
      return;
    }
    if (this.themeSrvHelper.isUseStaticWallpaper()) {
      // superfold设备的主屏使用静态壁纸时，旋转可露黑角，优先保证不拉伸，边长为屏幕实际大小
      this.engineWidth = this.screenProp.width;
      this.engineHeight = this.screenProp.height;
    } else {
      // superfold设备的主屏使用动态壁纸时，旋转不露黑角，需要将壁纸边长放大为window view的对角线长度
      this.engineWidth = Math.ceil(Math.sqrt(this.screenProp.width * this.screenProp.width +
        this.screenProp.height * this.screenProp.height));
      this.engineHeight = this.engineWidth;
    }
    LOG.info(TAG, `initEngineSize engineWidth: ${this.engineWidth}, engineHeight: ${this.engineHeight}`);
  }

  private getScbState(): ScbState {
    let state: ScbState = this.themeSrvHelper.getScbState();
    // 适配应用到新主题后，小折叠产品折叠到外屏拉起锁屏场景
    if (this.proxyId === 'OuterProxy' && state === ScbState.DESKTOP) {
      state = ScbState.LOCKSCREEN
    }
    return state;
  }

  private preEngineStart(): void {
    this.initScreenProp();
    this.themePath = this.outerScreenFlag ? this.themeSrvHelper.getOuterScreenActiveThemePath() :
    this.themeSrvHelper.getActiveThemePath()
    this.isStatic = this.themeSrvHelper.isUseStaticWallpaper();
    this.initEngineState = this.getScbState();
    this.onDeskTopState = AppStorage.get<number>('onDeskTopState') ?? 0;
    this.isChangeThemeAll = AppStorage.get<boolean>('isThemeActivationTargetAll') ?? false;
  }

  private initScreenProp(): void {
    if (!this.screenProp) {
      LOG.warn(TAG, 'Invalid SCBScreenProperty instance may result in unexpected behavior in wallpaper geometry');
      return;
    }
    this.screenWidth = this.screenProp.width ?? 0;
    this.screenHeight = this.screenProp.height ?? 0;
    this.screenOrientation = this.screenProp.rotation ?? 0;
    this.initEngineSize();
  }

  private isActiveProxy(): boolean {
    let isFold: boolean = this.themeSrvHelper.isOuterEngineService();
    return true;
  }

  private onRemoteReady: (proxy: UIExtensionProxy) => void = (proxy: UIExtensionProxy) => {
    if (!proxy) {
      LOG.error(TAG, 'Null proxy was provided, wallpaper will not work properly.');
      return;
    }
    LOG.info(TAG, 'ThemeEngine instance is now ready.');
    if (this.isActiveProxy() && (!EngineContainerManager.getInstance().getProxyHandler() || this.isStatic)) {
      EngineContainerManager.getInstance().onInstanceLoad(proxy);
    }
    this.proxy = proxy;
    MultiProxyHandler.getInstance().registerProxy(this.proxyId, proxy);
    proxy.send({
      'gestureMotionEnable': this.themeSrvHelper.isEnableGestureMotionCallback,
    });
    GlobalContext.getContext()?.eventHub.emit('wallpaperRemoteReady');
  };

  private onReceiveEngineData: (data: object) => void = (data: object) => {
    if (!data) {
      LOG.error(TAG, 'Invalid external data were attempted to be sent.');
      return;
    }

    if (data['updateBaseImageEnd'] !== undefined) {
      ThemeServiceHelper.getInstance().handleBaseImageCallBack();
    }

    // Notify animation finish to corresponding listeners
    if (data['isAnimationFinish'] !== undefined && data['isAnimationFinish'] === true) {
      const taskId: number = data['taskId'] as number ?? -1;
      LOG.info(TAG, `Notifying wallpaper animation finish task Id ${taskId}`);
      ThemeServiceHelper.getInstance().onAnimationFinish(taskId);
    }

    // Notify gesture motion to corresponding listeners
    if (data['gestureMotion'] !== undefined) {
      LOG.debug(TAG, 'Notifying wallpaper gesture motion');
      const clockCollapse: boolean = data['gestureMotion'] as boolean ?? false;
      ThemeServiceHelper.getInstance().onGestureMotionEvent(clockCollapse);
    }

    // Notify theme finish loading to corresponding listeners
    if (data['themeFinishLoading'] !== undefined && data['themeFinishLoading'] === true) {
      LOG.info(TAG, 'Notifying ThemeFinishLoading');
      this.instanceHandler.onEngineReady(this.proxyId);
      if (this.isActiveProxy()) {
        if (this.proxy) {
          EngineContainerManager.getInstance().onInstanceLoad(this.proxy);
        }
        let currentState: ScbState = this.themeSrvHelper.getScbState();
        if (this.initEngineState !== currentState) {
          this.themeSrvHelper.updateScbState(currentState, currentState, undefined, false);
        }
      } else {
        MultiProxyHandler.getInstance().setInactiveProxyState(this.proxyId);
        MultiProxyHandler.getInstance().sendEngineProxyForSleepById(this.proxyId);
      }
    }

    if (data['unlockPosition'] !== undefined) {
      const position: number = data['unlockPosition'] as number ?? 0;
      ScreenLockApi.requestUnlockWithPosition(position,
        {
          success: () => {
            LOG.info(TAG, `unlock success position:${position}}`);
          }
        });
    }

    // Notify theme scene switch finish to corresponding listeners
    if (data['themeSceneSwitchFinish'] !== undefined && data['themeSceneSwitchFinish'] === true) {
      LOG.info(TAG, 'Notifying theme scene switch finish');
      ThemeServiceHelper.getInstance().onThemeSceneSwitchFinishEvent();
    }

    // Get live view list
    if (data['requestLiveViewList'] !== undefined) {
      const liveViewList: string[] = data['liveViewList'] as string[] ?? [];
      ThemeServiceHelper.getInstance().setCutePetLiveViewSet(liveViewList);
      LOG.info(TAG, 'request live view list from theme engine');
    }
  };

  private onTerminated: (info: TerminationInfo) => void = (info: TerminationInfo) => {
    if (!info) {
      LOG.warn(TAG, 'Received termination request but no valid info were given.');
    }
    LOG.warn(TAG, `On ThemeEngine instance terminated, info ${info?.code}`);
    this.initEngineState = this.themeSrvHelper.getScbState();
    this.onDeskTopState = AppStorage.get<number>('onDeskTopState') ?? 0;
    this.instanceHandler.onUiExtError();
  };

  private onUiExtError: (err: BusinessError) => void = (err: BusinessError) => {
    if (!err) {
      LOG.warn(TAG, 'Received extension error but no valid error info were given.');
    }
    LOG.warn(TAG, `On ThemeEngine UIExt error, info ${err?.code}`);
    this.initEngineState = this.themeSrvHelper.getScbState();
    this.onDeskTopState = AppStorage.get<number>('onDeskTopState') ?? 0;
    this.instanceHandler.onUiExtError();
  }

  private setUiFirst(value: boolean): void {
    SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId,
      this.screenProp.screenId)?.setSystemSceneForceUIFirst(value);
    LOG.info(TAG, `On received setUiFirst ${value}, PersistentId: ${this.persistentId},
      ScreenId: ${this.screenProp.screenId}`);
  }

  private screenPropertyChangeCallback: Function =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      LOG.info(TAG, `screenId mismatch detected, updateRect operation skipped. ` +
        `currentScreenId: ${this.screenProp.screenId}, updateScreenId: ${screenProperty.screenId}`)
      return;
    }
    this.initEngineSize();
  };

  public aboutToAppear(): void {
    LOG.info(TAG, `${this.outerScreenFlag ? 'outer screen ' : ''}aboutToAppear`);
    this.uiContext = this.getUIContext();
    this.preEngineStart();
    ThemeServiceHelper.getInstance().setUiFirstCallback(() => {
      this.setUiFirst(false);
    });
    if (this.isUseEngineSize()) {
      SCBScreenSessionManager.getInstance()
        .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId);
    }
  }

  public aboutToDisappear(): void {
    LOG.info(TAG, `${this.outerScreenFlag ? 'outer screen ' : ''}aboutToDisAppear`);
    ThemeServiceHelper.getInstance().setUiFirstCallback(undefined);
    if (this.isUseEngineSize()) {
      SCBScreenSessionManager.getInstance()
        .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId);
    }
  }

  public build(): void {
    UIExtensionComponent({
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'EngineServiceAbility',
      moduleName: 'engineservice',
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'engineReloadFlag': this.themeSwitch,
        'savedTargetState': this.initEngineState,
        'activeThemePath': this.themePath,
        'screenWidth': this.screenWidth,
        'screenHeight': this.screenHeight,
        'screenOrientation': this.screenOrientation,
        'isChangeThemeAll': this.isChangeThemeAll,
        'onDeskTopState': this.onDeskTopState,
      },
    }, {
      dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI,
    })
      .onRemoteReady(this.onRemoteReady)
      .onReceive(this.onReceiveEngineData)
      .onTerminated(this.onTerminated)
      .onError(this.onUiExtError)
      .width(this.isUseEngineSize() ? this.uiContext?.px2vp(this.engineWidth) : '100%')
      .height(this.isUseEngineSize() ? this.uiContext?.px2vp(this.engineHeight) : '100%')
  }
}