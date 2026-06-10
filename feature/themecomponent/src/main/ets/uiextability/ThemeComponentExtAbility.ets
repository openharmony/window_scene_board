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

import { display, uiAppearance, uiExtensionHost, window } from '@kit.ArkUI';
import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { settings, wallpaper } from '@kit.BasicServicesKit';
import { Configuration } from '@ohos.app.ability.Configuration';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import { ThemeComponentConstant } from '../utils/ThemeComponentConstant';
import { ThemeInfoAdapter } from '../themeInfoAdapter/ThemeInfoAdapter'
import { TsContext } from '@ohos/themeservicebase'
import { WallPaper, WallPaperInfo } from '@ohos/themeservicekit';
import { common } from '@kit.AbilityKit';

const TAG: string = 'ThemeComponentExtAbility';
const TRANSPARENCY_COLOR: string = '#00000000';

//common.UIAbilityContext | common.ServiceExtensionContext;
export default class ThemeComponentExtAbility extends UIExtensionAbility {
  private windowProxy?: uiExtensionHost.UIExtensionHostWindowProxy;

  private nav: string = '';
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;

  /**
   * On creating UIExtension session, parse the want's parameters and set up
   *
   * @param want Incoming want with initial parameters
   * @param session UIExtension session instance, can be used for IPC communication
   */
  public async onSessionCreate(want: Want, session: UIExtensionContentSession): Promise<void> {
    const storage: LocalStorage = new LocalStorage();
    session?.sendData({ 'hideGalleryLoading': true });
    session?.loadContent('pages/ThemeHome', storage);
    // Log.info(TAG, `onSessionCreate , lastNav is ${NavigationUtil.lastNav}`);
    // const forceQuit: number = setTimeout(() => {
    //   Log.error(TAG, 'onSessionCreate timeout');
    //   this.loadContent(want, session);
    //   return;
    // }, 3500); // 窗口超时判定时间为4s
    Log.info(TAG, `onSessionCreate , lastNav is `);
    const forceQuit: number = setTimeout(() => {
      // Log.error(TAG, 'onSessionCreate timeout');
      this.loadContent(want, session);
      return;
    }, 3500); // 窗口超时判定时间为4s
    // GlobalContext.getContext().setObject(Constants.THEME_EDITOR_CONTEXT, this.context);
    AppStorage.setOrCreate('theme_editor_context', this.context)
    // ThumbnailManager.getInstance(this.context);
    let fontScale: number = 1.0;
    try {
      fontScale = Number(settings.getValueSync(this.context, 'font_scale', '1', settings.domainName.USER_PROPERTY));
    } catch (e) {
      Log.error(TAG, 'get font_scale error');
    }
    // fontScaleManager.setSysFontScale(fontScale);
    session.getUIExtensionHostWindowProxy()?.setWaterMarkFlag(true);
    // if (DeviceHelper.isPC()) {
    //   await PcThemeResourceController.readAllThemeResource();
    // } else {
    //   await ThemeResourceController.readAllThemeResource();
    // }
    // await ParseResourceController.readThemeResource(); // 读取新主题包资源
    clearTimeout(forceQuit);
    this.loadContent(want, session);
  }

