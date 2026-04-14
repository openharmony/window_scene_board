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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GestureEnableCaller, scbGestureManager, SCBScreenProperty, SCBScreenSession } from '@ohos/windowscene';
import { GlassToast } from './toast/Index';
import { GlassScenePanel } from './scene/app/GlassScenePanel';
import { GlassSysSceneSession } from './scene/system/GlassSysSceneSession';
import { GlassSystemScene } from './scene/system/GlassSystemScene';
import { SceneZOrderManager } from './common/manager/SceneZOrderManager';
import { GlassSceneManager } from './scene/common/GlassSceneManager';
import { GlassSystemSceneManager, GlassSystemSceneType } from './scene/common/GlassSystemSceneManager'
import { ServiceCallbackDispatcher } from './IdlVisionGlassExtService/callback/ServiceCallbackDispatcher';
import { GlassVolumePanel, GlassVolumePanelManager } from './volume/Index';
import { GlassStatusbar, GlassStatusbarHover } from './statusbar/Index';
import { GlassBannerPanel } from './bannerpanel/Index';
import { ControlCenterMainPage, ScreenShotPreview } from './controlcenter/Index';
import { GlassNotificationCenter } from './notificationcenter/Index';
import { GlassLayoutManager } from './common/manager/GlassLayoutManager';
import { GlassStatusManager } from './common/manager/GlassStatusManager';
import { VisionGlassResourceManager } from './IdlVisionGlassExtService/VisionGlassResourceManager';
import { LauncherScene } from './launcher/LauncherScene';
import ScreenShotManager from './controlcenter/manager/ScreenshotManager';
import { getStatusBarTransition } from './statusbar/view/GlassStatusBarStyle';
import { GlassInputManager } from './common/manager/GlassInputManager';
import { ControlCenterSubPageWindow } from './controlcenter/view/ControlCenterSubPageWindow';
import { GlassAppManager } from './common/manager/GlassAppManager';
import { GlassNtfManager } from './bannerpanel/manager/GlassNtfManager';
import GlassPhoneCapsule from './statusbar/models/PhoneCapsule';
import { getBannerTransition } from './bannerpanel/common/GlassNtfConstant';
import { GlassBannerPanelManager } from './bannerpanel/manager/GlassBanerPanelManager';
import { GlassNtfActionManager } from './bannerpanel/manager/GlassNtfActionManager';
import { GlassAppWhiteListManager } from './common/manager/GlassAppWhiteListManager';
import { GlassToastManager } from './toast/manager/GlassToastManager';
import { GlassNtfEventManager } from './bannerpanel/manager/GlassNtfEventManager';
import { ControlCenterWindowManager } from './controlcenter/manager/ControlCenterWindowManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassScreen');
const DEFAULT_SCREEN_ID = 0;

@Component
export struct GlassScreen {
  @ObjectLink screenSession: SCBScreenSession;
  @State @Watch('onScreenPropertyChange') screenProperty: SCBScreenProperty = new SCBScreenProperty();
  @Provide screenId: number = DEFAULT_SCREEN_ID;

  private initScreenProperty(): void {
    this.screenProperty.left = this.screenSession.physicalBounds.left;
    this.screenProperty.top = this.screenSession.physicalBounds.top;
    this.screenProperty.width = this.screenSession.physicalBounds.width;
    this.screenProperty.height = this.screenSession.physicalBounds.height;
    log.info(`initScreenProperty vp2px(1) = ${vp2px(1)}; width: ${this.screenProperty.width}; height: ${this.screenProperty.height};`);
  }

  onScreenPropertyChange(): void {
    log.info(`initScreenProperty vp2px(1) = ${vp2px(1)}; width: ${this.screenProperty.width}; height: ${this.screenProperty.height};`);
  }

  aboutToAppear() {
    log.info(`aboutToAppear`);
    this.screenId = this.screenSession.session.screenId;
    VisionGlassResourceManager.getInstance().init();
    new ServiceCallbackDispatcher();
    GlassSceneManager.getInstance().updateScreenId(this.screenId);
    this.initScreenProperty();
    GlassLayoutManager.getInstance().onScreenAttrChange(this.screenProperty.width, this.screenProperty.height);
    GlassStatusManager.getInstance().init();
    GlassAppManager.getInstance().registerAppStatusListener();
    GlassInputManager.registerInputFocusCallback();
    GlassPhoneCapsule.getInstance().init();
    GlassNtfManager.getInstance().init();
  }

  private getPx(value: number): string {
    return value + 'px';
  }

