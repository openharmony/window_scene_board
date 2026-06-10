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

import { common } from '@kit.AbilityKit';
import { ThemeInfo, TServiceApi, VersionInfo } from '@ohos/themeservice_inner_api/Index';
import { ContextUtil, TsContext, TsLog } from '@ohos/themeservicebase/Index';
import { themeAppStatusService } from './impl/ThemeAppStatusServiceImpl';
import { themeInfoService } from './impl/ThemeInfoServiceImpl';
import { TServiceRegister } from './TServiceRegister';
import { TsEventProvider } from './TsEventProvider';
import { themeTrialService } from './impl/ThemeTrialServiceImpl';
import { presetRecommendService, TsPresetRecommendImpl } from './impl/TsPresetRecommendImpl';
import { setWallPaperImageService } from './impl/activate/SetWallpaperImageImpl';
import { HiSysEventUtils } from '../util/HiSysEventUtils';
import { themeSearchService } from './impl/ThemeSearchServiceImpl';

const TAG: string = 'TSInitializer';

// 解决桌面初始化启动TS服务可能失败的情况，防止后面外部接口调用TS服务接口多次启动多次初始化的问题
let tsInit: boolean = false;

export namespace TSInitializer {
  export async function init(context: TsContext | common.AbilityStageContext): Promise<void> {
    if (tsInit) {
      TsLog.info(TAG, 'Ts has init');
      return;
    }
    tsInit = true;
    // 1.registration services
    try {
      await TServiceRegister.registerService();
    } catch (err) {
      TsLog.error(TAG, `registerService catch exception.`, err);
    }
    // 2.Initialize Services
    return initService(context);
  }

  async function initService(context: TsContext | common.AbilityStageContext): Promise<void> {
    ContextUtil.subscribeTsApplication(context);
    // Initialize the registration and uninstallation of the app public event listener.
    themeAppStatusService.get().registerUninstallSubscriber();
    // Initialize the SA topic to enable public event listening.
    TsEventProvider.getInstance().initSubscriber();
    // 延时1分钟，检查试用到期
    themeTrialService().onInit();
    await TServiceApi.subScreen().init();
    HiSysEventUtils.reportDataSize();
    themeSearchService.get().init(false);
    return Promise.all([TServiceApi.lem().init(),
      themeInfoService.get().init(),
      TServiceApi.upgrade().init((from: number, to: number) => {
        TsLog.info(TAG, `doUpgrade recovery ${from} -> ${to}}`);
        return Promise.resolve();
      }),
      presetRecommendService.get().onInit(),
      TServiceApi.upgrade().initOS(async (from?: VersionInfo, to?: VersionInfo) => {
        TsLog.info(TAG, `doUpgrade recovery ${from?.buildVersion} -> ${to?.buildVersion}`);
        if (!from) {
          let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
          if (defaultTheme.originThemePack?.srcPath && defaultTheme.editorId) {
            setWallPaperImageService.get()
              .initThemeWallpaperImage(defaultTheme.originThemePack?.srcPath, defaultTheme.editorId);
          }
        }
      })
    ])
      .then(() => {
        TsLog.info(TAG, `init all service success`);
      })
      .catch((error: Error) => {
        TsLog.error(TAG, `init all service success catch Error`, error);
      });
  }
}