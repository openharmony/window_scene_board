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
import { DomainName, LogDomain, LogHelper, SingletonHelper, TraceUtil, } from '@ohos/basicutils';
import { EventManager, EvtBus, GlobalContext, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBSystemBarProperty, SCBSceneSessionManager } from '@ohos/windowscene'
import sceneSessionManager from '@ohos.sceneSessionManager';
import display from '@ohos.display';
import {
  bannerMgr,
  BannerPanelType,
  SceneSessionAdapter,
  StatusBarShowHideChangeEvent,
  StatusBarLayoutFinishedEvent,
  WindowAdapter,
  ViewManagerAdapter,
  NotifyStatusBarShowHideEvent,
  StatusBarType
} from '@ohos/systemuicommon';
import { StatusBarStatus } from './StatusBarStatus'
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { StatusBarTint } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import { StatusBarManager } from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { ShowHideStatusBarScene } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { ThemeWallpaperAniMgrAdapter } from '../adapter/ThemeWallpaperAniMgrAdapter';
import { DynamicWallPaperState } from '@ohos/themeservice/src/main/ets/service/themeservice/ThemeWallpaperAnimationManager';
import { EnvVm } from '@ohos/systemuicommon/newIndex';
import { StatusBarColorData } from '@ohos/statusbarcomponent/src/main/ets/viewmodel/StatusBarColorData';

const TAG = 'SCBStatusBarVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const STATUS_BAR_SHOW_ANI = 'StatusBarShowAni';

const STATUS_BAR_HIDE_ANI = 'StatusBarHideAni';

const STATUS_BAR_OPACITY_TO_ONE_ANI = 'StatusBarOpacity2OneAni';

const STATUS_BAR_FREEZE_THEME_ENGINE = 'StatusBarFreezeThemeEngine';

/**
 * 状态栏背景vm
 */
export class SCBStatusBarVM {
  private statusBarStatus: StatusBarStatus = StatusBarStatus.instance;
  /**
   * 状态栏透明度是否设置为1了
   */
  private isSetOpacityOne: boolean = false;
  /**
   * 在状态栏隐藏有动效时，是否执行状态栏隐藏的方法
   */
  private isTerminateHide: boolean = true;
  private statusBarShowHideChangeEvent: StatusBarShowHideChangeEvent = StatusBarShowHideChangeEvent.create(true);
  private eventMgr: EventManager = EvtBus.createEventManager();
  private showStatusbarByOpacityTimer: number = 0;
  private isThemeEngineFreezed: boolean = false;

  public init() {
    this.eventMgr.produceOn(StatusBarShowHideChangeEvent,
      (): StatusBarShowHideChangeEvent => this.statusBarShowHideChangeEvent);
    this.eventMgr.on(StatusBarLayoutFinishedEvent, this.onStatusBarLayoutFinishedEvent);
    this.eventMgr.on(NotifyStatusBarShowHideEvent, this.onNotifyStatusBarShowHideEvent);
  }

  public unInit() {
    this.eventMgr.offAll();
  }

  private onStatusBarLayoutFinishedEvent = (event: StatusBarLayoutFinishedEvent): void => {
    if (event?.isFinished) {
      if (this.showStatusbarByOpacityTimer) {
        this.clearShowStatusbarByOpacityTimer();
        this.onIsBarShowByOpacity(true);
      }
    }
  }

  private onNotifyStatusBarShowHideEvent = (event: NotifyStatusBarShowHideEvent): void =>{
    this.onIsBarShow(event.flag, event.enableAnimation);
  }

  public getStatusBarStatus(): StatusBarStatus {
    return this.statusBarStatus;
  }

  public animateStatusBarOpacity(enableAnimation: boolean) {
    this.isTerminateHide = true;
    if (this.statusBarStatus.getStatusBarOpacity() === 1) {
      return;
    }

    this.isSetOpacityOne = true;
    TraceUtil.startTrace(DomainName.SYS_UI, STATUS_BAR_OPACITY_TO_ONE_ANI);
    if (enableAnimation) {
      animateTo({
        duration: StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0,
        onFinish: () => {
          TraceUtil.endTrace(DomainName.SYS_UI, STATUS_BAR_OPACITY_TO_ONE_ANI);
        }
      }, () => {
        this.statusBarStatus.setStatusBarOpacity(1);
      })
    } else {
      animateTo({
        duration: 0,
        onFinish: () => {
          TraceUtil.endTrace(DomainName.SYS_UI, STATUS_BAR_OPACITY_TO_ONE_ANI);
        }
      }, () => {
        this.statusBarStatus.setStatusBarOpacity(1);
      })
    }
    this.statusBarShowHideChangeEvent.isShow = true;
    EvtBus.post(StatusBarShowHideChangeEvent, this.statusBarShowHideChangeEvent);
  }