  private loadContent(want: Want, session: UIExtensionContentSession) {
    session.setReceiveDataCallback((data: Record<string, Object>) => {
      if (data?.titleAnimationDuration) {
        AppStorage.setOrCreate('titleAnimationDuration', data?.titleAnimationDuration as number);
      }
    });
    if (want && want.parameters) {
      if (want.parameters['statusBarHeight']) {
        AppStorage.setOrCreate('statusBarHeight', want.parameters['statusBarHeight'] as number);
      }
      // 初始化深色模式环境
      this.setupDarkModeEnvironment();
      // 初始化底部避让区域环境
      this.windowProxy = session.getUIExtensionHostWindowProxy();
      this.setupAvoidAreaEnvironment();
      // 解析页面路由参数
      // let params: WantParams = this.getParamsFromWant(want.parameters, session);
      let params: ESObject = this.getParamsFromWant(want.parameters, session);
      if (want.parameters['wallpaperParam']) {
        // params = want.parameters['wallpaperParam'] as WantParams;
        params = want.parameters['wallpaperParam'] as ESObject;
        params.session = session;
      }
      if (want.parameters['allParams']) {
        let allParams: Want = want.parameters['allParams'] as Want;
        if (allParams && allParams.parameters && allParams.parameters['editePageConnection']) {
          params.editorId = allParams.parameters['editorId'] as string;
          params.themeName = allParams.parameters['themeName'] as string;
        }
      }
      let isNeedDestroy: boolean = want.parameters['wallpaperParam'] === undefined &&
        want.parameters['fontPath'] === undefined && want.parameters['themeParams'] === undefined;
      // const para: Record<string, WantParams | boolean> = { 'params': params, 'isNeedDestroy': isNeedDestroy };
      const para: Record<string, ESObject | boolean> = { 'params': params, 'isNeedDestroy': isNeedDestroy };
      // 锁屏/桌面进入壁纸库,设置桌面预览参数
      if (want.parameters['desktopParam']) {
        AppStorage.setOrCreate<Object>('desktopParam', want.parameters['desktopParam']);
      }
      AppStorage.setOrCreate('wallpaperSession', session)
      // 判断上次导航是否进入壁纸编辑页面
      // if (NavigationUtil.isNavToWallpaperEditor(NavigationUtil.lastNav)) {
      //   try {
      //     Log.info(TAG, 'should show status true');
      //     session?.sendData({ 'shouldShowStatus': true }); // 上次导航是进入壁纸编辑页面，需要恢复状态栏
      //   } catch (err) {
      //     Log.error(TAG, `should show status false , error  ${err?.code}`);
      //   }
      // }
      session?.sendData({ 'hideGalleryLoading': true });
      // 重置导航地址为当前值
      // NavigationUtil.lastNav = params.nav;
      Log.info(TAG, `loadContent , current nav is `);

      const storage: LocalStorage = new LocalStorage(para);
      session?.loadContent('pages/ThemeHome', storage);
      session?.setWindowBackgroundColor(TRANSPARENCY_COLOR);
    } else {
      Log.error(TAG, 'have no para');
      session?.loadContent('pages/ThemeHome');
    }
  }

  private getParamsFromWant(parameters: Record<string, Object>, session: UIExtensionContentSession): ESObject {
    this.nav = parameters[ThemeComponentConstant.NAV_NAME] as string;
    // let params: WantParams = {
    let params: ESObject = {
      nav: this.nav,
      isFull: parameters[ThemeComponentConstant.IS_FULL_SCREEN] as boolean ?? false,
      session: session,
      path: parameters['path'] as string ?? '',
      source: parameters['source'] as string ?? '',
      themeName: parameters['themeName'] as string,
      isJumpPersonalizePage: parameters['isJumpPersonalizePage'] as boolean,
      editorId: parameters['editorId'] as string ?? '',
      url: parameters['imageUrl'] as string ?? '',
      needResetClock: parameters['needResetClock'] as boolean ?? false,
      imageAesthetic: parameters['imageAesthetic'] as boolean ?? false,
      // themeParams: parameters['themeParams'] as ThemePrams,
      themeParams: parameters['themeParams'] as ESObject,
      fontPath: parameters['fontPath'] as string,
      imageIdForOnLine: parameters['imageId'] as string,
      imageOrigin: parameters['imageOrigin'] as string,
      isFullPersonalizePage: parameters['isSettingEnter'] as boolean,
      personalizePath: parameters['personalizePath'] as string,
      isFromSearch: parameters['isFromSearch'] as string,
      fromExternalName: ((parameters['allParams'] as Want)?.parameters?.fromExternalName) as string,
      customString: parameters['customstring'] as string,
      customizeData: parameters['customizeData'] as string,
      isSplitMode: parameters['isSplitMode'] as boolean,
    };
    // 全屏壁纸编辑
    if (parameters['wallpaperParam']) {
      // params = parameters['wallpaperParam'] as WantParams;
      params = parameters['wallpaperParam'] as ESObject;
      params.session = session;
    }
    if (parameters['fullPage']) {
      params = parameters['fullPage'] as ESObject;
      params.session = session;
    }
    // if (this.nav && this.nav.includes(`${Constants.THEME_DETAIL}_`)) {
      // this.searchRedirection(params);
    // }
    // this.context.connectServiceExtensionAbility()

    Log.info(TAG, `getParamsFromWant , nav = ${params.nav} , source = ${params.source}`);
    return params;
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    session?.sendData({ 'back': 'pop' });
     Log.info(TAG, 'ThemeComponentExtAbility onSessionDestroy');
    // ThumbnailManager.getInstance(this.context).cancelOngoingTasks();
  }

  onDestroy(): void {
    Log.info(TAG, 'ThemeComponentExtAbility onDestroy');
  }

  onBackground(): void {
    // if (AestheticIsolation.isSupportAesthetic()) {
    //   this.requestSuspendDelay();
    // }
  }

