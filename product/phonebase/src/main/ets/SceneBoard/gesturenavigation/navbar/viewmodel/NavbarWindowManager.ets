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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { DeviceHelper, ViewArea as ScreenRect, } from '@ohos/frameworkwrapper';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import {
  GestureNavigationState,
  SCBSceneSessionManager,
  SCBScreenProperty,
  gestureNavigationObserver,
  SceneCaller,
  NavigationType,
  GestureNavigationEvent,
} from '@ohos/windowscene';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';
import { SystemSceneConstants } from '../../SystemSceneConstants';
import { ScenePanelState } from '../../../scenemanager/SCBScenePanel';

const TAG = 'NavbarWindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 底部导航窗口管理
 */
export class NavbarWindowManager {
  // 窗口id
  private persistentId_: number = 0;
  // view控制类，负责改变窗口大小
  private viewController?: BaseViewController;
  // 屏幕宽度，单位px
  private screenWidth: number = 0;
  // 屏幕宽度，单位px
  private screenHeight: number = 0;
  // 窗口宽度，单位px。热区的宽度随之变动
  private windowWidth: number = 0;
  // 窗口高度，单位px
  private windowHeight: number = 0;
  // 热区高度，单位vp
  private responseRegionHeight_: number = 0;
  // 额外高度，单位px 若为新形态小折叠折叠态，手势窗口高度+4vp，热区高度+4vp
  private extraHeight: number = 0;
  // 桌面窗口的状态
  private scenePanelState: ScenePanelState = ScenePanelState.HOME;
  // 是否在底部上滑过程中
  private isInNavBarGesture: boolean = false;
  // 是否需要刷新窗口
  private needWindowUpdate: boolean = false;
  // 是否需要刷新窗口热区
  private needRegionUpdate: boolean = false;
  // 窗口大小是否为全屏
  private isWindowHorizontalFullScreen: boolean = false;
  private isWindowPortraitFullScreen: boolean = false;

  /**
   * 初始化
   *
   * @param viewController 窗口控制类
   * @param persistentId 窗口id
   */
  public init(viewController: BaseViewController, persistentId: number): void {
    this.viewController = viewController;
    this.persistentId_ = persistentId;
    this.registerGestureNavigationEvent();
  }

  /**
   * 释放资源
   */
  public release(): void {
    gestureNavigationObserver.unRegisterGestureNavigationEvent(SceneCaller.NAVBAR_WINDOW_MANAGER);
  }

  /**
   * 监听底部上滑手势事件
   */
  private registerGestureNavigationEvent(): void {
    gestureNavigationObserver.registerGestureNavigationEvent(SceneCaller.NAVBAR_WINDOW_MANAGER,
      (state: GestureNavigationState, gestureNavigationEvent: GestureNavigationEvent) => {
        if (gestureNavigationEvent.type !== NavigationType.GESTURE) {
          return;
        }
        switch (state) {
          case GestureNavigationState.START:
            this.isInNavBarGesture = true;
            break;
          case GestureNavigationState.UPDATE:
            break;
          case GestureNavigationState.END:
          case GestureNavigationState.CANCEL:
            this.isInNavBarGesture = false;
            break;
          default:
            break;
        }
      });
  }

  /**
   * 获取窗口id
   * @returns 窗口id
   */
  public get persistentId(): number {
    return this.persistentId_;
  }

  /**
   * 设置屏幕宽度
   *
   * @param screenWidth 屏幕宽度，单位px
   * @returns
   */
  public setScreenProperty(screenProperty: SCBScreenProperty): NavbarWindowManager {
    log.showInfo(`setScreenProperty, pre:[${this.screenWidth}, ${this.screenHeight}], cur:[${screenProperty.width}, ${screenProperty.height}]`);
    let screenWidth = Math.ceil(screenProperty.width);
    let screenHeight = Math.ceil(screenProperty.height);
    if (screenWidth !== this.screenWidth) {
      this.screenWidth = screenWidth;
      this.needWindowUpdate = true;
    }
    if (screenHeight !== this.screenHeight) {
      this.screenHeight = screenHeight;
      this.needWindowUpdate = true;
    }
    return this;
  }