  /**
   * 状态栏显示、隐藏是否加动效
   * @param flag
   */
  public async onIsBarShow(flag: boolean, enableAnimation: boolean, isExitRecentTask: boolean = false): Promise<void> {
    this.isTerminateHide = true;
    log.showInfo(`isEnable changed: ${flag} --- enableAnimation changed: ${enableAnimation}, isExitRecentTask: ${isExitRecentTask}`);
    // flag为true时，状态栏显示，flag为false时，状态栏隐藏
    if (flag) {
      await WindowAdapter.showView(ViewType.STATUS_BAR);
      // enableAnimation为true时，有动效，enableAnimation为false时，无动效
      if (enableAnimation || isExitRecentTask) {
        this.statusBarStatus.setStatusBarOpacity(0);
        TraceUtil.startTrace(DomainName.SYS_UI, STATUS_BAR_SHOW_ANI);
        animateTo({
          duration: StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0,
          onFinish: () => {
            TraceUtil.endTrace(DomainName.SYS_UI, STATUS_BAR_SHOW_ANI);
          }
        }, () => {
          this.statusBarStatus.setStatusBarOpacity(1);
        })
      }
    } else if (!flag && enableAnimation) {
      this.isTerminateHide = false;
      this.isSetOpacityOne = false;
      TraceUtil.startTrace(DomainName.SYS_UI, STATUS_BAR_HIDE_ANI);
      animateTo({
        duration: StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0,
        onFinish: () => {
          TraceUtil.endTrace(DomainName.SYS_UI, STATUS_BAR_HIDE_ANI);
          this.onFinishHideStatusBar();
        },
      }, () => {
        this.statusBarStatus.setStatusBarOpacity(0);
      })
    } else if (!flag && !enableAnimation) {
      await WindowAdapter.hideView(ViewType.STATUS_BAR);
    }
    this.statusBarShowHideChangeEvent.isShow = flag;
    EvtBus.post(StatusBarShowHideChangeEvent, this.statusBarShowHideChangeEvent);
  }

  public onIsBarShowByOpacity(isShow: boolean, scene?: ShowHideStatusBarScene): void {
    log.showInfo(`change statusbar opacity, isShow is ${isShow}, scene is ${scene}`);
    if (scene === ShowHideStatusBarScene.LANDSCAPE_EXIT_APP && isShow) {
      this.showStatusbarByOpacityTimer = setTimeout(() => {
        WindowAdapter.updateOpacity(ViewType.STATUS_BAR, 1.0);
        this.clearShowStatusbarByOpacityTimer();
      }, 60);
      return;
    }
    WindowAdapter.updateOpacity(ViewType.STATUS_BAR, isShow ? 1.0 : 0.0);
  }

  private clearShowStatusbarByOpacityTimer(): void {
    clearTimeout(this.showStatusbarByOpacityTimer);
    this.showStatusbarByOpacityTimer = 0;
  }

  private async onFinishHideStatusBar() {
    if (!this.isTerminateHide && !viewMgrPolicy.isViewShowing(ViewType.DROPDOWN) &&
      !bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      WindowAdapter.hideView(ViewType.STATUS_BAR);
      // 通知statusBar隐藏事件
      GlobalContext.getContext()?.eventHub.emit(CommonConstants.EVENTHUB_STATUS_BAR_HIDE_ANIMATION_FINISH);
    }

    if (await ViewManagerAdapter.isViewShowing(ViewType.STATUS_BAR)) {
      this.statusBarShowHideChangeEvent.isShow = true;
      EvtBus.post(StatusBarShowHideChangeEvent, this.statusBarShowHideChangeEvent);
    }
    if (!this.isSetOpacityOne) {
      this.statusBarStatus.setStatusBarOpacity(1);
    }
  }

  // 锁屏编辑器单独实现隐藏和显示
  public async hideStatusbarLockEditor(bgColor?: string) {
    let desktopDefaultSystemBarProperty: SCBSystemBarProperty =
      await SceneSessionAdapter.getDesktopDefaultSystemBarProperty();
    // 锁屏编辑器为沉浸式 有背景色 固定为白色状态栏
    let lockEditorColor = StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE;

    log.showInfo(`hide statusbar in lock editor, now color is: ${lockEditorColor}`);
    this.setLockProperty(desktopDefaultSystemBarProperty, false, lockEditorColor, bgColor);
    SceneSessionAdapter.updateSystemBarProperty();
  }