  // private searchRedirection(params: WantParams): void {
  //   const id: string = this.nav.split('_')[1];
    // const themeStruct = ParseResourceController.getThemeById(id);
    // if (themeStruct === undefined) {
      // Log.error(TAG, 'themeStruct is undefined');
      // params.nav = Constants.THEME_PICKER;
      // return;
    // }
    // let themePrams: ThemePrams = {
    //   bundleSource: Constants.SEARCH_THEME_DETAIL,
    //   themeStruct: themeStruct,
    //   isFromSettingSearch: true,
    // };
    // params.themeParams = themePrams;
    // params.source = Constants.SEARCH_THEME_DETAIL;
    // if (DeviceHelper.isSettingSplitProduct()) {
    //   params.nav = Constants.THEME_PICKER;
    //   return;
    // }
    // params.nav = Constants.THEME_DETAIL;
  // }

  private setupDarkModeEnvironment(): void {
    const darkMode: uiAppearance.DarkMode = uiAppearance.getDarkMode();
    if (darkMode === uiAppearance.DarkMode.ALWAYS_DARK) {
      AppStorage.setOrCreate('colorMode', ColorMode.DARK);
    } else {
      AppStorage.setOrCreate('colorMode', ColorMode.LIGHT);
    }
  }

  private areaChangeAction(type: window.AvoidAreaType, area: window.AvoidArea): void {
    const displayData: display.Display = display.getDefaultDisplaySync();
    if (type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
      if (area.visible) {
        const bottomAvoidHeight: number = area.bottomRect.height / displayData.densityPixels;
        AppStorage.setOrCreate('bottomAvoidHeight', bottomAvoidHeight);
      } else {
        AppStorage.setOrCreate('bottomAvoidHeight', 0);
      }
    }
    // if (!DeviceHelper.isPhone() || DeviceHelper.isFoldButNotSmallFoldProduct()) {
    //   if (type === window.AvoidAreaType.TYPE_SYSTEM) {
    //     if (area.visible) {
    //       const topAvoidAreaHeight: number = area.topRect.height / displayData.densityPixels;
    //       AppStorage.setOrCreate('topAvoidAreaHeight', topAvoidAreaHeight);
    //     } else {
    //       AppStorage.setOrCreate('topAvoidAreaHeight', 0);
    //     }
    //   }
    // }
  }

  private setupAvoidAreaEnvironment(): void {
    if (!this.windowProxy) {
      return;
    }
    const windowProxy: uiExtensionHost.UIExtensionHostWindowProxy = this.windowProxy!;
    try {
      windowProxy.on('avoidAreaChange', (data) => {
        this.areaChangeAction(data.type, data.area);
      });
      const displayData: display.Display = display.getDefaultDisplaySync();
      const bottomAvoidArea: window.AvoidArea =
        windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      if (bottomAvoidArea.visible) {
        const bottomAvoidHeight: number = bottomAvoidArea.bottomRect.height / displayData.densityPixels;
        AppStorage.setOrCreate('bottomAvoidHeight', bottomAvoidHeight!);
      } else {
        AppStorage.setOrCreate('bottomAvoidHeight', 0);
      }
      const topAvoidArea: window.AvoidArea = windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      if (topAvoidArea.topRect) {
        const topAvoidAreaHeight: number = topAvoidArea.topRect.height / displayData.densityPixels;
        AppStorage.setOrCreate('topAvoidAreaHeight', topAvoidAreaHeight!);
      } else {
        AppStorage.setOrCreate('topAvoidAreaHeight', 0);
      }
    } catch (error) {
      Log.error(TAG, `setupAvoidAreaEnvironment error: ${error}`);
    }
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    let colorMode: ColorMode;
    if (newConfig.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      colorMode = ColorMode.DARK;
    } else {
      colorMode = ColorMode.LIGHT;
    }
    // fontScaleManager.setSysFontScale(newConfig.fontSizeScale || 1);
    AppStorage.setOrCreate('colorMode', colorMode);
    if (newConfig?.language) {
      // languageManager.refreshLanguage(newConfig.language);
    }
  }

  private requestSuspendDelay(): void {
    try {
      let myReason: string = 'aesthetic requestSuspendDelay';
      let delayInfo: backgroundTaskManager.DelaySuspendInfo =
        backgroundTaskManager.requestSuspendDelay(myReason, () => {
          // let requestId: Object | undefined = GlobalContext.getContext().getObject(AestheticUtil.RECOMMEND_CONNECT_ID);
          // this.cancelDelay(requestId);
        });
      // GlobalContext.getContext().setObject(AestheticUtil.RECOMMEND_CONNECT_ID, delayInfo.requestId);
    } catch (err) {
      Log.error(TAG, `requestSuspendDelay error = ${err}`);
    }
  }

  private cancelDelay(requestId: Object | undefined): void {
    if (requestId) {
      try {
        backgroundTaskManager.cancelSuspendDelay(Number.parseInt(requestId.toString()));
      } catch (err) {
        Log.error(TAG, `cancelSuspendDelay error = ${err}`);
      }
    }
  }
};
