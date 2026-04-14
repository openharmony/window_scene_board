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
import { Log, LogDomain, LogHelper } from '@ohos/basicutils';
import { WallpaperConstants } from '@ohos/commonconstants';
import {
  GlobalContext,
  WallpaperChangeListener,
  WallpaperColorManager,
  WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import {
  SCBSceneSession, SCBSceneSessionManager, SCBSystemBarProperty, SystemBarType } from '@ohos/windowscene';
import { curves } from '@kit.ArkUI';
import settings from '@ohos.settings';
import context from '@ohos.app.ability.common';

const TAG = 'DockBackgroundMgr';
const FULLSCREEN_TAG = 'FixedLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

enum SCBFoldState {
  UNKNOWN = 0,
  HALF_FOLDED_VIRTUAL_KEYBOARD,
  HALF_FOLDED_PHYSICAL_KEYBOARD,
  HALF_FOLDED,
  UNFOLDED_VERTICAL,
  UNFOLDED_HORIZONTAL
};

class DockWhiteApp {
  public bundleName: string = '';
  public contentColor: string = '';
}

export class FullScreenEvent {
  public isFullScreen: boolean = false;
  public screenId: number = 0;
}

class ViewData {
  public currColorMode: number = 0; // 记录UI状态
  public isFullScreen: boolean = false; // 记录UI状态
  public winFullState: boolean = false; // 当前的窗口是否是全屏模式
  public isSystemBarDark: boolean = false; // 系统状态栏深浅色
  public fullLayoutChanged: boolean = false;
  public isAppCenterShow: boolean = false;
  public isHalfFold: boolean = false;
  public changeCallback: Function | undefined;
  public itemCallback: Function | undefined;
  public animateTimer: number | undefined = undefined;
}

const DATA_SHARE_DOCK_BACKGROUND_STYLE: string = 'settings.dock.background_style';
const DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM: string = 'system';
const DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER: string = 'wallpaper';
const DEFAULT_VAL: string = DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER; // 默认值设置
const DEFAULT_OFFSET: number = 0.9;

export class DockBackgroundMgr {
  private static instance = new DockBackgroundMgr();
  private whiteList: DockWhiteApp[] = []; // dock背板白名单
  private dockOffset: number = DEFAULT_OFFSET; // dock区域取色
  private degree: number = 0; // 壁纸亮度值
  private wallpaperColorMode: number = 0; // 0：深色、1：浅色、2：花色
  private systemColorMode: number = GlobalContext.getContext().config.colorMode as number; // 系统的深浅色
  private isRecentCenterShow: boolean = false; // 任务中心状态
  private viewModels: Map<number, ViewData> = new Map<number, ViewData>();
  private dockStyle: string = DEFAULT_VAL; // dock背板style设置

  private constructor() {
    // read white list from ccm, FF000000 : 深色字浅色背板， #FFFFFFFF : 浅色字深色背板
    this.whiteList.push(
      { bundleName: 'com.openharmony.it.works', contentColor: '#FF000000' },
      { bundleName: 'com.ss.ohpc.ugc.aweme', contentColor: '#FFFFFFFF' },
      { bundleName: 'com.lemon.lvpro', contentColor: '#FFFFFFFF' }
    );
    this.initInner();
  }

  public static getInstance(): DockBackgroundMgr {
    return DockBackgroundMgr.instance;
  }

  private initInner(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    try {
      const style: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      if (style !== '') {
        this.dockStyle = style;
      }
      settings.registerKeyObserver(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, settings.domainName.USER_PROPERTY,
        () => {
          this.settingDataChanged();
        });
    } catch (error) {
      log.showError(`registerKeyObserver error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  private settingDataChanged(): void {
    log.showInfo(`settingDataChanged`);
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    const style: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
      settings.domainName.USER_PROPERTY);
    if (this.dockStyle === style) {
      return;
    }
    if (style === DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM || style === DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER) {
      this.dockStyle = style;
      this.updateAllScreen();
    }
  }

  /**
   * init dock view model
   * @param screenId
   * @param callback UI回调，刷新dock背板状态变量
   * @param itemCallback UI回调，刷新dock图标状态变量
   * @returns void
   */
  public init(screenId: number, callback: Function, itemCallback: Function): void {
    log.showInfo(`init screenId:${screenId}`);
    let viewModel = this.getViewModel(screenId);
    viewModel.changeCallback = callback;
    viewModel.itemCallback = itemCallback;
    SCBSceneSessionManager.getInstance().registerFullScreenLayoutCallBack(FULLSCREEN_TAG,
      screenId, this.onFullScreenChanged);
    SCBSceneSessionManager.getInstance().registerRawSystemBarPropertyCallback(this.onPropertyChanged, screenId, 'dock');
    if (screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().registerSystemBarPropertyAdjusterCallback(this.adjustPropertyCallback);
      WallpaperManager.getInstance().addWallpaperChangeListener(this.wallPaperChange);
      this.updateDegree();
    }
  }

  /**
   * deinit dock view model
   * @param screenId
   */
  public deInit(screenId: number): void {
    if (screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyAdjusterCallback();
      WallpaperManager.getInstance().removeWallpaperChangeListener(this.wallPaperChange);
    }
    log.showInfo(`deInit screenId:${screenId}`);
    SCBSceneSessionManager.getInstance().unRegisterFullScreenLayoutCallBack(FULLSCREEN_TAG, screenId);
    SCBSceneSessionManager.getInstance().unRegisterRawSystemBarPropertyCallback(this.onPropertyChanged, screenId, 'dock');
    this.viewModels.delete(screenId);
  }

  public getDockColorMode(screenId: number = 0): number {
    const viewModel: ViewData = this.getViewModel(screenId);
    return viewModel?.currColorMode ?? 0;
  }

  private getViewModel(screenId: number): ViewData {
    let data: ViewData | undefined = this.viewModels.get(screenId);
    if (data === undefined) {
      data = new ViewData();
      this.viewModels.set(screenId, data);
    }
    return data;
  }

  private getContentColor(bundleName: string | undefined): string | undefined {
    if (bundleName === undefined) {
      return undefined;
    }
    for (let i = 0; i < this.whiteList.length; i++) {
      if (this.whiteList[i].bundleName === bundleName) {
        return this.whiteList[i].contentColor;
      }
    }
    return undefined;
  }

  private adjustPropertyCallback = (session: SCBSceneSession, property: SCBSystemBarProperty) => {
    if (session === undefined || property === undefined) {
      return;
    }
    const contentColor = this.getContentColor(session.sceneInfo.bundleName);
    if (contentColor !== undefined) {
      Log.showInfo(TAG, `updateSystemBarProperty: from:${property.contentcolor} to:${contentColor}`);
      property.contentcolor = contentColor;
    }
  };

  private onFullScreenChanged = (isFullScreen: boolean, screenId: number): void => {
    log.showInfo(`setFullScreenState isFull:${isFullScreen}, screenId:${screenId}`);
    let viewModel: ViewData = this.getViewModel(screenId);
    if (viewModel.winFullState !== isFullScreen) {
      viewModel.winFullState = isFullScreen;
      viewModel.fullLayoutChanged = true;
      if (!isFullScreen || viewModel.isHalfFold) {
        this.updateBrightness(screenId, viewModel, 'onFullScreenChanged', true);
      }
    }
    let fullScreenEvent: FullScreenEvent = {isFullScreen: isFullScreen, screenId: screenId};
    GlobalContext.getContext()?.eventHub.emit('fullScreenEvent', fullScreenEvent);
  }

  private onPropertyChanged = (property: SCBSystemBarProperty, screenId: number): void => {
    if (property === undefined || property.notifyType === SystemBarType.STATUS_BAR) {
      return;
    }
    log.showInfo(`updateSystemBar contentColor:${property.contentcolor} screenId: ${screenId}`);
    let viewModel: ViewData = this.getViewModel(screenId);
    if (property.contentcolor.endsWith('FFFFFF')) {
      viewModel.isSystemBarDark = true;
      this.updateBrightness(screenId, viewModel, 'updateSystemBarProperty', viewModel.fullLayoutChanged);
    } else if (property.contentcolor.endsWith('000000')) {
      viewModel.isSystemBarDark = false;
      this.updateBrightness(screenId, viewModel, 'updateSystemBarProperty', viewModel.fullLayoutChanged);
    }
    viewModel.fullLayoutChanged = false;
  };

  /**
   * 折叠屏状态变换
   * @param foldStatus
   * @param screenId
   */
  public setFoldStatus(foldStatus: number, screenId: number): void {
    log.showInfo(`setFoldStatus status:${foldStatus}, screenId:${screenId}`);
    let viewModel: ViewData = this.getViewModel(screenId);
    // 折叠态时，按C面窗口全屏为全屏标记
    const isHalfFold: boolean = foldStatus === SCBFoldState.HALF_FOLDED;
    if (viewModel.isHalfFold !== isHalfFold) {
      viewModel.isHalfFold = isHalfFold;
      this.updateBrightness(screenId, viewModel, 'setFoldStatus');
    }
  }

  /**
   * 系统主题色
   * @param systemColorMode
   */
  public setSystemColor(systemColorMode: number): void {
    if (this.systemColorMode !== systemColorMode) {
      this.systemColorMode = systemColorMode;
      if (this.dockStyle === DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM) {
        this.updateAllScreen();
      }
    }
  }

  /**
   * 应用中心状态
   * @param isAppCenterShow
   * @param screenId
   */
  public setAppCenterShow(isAppCenterShow: boolean, screenId: number): void {
    let viewModel: ViewData = this.getViewModel(screenId);
    if (viewModel.isAppCenterShow !== isAppCenterShow) {
      viewModel.isAppCenterShow = isAppCenterShow;
      this.updateBrightness(screenId, viewModel, 'appCenterShow');
    }
  }

  /**
   * 多任务中心状态
   * @param isRecentShow
   */
  public setRecentViewShow(isRecentShow: boolean): void {
    if (this.isRecentCenterShow !== isRecentShow) {
      this.isRecentCenterShow = isRecentShow;
      this.updateAllScreen();
    }
  }

  /**
   * dock区域状态
   * @param area
   * @param screenId
   * @returns
   */
  public setDockRegion(screenId: number, screenHeight: number, dockHeight: number): void {
    if (screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      this.dockOffset = screenHeight !== 0 ? (screenHeight - dockHeight) / screenHeight : DEFAULT_OFFSET;
    }
  }

  private wallPaperChange: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.DESKTOP,
    onWallPaperChange: async () => {
      log.showInfo('WallPaper Change');
      this.updateDegree();
    }
  };

  private updateDegree(): void {
    const region: number[] = [0, this.dockOffset, 1, 1];
    WallpaperColorManager.getInstance().getDegree(region).then((degree: number) => {
      if (this.degree != degree) {
        this.degree = degree;
        this.wallpaperColorMode = this.updateWallpaperColorMode(this.degree);
        log.showInfo(`updateDegree:${this.degree} offset:${this.dockOffset}`);
        this.updateAllScreen();
      }
    });
  }

  private updateWallpaperColorMode(degree: number): number {
    if (degree === WallpaperConstants.WALLPAPER_TYPE_FOUR || degree === WallpaperConstants.WALLPAPER_TYPE_THREE) {
      return 0;
    } else if (degree === WallpaperConstants.WALLPAPER_TYPE_FIVE || degree === WallpaperConstants.WALLPAPER_TYPE_SIX) {
      return 2;
    }
    return 1;
  }

  private updateDockBackgroundColorWithAnim(callback: () => void, duration: number = 330, delay: number = 0): void {
    animateToImmediately({
      duration: duration,
      delay: delay,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, callback);
  }

  private updateAllScreen(): void {
    this.viewModels.forEach((model: ViewData, screenId: number) => {
      this.updateBrightness(screenId, model, 'updateAllScreen');
    });
  }

  private updateBrightness(screenId: number, viewModel: ViewData, reason: string, isAnim: boolean = true): void {
    if (viewModel.changeCallback === undefined) {
      return;
    }
    let colorMode: number = viewModel.currColorMode;
    let isFullScreen: boolean = viewModel.winFullState && !this.isRecentCenterShow && !viewModel.isAppCenterShow;
    if (this.dockStyle === DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM) {
      if (this.systemColorMode === 0) {
        colorMode = 0;
      } else {
        colorMode = this.wallpaperColorMode !== 0 ? this.wallpaperColorMode : 2;
      }
    } else {
      if (this.isRecentCenterShow || viewModel.isAppCenterShow || !isFullScreen) {
        colorMode = this.wallpaperColorMode;
      } else if (viewModel.isSystemBarDark) {
        colorMode = 0;
      } else {
        colorMode = this.wallpaperColorMode !== 0 ? this.wallpaperColorMode : 2;
      }
    }
    log.showInfo(`updateBrightness: ${reason} screenId:${screenId} degree:${this.degree} anim:${isAnim}` +
      ` curr:${viewModel.currColorMode} next:${colorMode} systembar:${viewModel.isSystemBarDark}` +
      ` currLayout:${viewModel.isFullScreen} next:${isFullScreen} halfFold:${viewModel.isHalfFold}`);
    if (viewModel.currColorMode !== colorMode || viewModel.isFullScreen !== isFullScreen) {
      viewModel.currColorMode = colorMode;
      viewModel.isFullScreen = isFullScreen;
      this.clearColorAnimateTimer(viewModel);
      viewModel.animateTimer = setTimeout(() => {
        if (isAnim) {
          this.updateDockBackgroundColorWithAnim(() => {
            viewModel.changeCallback?.(colorMode, isFullScreen);
          });
          this.updateDockBackgroundColorWithAnim(() => {
            viewModel.itemCallback?.(colorMode);
          }, 0, 100);
        } else {
          viewModel.changeCallback?.(colorMode, isFullScreen);
          viewModel.itemCallback?.(colorMode);
        }
      }, isAnim ? 20 : 0);
    }
  }

  private clearColorAnimateTimer(viewModel: ViewData): void {
    if (viewModel.animateTimer !== undefined) {
      clearTimeout(viewModel.animateTimer);
      viewModel.animateTimer = undefined;
    }
  }
}