  public setLockEditorState(newState: boolean) {
    EnvVm.instance.isLockEditor = newState;
    if (!EnvVm.instance.isLockEditor) {
      this.resetLockEditorColor();
    }
  }

  private async resetLockEditorColor()  {
    let lockColor: string = StatusBarColorData.instance().getContentColor(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
    let lockProperty: SCBSystemBarProperty = await SceneSessionAdapter.getLockDefaultSystemBarProperty();
    SceneSessionAdapter.setLockDefaultSystemBarProperty(new SCBSystemBarProperty(lockProperty.type, true,
      lockProperty.backgroundcolor, lockColor, true, true));

    let desktopColor: string = StatusBarColorData.instance().getContentColor(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    let desktopProperty: SCBSystemBarProperty =
      await SceneSessionAdapter.getDesktopDefaultSystemBarProperty();
    SceneSessionAdapter.setDesktopDefaultSystemBarProperty(new SCBSystemBarProperty(desktopProperty.type, true,
      desktopProperty.backgroundcolor, desktopColor, true, true));
    log.showInfo(`resetLockEditorColor lockColor: ${lockColor} desktopColor: ${desktopColor}`);
    SceneSessionAdapter.updateSystemBarProperty();
  }

  public async showStatusbarLockEditor(contentColor: string) {
    let lockDefaultSystemBarProperty: SCBSystemBarProperty =
      await SceneSessionAdapter.getLockDefaultSystemBarProperty();
    this.setLockProperty(lockDefaultSystemBarProperty, true, contentColor);

    log.showInfo(`show statusbar in lock editor, now color is: ${contentColor}`);
    SceneSessionAdapter.updateSystemBarProperty();
  }

  private setLockProperty(lockProperty: SCBSystemBarProperty, isShow: boolean,
    contentColor?: string, bgcolor?: string): void {
    let defaultProperty =
      new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, isShow, '00FFFFFF', '#FFFFFFFF', true,
        true);
    if (lockProperty !== undefined) {
      let color = contentColor || lockProperty.contentcolor;
      SceneSessionAdapter.setLockDefaultSystemBarProperty(
        new SCBSystemBarProperty(lockProperty.type, isShow, bgcolor, color, true, true));
    } else {
      SceneSessionAdapter.setLockDefaultSystemBarProperty(defaultProperty);
    }
  }

  public onStatusBarViewChange(isShow: boolean) {
    this.statusBarShowHideChangeEvent.isShow = isShow;
    EvtBus.post(StatusBarShowHideChangeEvent, this.statusBarShowHideChangeEvent);
  }

  /**
   * 冻结壁纸引擎
   */
  public freezeThemeEngine(): void {
    if (this.isThemeEngineFreezed) {
      return;
    }

    this.isThemeEngineFreezed = true;
    TraceUtil.startTrace(DomainName.SYS_UI, STATUS_BAR_FREEZE_THEME_ENGINE);
    log.showInfo('show dropdown panel freezeThemeEngine');
    ThemeWallpaperAniMgrAdapter.reqPlayWallpaperAnimation({
      curState: DynamicWallPaperState.DROPDOWN_PANEL_UP,
      tarState: DynamicWallPaperState.DROPDOWN_PANEL_DOWN,
      isOffScreenSupportAod: false,
      onFinish: () => {},
      isPlayingAnimation: false,
    });
  }

  /**
   * 解冻壁纸引擎
   */
  public unfreezeThemeEngine(): void {
    if (!this.isThemeEngineFreezed) {
      return;
    }

    this.isThemeEngineFreezed = false;
    ThemeWallpaperAniMgrAdapter.reqPlayWallpaperAnimation({
      curState: DynamicWallPaperState.DROPDOWN_PANEL_DOWN,
      tarState: DynamicWallPaperState.DROPDOWN_PANEL_UP,
      isOffScreenSupportAod: false,
      onFinish: () => {},
      isPlayingAnimation: false,
    });
    TraceUtil.endTrace(DomainName.SYS_UI, STATUS_BAR_FREEZE_THEME_ENGINE);
    log.showInfo('hide dropdown panel unfreezeThemeEngine');
  }
}

// 单例
export let scbStatusBarVM: SCBStatusBarVM = SingletonHelper.getInstance(SCBStatusBarVM, TAG);