  /**
   * 设置窗口高度
   *
   * @param windowHeight 窗口高度，单位px
   * @returns
   */
  public setWindowHeight(windowHeight: number): NavbarWindowManager {
    if (windowHeight !== this.windowHeight) {
      log.showInfo(`setWindowHeight,pre:${this.windowHeight}, cur:${windowHeight}`);
      this.windowHeight = windowHeight;
      this.needWindowUpdate = true;
    }
    return this;
  }

  /**
   * 设置热区高度
   *
   * @param responseRegionHeight 热区高度，单位vp
   * @returns
   */
  public setResponseRegionHeight(responseRegionHeight: number): NavbarWindowManager {
    if (responseRegionHeight !== this.responseRegionHeight_) {
      log.showInfo(`setResponseRegionHeight,pre:${this.responseRegionHeight_}, cur:${responseRegionHeight}`);
      this.responseRegionHeight_ = responseRegionHeight;
      this.needRegionUpdate = true;
    }
    return this;
  }

  /**
   * 获取热区的高度，单位vp
   *
   * @returns
   */
  public get responseRegionHeight(): number {
    return this.responseRegionHeight_;
  }

  /**
   * 设置额外高度，单位px
   *
   * @param extraHeight 额外高度，单位px
   * @returns
   */
  public setExtraHeight(extraHeight: number): NavbarWindowManager {
    log.showInfo(`setExtraHeight,pre:${this.extraHeight}, cur:${extraHeight}`);
    if (extraHeight !== this.extraHeight) {
      this.extraHeight = extraHeight;
      this.needWindowUpdate = true;
      this.needRegionUpdate = true;
    }
    return this;
  }

  /**
   * 是否为窗口全屏
   * @param isWindowPortraitFullScreen 是否为纵向全屏
   * @param isWindowHorizontalFullScreen 是否为横向全屏
   * @returns
   */
  public isWindowFullScreen(isWindowPortraitFullScreen: boolean,
    isWindowHorizontalFullScreen: boolean): NavbarWindowManager {
    log.showInfo(`Portrait:${this.isWindowPortraitFullScreen}, Horizontal:${isWindowHorizontalFullScreen}`);
    if (isWindowPortraitFullScreen !== this.isWindowPortraitFullScreen ||
      isWindowHorizontalFullScreen !== this.isWindowHorizontalFullScreen) {
      this.isWindowPortraitFullScreen = isWindowPortraitFullScreen;
      this.isWindowHorizontalFullScreen = isWindowHorizontalFullScreen;
      this.needWindowUpdate = true;
      this.needRegionUpdate = true;
    }
    return this;
  }

  /**
   * 根据ScenePanelState，刷新底部导航窗口和热区。
   * 手机横屏应用界面70%（Pad80%），横屏桌面100%
   *
   * @param scenePanelState
   */
  public updateByScenePanelState(scenePanelState: ScenePanelState): void {
    if (this.scenePanelState === scenePanelState) {
      log.showInfo('scenePanelState is same, no need update.');
      return;
    }
    // 非横屏场景不刷新
    if (this.screenWidth <= this.screenHeight) {
      log.showDebug('not Landscape, no need update.');
      this.scenePanelState = scenePanelState;
      return;
    }
    log.showInfo(`updateByScenePanelState:pre:${this.scenePanelState}, cur:${scenePanelState}`);
    if (this.scenePanelState === ScenePanelState.FULLSCENE || scenePanelState === ScenePanelState.FULLSCENE) {
      this.scenePanelState = scenePanelState;
      this.needWindowUpdate = true;
      this.update();
      return;
    }
    this.scenePanelState = scenePanelState;
  }

