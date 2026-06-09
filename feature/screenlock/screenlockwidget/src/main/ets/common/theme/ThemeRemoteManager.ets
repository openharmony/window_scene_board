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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LockscreenConfig, LockscreenThemeConfig } from '../WidgetParam';
import common from '@ohos.app.ability.common';
import { TSManager, TARGET_LOCK, TConfigArg } from '@ohos/themeservicekit';
import { DEFAULT_SANDBOX_THEME_QUALIFIER } from './ScreenLockThemeManager';
import { IDofParam } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  DofWallpaperStaticStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

const TAG: string = 'ThemeRemoteManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const fileName: string = 'config.json';

/**
 * 从TS服务端获取主题信息的Manager
 */
export class ThemeRemoteManager {
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private mTConfigArg: TConfigArg[] = [];

  constructor() {
  }

  setCurrentThemeCfg(lockscreenConfig: LockscreenConfig | LockscreenThemeConfig): void {
    this.mTConfigArg = [{
      target: TARGET_LOCK,
      qualifier: DEFAULT_SANDBOX_THEME_QUALIFIER,
      fileName: fileName,
      value: JSON.stringify(lockscreenConfig),
    }];
    let config = this.getDofWallpaperConfig();
    this.mTConfigArg.push(...config);
    TSManager.getRemoteCaller(this.uiContext).setCurrentThemeCfg(this.mTConfigArg).then((result: boolean) => {
      log.showInfo(`setCurrentThemeCfg = ${result}`);
    });
  }

  setMultiSceneThemeCfg(lockscreenConfigs: Map<string, LockscreenConfig | undefined>): void {
    let configArgs: TConfigArg[] = [];
    lockscreenConfigs.forEach((lockscreenConfig, qualifier) => {
      if (lockscreenConfig) {
        let cfg: TConfigArg = {
          target: TARGET_LOCK,
          qualifier: qualifier,
          fileName: fileName,
          value: JSON.stringify(lockscreenConfig),
        };
        configArgs.push(cfg);
      }
    });
    let config = this.getDofWallpaperConfig();
    configArgs.push(...config);
    TSManager.getRemoteCaller(this.uiContext).setCurrentThemeCfg(configArgs).then((result: boolean) => {
      log.showInfo(`setMultiSceneThemeCfg = ${result}`);
    });
  }

  /**
   * 获取景深壁纸的配置信息
   */
  private getDofWallpaperConfig(): TConfigArg[] {
    let configArgs: TConfigArg[] = [];
    let dofScenesInfo = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
      DofWallpaperStaticStateType.DOF_TYPE_CONFIG) as Map<string, IDofParam>;

    dofScenesInfo?.forEach((key, value) => {
      let cfg: TConfigArg = {
        target: TARGET_LOCK,
        qualifier: value,
        fileName: 'wallpaper_config.json',
        value: key.configContent,
      };
      configArgs.push(cfg);
    });
    return configArgs;
  }
}