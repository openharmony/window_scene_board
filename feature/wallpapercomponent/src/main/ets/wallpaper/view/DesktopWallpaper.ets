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

import { LogDomain, LogHelper} from '@ohos/basicutils';
import { SCBScreenProperty, SCBSceneSessionManager } from '@ohos/windowscene';
import { DeviceHelper, EvtBus, ThemeActivationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { themeWallpaperAniMgr } from '@ohos/themeservice';
import { osAccount } from '@kit.BasicServicesKit';
import { EngineContainerManager } from '../../themeassistant/component/EngineContainerManager';
import { EngineWallpaper } from '../../themeassistant/component/EngineWallpaper';
import { MultiProxyHandler } from '../../themeassistant/handler/MultiProxyHandler';
import { ThemeType } from '../../themeassistant/ThemeConstant';
import { ThemeServiceHelper } from '../../themeassistant/ThemeServiceHelper';
import { dtWallpaperStateMgr } from '../model/DesktopWallpaperModel';
import { WallpaperModel } from '../model/WallpaperModel';
import { DesktopWallpaperState } from '../viewmodel/DesktopWallpaperState';
import { DualInstanceHandler } from '../../themeassistant/handler/DualInstanceHandler';
import { display } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import image from '@ohos.multimedia.image';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'DesktopWallpaper'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const COMPONENT_ID_WALLPAPER = TAG + '_Image_wallpaper';
const COMPONENT_ID_WALLPAPER_SUB = TAG + '_Image_wallpaper_sub';
const INNER_PROXY_ID = 'InnerProxy';
const OUTER_PROXY_ID = 'OuterProxy';
const DEFAULT_ACCOUNT_ID: number = 100;

@Component
export struct DesktopWallpaper {
  @Link screenProp: SCBScreenProperty;
  private persistentId: number = 0;
  @State wallpaperState: DesktopWallpaperState = dtWallpaperStateMgr.getDtWallpaperState(this.screenProp.screenId);
  @State foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  @StorageLink('screenlockFreezeEngine') screenlockFreezeEngine: boolean = false;
  @StorageLink('desktopFreezeEngine') desktopFreezeEngine: boolean = false;
  private isMainScreen = true;
  private themeSrvHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
  private multiProxyHandler: MultiProxyHandler = MultiProxyHandler.getInstance();
  @State isWholeSetTheme: boolean = this.themeSrvHelper.isWholeSetTheme();
  private isActiveSpace: boolean = true;
  private accountId: number = DEFAULT_ACCOUNT_ID;
  private context = getContext(this) as common.UIAbilityContext;
  @State pixelMap: PixelMap | null = null

  async aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    this.themeSrvHelper.setUIContext(this.getUIContext());
    this.isMainScreen = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
    let isUseEngineWallpaper = this.isMainScreen ? ThemeServiceHelper.getInstance().isUseEngineWallpaper() : false;
    dtWallpaperStateMgr.setDesktopWallpaperMode(isUseEngineWallpaper, this.screenProp.screenId);
    if (this.isMainScreen) {
      themeWallpaperAniMgr.registerWallpaperProxy(ThemeServiceHelper.getInstance()
        .getWallpaperProxy());
      WallpaperModel.getInstance().registerWallpaperChange();
    }
    EvtBus.on(ThemeActivationEvent, this.onThemeActivationEvent);
    this.pixelMap = await this.wallpaperState.getDefaultWallpaperPath(this.context, false)
    this.subscribeCrossProcessEvent('ts.event.theme.change')
  }

  //订阅消息
  async subscribeCrossProcessEvent(eventName: string): Promise<void> {
    try {
      // 创建订阅者信息
      const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [eventName],
        priority: 100,
      };
      // 创建订阅者
      let subscriber = await commonEventManager.createSubscriber(subscribeInfo);
      // 订阅事件
      await new Promise<void>(async (resolve, reject) => {
        commonEventManager.subscribe(subscriber, async (error, data) => {
          if (error) {
            log.error(`subscribe failed: ${JSON.stringify(error)}`);
            reject(error);
          } else {
            log.info(`eventanme: ${eventName}`);
            this.pixelMap = await this.wallpaperState.getDefaultWallpaperPath(this.context, false)
            resolve();
          }
        });
      });

      log.info( `subscribe success: ${eventName}`);
    } catch (error) {
      log.error(`error: ${JSON.stringify(error)}`);
    }
  }

  private registerDisplayModeChange(): void {
    try {
      display.on('foldStatusChange', this.foldStatusChangeCallback);
    } catch (error) {
      log.error('registerDisplayModeChange on error', error);
    }
  }

  private unregisterDisplayModeChange(): void {
    try {
      display.off('foldStatusChange', this.foldStatusChangeCallback);
    } catch (error) {
      log.showError(`unregisterDisplayModeChange error ${error.code} ${error.message}`);
    }
  }

  private foldStatusChangeCallback: Callback<display.FoldStatus> = (newFoldStatus: display.FoldStatus): void => {
    log.info(`foldStatusChangeCallback newFoldStatus: ${newFoldStatus}`);
    this.foldStatus = newFoldStatus;
  }

  private initAccountListener(): void {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let uid: number = GlobalContext.getContext().applicationInfo.uid;
      this.accountId = osAccount.getAccountManager().getOsAccountLocalIdForUidSync(uid);
      log.info(TAG, `initAccountListener: currentAccount:${this.accountId}`);
      accountManager.on('switched', this.onUserSwitchedCallback);
    } catch (err) {
      log.error(TAG, `onSwitchedCallback failed: errCode: ${err?.code}, msg: ${err?.message}`);
    }
  }

  private closeAccountListener(): void {
    log.info(TAG, `closeAccountListener: currentAccount:${this.accountId}`);
    try {
      osAccount.getAccountManager().off('switched', this.onUserSwitchedCallback);
    } catch (err) {
      log.error(TAG, `closeAccountListener failed: errCode: ${err?.code}, msg: ${err?.message}`);
    }
  }

  private onUserSwitchedCallback = (eventData: osAccount.OsAccountSwitchEventData): void => {
    if (!eventData) {
      return;
    }
    let fromId: number = eventData.fromAccountId;
    let toId: number = eventData.toAccountId;
    if (this.accountId === fromId && this.accountId !== toId) {
      log.info(TAG, `onAccountSwitched:accountId:${this.accountId} {from:${fromId} to:${toId}} onBackground`);
      this.isActiveSpace = false;
      return;
    }
    if (this.accountId === toId && this.accountId !== fromId) {
      log.info(TAG, `onAccountSwitched:accountId:${this.accountId} {from:${fromId} to:${toId}} onForeground`);
      this.isActiveSpace = true;
      this.proxySwitch();
    }
  }

  private proxySwitch() :void {
    if (this.isWholeSetTheme) {
      log.info(TAG, `skip switch proxy, reason: isWholeSetTheme = ${this.isWholeSetTheme}`);
      MultiProxyHandler.getInstance().engineStatus = 'InnerProxy';
      return;
    }
    if (!this.isActiveSpace) {
      log.info(TAG, `is NOT in active space, will NOT change Visiblity.`);
      return;
    }

    let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
    let innerThemeId: string = themeServiceHelper.getThemeId(themeServiceHelper.getActiveThemePath());
    let outerThemeId: string = themeServiceHelper.getThemeId(themeServiceHelper.getOuterScreenActiveThemePath());
      log.info('not show inner screen wallpaper due last proxy freeze');
      if (this.screenlockFreezeEngine === true || this.desktopFreezeEngine === true) {
        this.multiProxyHandler.syncStateOnSwitchInnerSleep();
      } else {
        log.info('show inner screen wallpaper');
        this.multiProxyHandler.syncStateOnSwitchInner();
      }
  }

  private onThemeActivationEvent = (event: ThemeActivationEvent): void => {

  }

  private getInnerEngineWallpaperVisible() : boolean {
    // 判断内屏主题引擎visibility是否需要刷新，套系化主题单实例场景无需刷新
    return true;
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisapper`);
    if (this.isMainScreen) {
      themeWallpaperAniMgr.unRegisterWallpaperProxy();
      // 组件不可见，释放资源，取消公共事件监听
      ThemeServiceHelper.getInstance().destructor();
      WallpaperModel.getInstance().unRegisterWallpaperChange();
    }
    dtWallpaperStateMgr.removeDtWallpaperState(this.screenProp.screenId);
    MultiProxyHandler.getInstance().unregisterProxy();
    EvtBus.off(ThemeActivationEvent, this.onThemeActivationEvent);
  }

  build() {
    Column() {
      // Image(this.wallpaperState.getDefaultsWallpaperImg())

      if (this.wallpaperState.isShowDefaultsWallpaper() || this.pixelMap !== null) {
        // Image(this.pixelMap === null ? $r('app.media.adaptive_multitask_background') : this.pixelMap)
        Image(this.pixelMap === null ? this.wallpaperState.getDefaultsWallpaperImg() : this.pixelMap)
          .draggable(false)
          .id(COMPONENT_ID_WALLPAPER)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .hoverEffect(HoverEffect.None)
          .interpolation(ImageInterpolation.Low)
      }
      else {
          EngineWallpaper({ screenProp: this.screenProp })
            .id(COMPONENT_ID_WALLPAPER)
            .width('100%')
            .height('100%')
      }
    }
  }
}