  /**
   * 刷新窗口布局和热区
   *
   * @param isForced 是否强制刷新
   */
  public update(isForced?: boolean): void {
    // 底部上滑过程中，不做刷新处理
    if (this.isInNavBarGesture) {
      log.showDebug(`in NavBarGesture, no update window.`);
      return;
    }
    // 屏幕、窗口、热区参数未变，也未设置强制刷新，不做刷新处理
    if (!isForced && !this.needWindowUpdate && !this.needRegionUpdate) {
      log.showDebug('window no need update.');
      return;
    }
    log.showInfo(`update, isFullScreen:[${this.isWindowPortraitFullScreen}, ${this.isWindowHorizontalFullScreen}]`);
    if (this.isLandscapeInApp() && !this.isWindowHorizontalFullScreen) {
      this.windowWidth = this.screenWidth * this.getLandscapeWindowWidthPercent();
    } else {
      this.windowWidth = this.screenWidth;
    }
    if (this.isWindowPortraitFullScreen) {
      this.windowHeight = this.screenHeight - this.extraHeight;
    }
    if (isForced || this.needWindowUpdate) {
      this.updateWindowSize();
    }
    this.updateResponseRegion();
    this.resetChangeFlags();
  }

  /**
   * 刷新窗口布局
   */
  private updateWindowSize(): void {
    const area: ScreenRect = {
      left: (this.screenWidth - this.windowWidth) / 2,
      top: this.screenHeight - (this.windowHeight + this.extraHeight),
      width: this.windowWidth,
      height: this.windowHeight + this.extraHeight
    };
    log.showInfo(`updateWindowSize:[${area.left}, ${area.top}, ${area.width}, ${area.height}]`);
    this.viewController?.updateArea(area);
    this.viewController?.updateRectInPx(area);
  }

  /**
   * 刷新窗口热区
   */
  private updateResponseRegion(): void {
    const hotAreaHeightPx: number = Math.floor(ArkUIAdapter.vp2px(this.responseRegionHeight));
    log.showInfo(`windowHeight:${this.windowHeight},hotAreaHeight:${this.responseRegionHeight},hotAreaHeightPx:${hotAreaHeightPx},extraHeight:${this.extraHeight}`);
    let regionWidth: number = this.windowWidth;
    if (this.isWindowHorizontalFullScreen) {
      regionWidth = Math.ceil(vp2px(280));
    }
    let regions: Rectangle[] = [{
      x: (this.windowWidth - regionWidth) / 2,
      y: this.windowHeight - hotAreaHeightPx,
      width: regionWidth,
      height: hotAreaHeightPx + this.extraHeight
    }]
    log.showInfo(`updateResponseRegion:[${regions[0].x}, ${regions[0].y}, ${regions[0].width}, ${regions[0].height}]`);
    let sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (sysSceneSession) {
      sysSceneSession.setResponseRegion(regions);
    }
  }

  /**
   * 是否是横屏应用
   *
   * @returns true，横屏应用；false 非横屏应用
   */
  private isLandscapeInApp(): boolean {
    log.showInfo(`isLandscapeInApp, scenePanelState:${this.scenePanelState}, screenProperty:[${this.screenWidth}, ${this.screenHeight}]`);
    if (this.screenWidth > this.screenHeight && this.scenePanelState === ScenePanelState.FULLSCENE) {
      return true;
    }
    return false;
  }

  /**
   * 获取横屏状态下窗口宽度与屏幕宽度比
   * @returns 横屏状态下窗口宽度与屏幕宽度比
   */
  private getLandscapeWindowWidthPercent(): number {
    let landscapeWindowWidthPercent =
      gestureNavBarSettings.getLandscapeWindowWidthPercent(SystemSceneConstants.LANDSCAPE_WINDOWWIDTH_PERCENT_PHONE);
    if (DeviceHelper.isPad()) {
      landscapeWindowWidthPercent =
        gestureNavBarSettings.getLandscapeWindowWidthPercent(SystemSceneConstants.LANDSCAPE_WINDOWWIDTH_PERCENT_PAD);
    }
    return landscapeWindowWidthPercent;
  }

  /**
   * 重置改变的参数
   */
  private resetChangeFlags(): void {
    this.needWindowUpdate = false;
    this.needRegionUpdate = false;
  }
}