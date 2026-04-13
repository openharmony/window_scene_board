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

import Want from '@ohos.app.ability.Want';
import { JsonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene'
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper'
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import uiAppearance from '@ohos.uiAppearance';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { DesktopParam } from '@ohos/launchercommon/src/main/ets/bean/DesktopParam';
import {
  EditModeConstants,
  WantParams
} from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeConstants';
import { DesktopPreviewRdbManager } from '@ohos/pagedesktop/src/main/ets/default/preview/DesktopPreviewRdbManager';
import { PreviewConstants } from '@ohos/pagedesktop/src/main/ets/default/preview/PreviewConstants';

const TAG: string = 'EditModeIconAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const TRANSPARENCY_COLOR: string = '#00000000';
const DEFAULT_PAGE: string = 'desktopedit/pages/DesktopEditPage';
const INVALID_ID: number = -1;
const TERMINATE_SELF_TIME = 60000;
/**
 * EditModeIconAbility
 */
export default class EditModeIconAbilityPhone extends UIExtensionAbility {
  private timeId: number = INVALID_ID;

  public async onSessionCreate(want: Want, session: UIExtensionContentSession): Promise<void> {
     GlobalContext.getInstance().setObject('desktopContext', this.context);
     if (this.timeId !== INVALID_ID) {
      try {
        clearTimeout(this.timeId);
        this.timeId = INVALID_ID;
      } catch (err) {
        log.showError(TAG, `onSessionCreate failed errCode: ${err.code}, errMessage: ${err.message}`);
      }
    }
    this.handleWantAndSession(want, session);
  }

  private handleWantAndSession(want: Want, session: UIExtensionContentSession):void {
    if (want && want.parameters) {
      let nav: string = want.parameters['nav'] as string;
      // 初始化深色模式环境
      this.setupDarkModeEnvironment();
      // 解析页面路由参数
      const params: WantParams = {
        isDarkMode: want.parameters['isDarkMode'] as boolean,
        wallpaperType: want.parameters['wallpaperType'] as number,
        nav: want.parameters['nav'] as string,
        nameFontColor: want.parameters['nameFontColor'] as string,
        statusBarHeight: want.parameters['statusBarHeight'] as number,
        iconSize: want.parameters['iconSize'] as number,
        gridWidth: want.parameters['gridWidth'] as number,
        gridHeight: want.parameters['gridHeight'] as number,
        columns: want.parameters['columns'] as number,
        rows: want.parameters['rows'] as number,
        screenHeight: want.parameters['screenHeight'] as number,
        screenWidth: want.parameters['screenWidth'] as number,
        isDarkWallpaper: want.parameters['isDarkWallpaper'] as boolean,
        iconChangeSize: want.parameters['iconChangeSize'] as number,
        isShowName: want.parameters['isShowName'] as boolean,
        fontSizeScale: want.parameters['fontSizeScale'] as number,
        vp2pxScale: want.parameters['vp2pxScale'] as number,
        isAccessibilityMode: want.parameters['isAccessibilityMode'] as boolean,
        session: session,
        isNeedAppNameShadow: want.parameters['isNeedAppNameShadow'] as boolean,
        isFoldExpandedInLandscape: want.parameters['isFoldExpandedInLandscape'] as boolean,
        singlePageFoldScreenWidth: want.parameters['singlePageFoldScreenWidth'] as number,
      };
      const para: Record<string, WantParams> = { 'params': params };
      log.showInfo('onSessionCreate ' + JSON.stringify(want.parameters));
      const storage: LocalStorage = new LocalStorage(para);
      session.loadContent(DEFAULT_PAGE, storage);
      session.setWindowBackgroundColor(TRANSPARENCY_COLOR);
      ResUtils.init(this.context);
      if (nav === PreviewConstants.PREVIEW_PATH) {
        let desktopParam: DesktopParam | undefined = this.dealDesktopPreviewParam(want);
        let desktopModel: number = desktopParam && desktopParam.isSimpleMode ? PreviewConstants.SIMPLE_DESKTOP_MODE :
          PreviewConstants.HOME_DESKTOP_MODE;
        this.initPreview(desktopModel);
      } else if (nav === EditModeConstants.PATH_ICON) {
        this.dealDesktopPreviewParam(want);
      }
    } else {
      log.error('have no para');
      session.loadContent(DEFAULT_PAGE);
    }
  }

  onCreate(launchParam: AbilityConstant.LaunchParam): void {
    // IconEditPageComponentExtAbility 预加载后如果60s没有组件被拉起使用，则进程自动退出
    this.timeId = setTimeout(()=> {
      try {
        log.showInfo('terminateSelf success');
        this.timeId = INVALID_ID;
        this.context?.terminateSelf();
      } catch (err) {
        log.showError(TAG, `terminateSelf failed errCode: ${err.code}, errMessage: ${err.message}`);
      }
    }, TERMINATE_SELF_TIME);
  }

  onDestroy(): void | Promise<void> {
    if (this.timeId !== INVALID_ID) {
      try {
        clearTimeout(this.timeId);
        this.timeId = INVALID_ID;
      } catch (err) {
        log.showError(TAG, `onDestroy failed errCode: ${err.code}, errMessage: ${err.message}`);
      }
    }
  }

  private dealDesktopPreviewParam(want: Want): DesktopParam | undefined {
    let desktopParam: DesktopParam | undefined = undefined
    if (want && want.parameters) {
      try {
        const desktopParamObj: DesktopParam = want.parameters['desktopParam'] as DesktopParam;
        desktopParam = JsonUtils.parse<DesktopParam>(() => new DesktopParam(), JSON.stringify(desktopParamObj));
        if (desktopParam) {
          desktopParam.formRadius = ResUtils.getNumber($r('app.float.form_corner_radius'));
        }
      } catch (error) {
        log.showError('dealDesktopPreviewParam error%{public}d:%{public}s', error.code, error.message);
      }
      AppStorage.setOrCreate<DesktopParam>('desktopParam', desktopParam);
      AppStorage.setOrCreate<string>('from', want.parameters['from'] as string);
    }
    return desktopParam;
  }

  private initPreview(desktopModel: number): void {
    // 初始化桌面预览资源
    let rdbManager = DesktopPreviewRdbManager.getInstance(desktopModel);
    rdbManager.initIconResourceCache();
    rdbManager.initIconName();

    let isFold = DeviceHelper.isFoldButNotSmallFoldProduct();
    AppStorage.setOrCreate<boolean>('isFold', isFold);
    rdbManager.initDesktopData(this.context, isFold);
  }

  private setupDarkModeEnvironment(): void {
    const darkMode: uiAppearance.DarkMode = uiAppearance.getDarkMode();
    if (darkMode === uiAppearance.DarkMode.ALWAYS_DARK) {
      AppStorage.setOrCreate('colorMode', ColorMode.DARK);
    } else {
      AppStorage.setOrCreate('colorMode', ColorMode.LIGHT);
    }
  }
}