  aboutToDisappear(): void {
    log.info(`aboutToDisappear`);
    GlassVolumePanelManager.destroyInstance();
    GlassSceneManager.destroyInstance(this.screenId);
    VisionGlassResourceManager.release();
    GlassStatusManager.getInstance().release();
    GlassLayoutManager.destroy();
    ScreenShotManager.destroy();
    scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.VISION_GLASS, true, true);
    GlassAppManager.getInstance().unRegisterAppStatusListener();
    GlassInputManager.unRegisterInputFocusCallback();
    GlassPhoneCapsule.getInstance().release();
    GlassBannerPanelManager.destroyInstance();
    GlassStatusManager.destroyInstance();
    GlassNtfManager.destroyInstance();
    GlassNtfActionManager.detroyInstance();
    GlassAppWhiteListManager.destroyInstance();
    GlassToastManager.destroyInstance();
    GlassNtfEventManager.destroyInstance();
    ControlCenterWindowManager.destroyInstance();
    GlassSystemSceneManager.destroyInstance();
  }

  @Builder
  GlassVolumePanelBuilder() {
    GlassVolumePanel()
  }

  @Builder
  GlassToastBuilder() {
    GlassToast()
  }

  @Builder
  GlassStatusBarHover() {
    GlassStatusbarHover()
  }

  @Builder
  GlassBannerPanelBuilder() {
    GlassBannerPanel()
  }

  @Builder
  GlassScreenShotPreviewBuilder() {
    ScreenShotPreview()
  }

  @Builder
  GlassStatusbarBuilder() {
    GlassStatusbar()
  }

  @Builder
  GlassNotificationCenterBuilder() {
    GlassNotificationCenter()
  }

  @Builder
  GlassControlCenterBuilder() {
    ControlCenterMainPage();
  }

  @Builder
  GlassControlCenterSubWindow() {
    ControlCenterSubPageWindow();
  }

  build() {
    Screen(this.screenSession.session.screenId) {
      LauncherScene({
        screenId: this.screenId
      })

      GlassScenePanel({
        screenProperty: $screenProperty,
      });

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          sceneName: 'GlassStatusBar',
        }, this.screenId),
        contextBuilder: this.GlassStatusbarBuilder,
        sceneZIndex: SceneZOrderManager.STATUS_BAR,
        sceneType: GlassSystemSceneType.GLASS_STATUS_BAR,
        transitionCallBack: getStatusBarTransition,
        getFocusable: false
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          sceneName: 'GlassVolumePanel',
        }, this.screenId),
        contextBuilder: this.GlassVolumePanelBuilder,
        sceneZIndex: SceneZOrderManager.VOLUME_PANEL,
        sceneType: GlassSystemSceneType.GLASS_VOLUME,
        getFocusable: false
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_PANEL,
          sceneName: 'GlassScreenShotPreview'
        }, this.screenId),
        contextBuilder: this.GlassScreenShotPreviewBuilder,
        sceneZIndex: SceneZOrderManager.GLASS_SCREENSHOT_PREVIEW,
        sceneType: GlassSystemSceneType.GLASS_SCREENSHOT_PREVIEW,
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_PANEL,
          sceneName: 'GlassBannerPanel'
        }, this.screenId),
        contextBuilder: this.GlassBannerPanelBuilder,
        sceneZIndex: SceneZOrderManager.BANNER,
        sceneType: GlassSystemSceneType.GLASS_BANNER,
        transitionCallBack: getBannerTransition
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_PANEL,
          sceneName: 'GlassStatusBarHover'
        }, this.screenId),
        contextBuilder: this.GlassStatusBarHover,
        sceneZIndex: SceneZOrderManager.STATUS_BAR_HOVER,
        sceneType: GlassSystemSceneType.GLASS_STATUS_BAR_HOVER,
        getFocusable: false
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          sceneName: 'GlassControlCenter',
        }, this.screenId),
        contextBuilder: this.GlassControlCenterBuilder,
        sceneZIndex: SceneZOrderManager.CONTROL_CENTER,
        sceneType: GlassSystemSceneType.GLASS_CONTROL
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_LAUNCHER_DOCK,
          sceneName: 'GlassNotificationCenter',
        }, this.screenId),
        contextBuilder: this.GlassNotificationCenterBuilder,
        sceneZIndex: SceneZOrderManager.NOTIFICATION_CENTER,
        sceneType: GlassSystemSceneType.GLASS_NOTIFICATION_CENTER
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_PANEL,
          sceneName: 'GlassControlCenterSubWindow',
        }, this.screenId),
        contextBuilder: this.GlassControlCenterSubWindow,
        sceneZIndex: SceneZOrderManager.CONTROL_CENTER_SUB_WINDOW,
        sceneType: GlassSystemSceneType.GLASS_CONTROL_CENTER_SUBPAGE
      })

      GlassSystemScene({
        sysSceneSession: new GlassSysSceneSession({
          systemType: sceneSessionManager.SessionType.TYPE_PANEL,
          sceneName: 'GlassToast'
        }, this.screenId),
        contextBuilder: this.GlassToastBuilder,
        sceneZIndex: SceneZOrderManager.TOAST,
        sceneType: GlassSystemSceneType.GLASS_TOAST,
        getFocusable: false
      })
    }
    .position({ x: this.getPx(this.screenProperty.left), y: this.getPx(this.screenProperty.top) })
    .width(this.getPx(this.screenProperty.width))
    .height(this.getPx(this.screenProperty.height));
  }
}