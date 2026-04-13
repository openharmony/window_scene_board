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
import fileUri from '@ohos.file.fileuri';
import {
  TARGET_AOD,
  TARGET_FONT,
  TARGET_HOME,
  TARGET_ICONS,
  TARGET_LOCK,
  TARGET_SKIN,
  TargetType,
  TConfigArg,
  ThemeInfo,
  ThemeOptions
} from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, StringUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { TsEventProvider } from '../../TsEventProvider';
import { ThemePackageInstaller } from './installer/ThemePackgeInstaller';
import { ActivatedThemeUtil } from '../../../util/ActivatedThemeUtil';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = `ApplyConfigExecutor`;
/**
 * 锁屏时钟修改配置文件
 */
const LOCK_CLOCK_CONFIG_FILENAME: string = 'config.json';

export class ApplyConfigExecutor {
  private readonly themeInfo: ThemeInfo;

  constructor(themeInfo: ThemeInfo) {
    this.themeInfo = themeInfo;
  }

  async setCurrentThemeCfg(tConfigArgs: TConfigArg[], activated: boolean = true): Promise<boolean> {
    if (TsLog.isDebug(TAG)) {
      TsLog.debug(TAG, `setCurrentThemeCfg tConfigArgs:${JsonUtils.stringify(tConfigArgs)}`);
    }
    let successTargets: TargetType[] = [];
    for (const arg of tConfigArgs) {
      if (await this.writeCfgAndCopyResource(arg)) {
        successTargets.push(arg.target);
      } else {
        TsLog.warning(TAG, `setCurrentThemeCfg target:${arg.target},qualifier:${arg.qualifier},fileName:${arg.fileName},
        value:${arg.value} write fail.`);
      }
    }
    TsLog.debug(TAG, `setCurrentThemeCfg write success`);
    if (!activated) {
      TsLog.info(TAG, `config not activated`);
      return true;
    }
    // 过滤只有锁屏时钟使能场景
    this.filterConfig(tConfigArgs);
    let ret: number =
      await new ThemePackageInstaller(this.themeInfo).activateThemeOpt(this.toOptions(successTargets));
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `config not activated`);
      const error: BusinessError<string> = { name: `error`, message: `set current theme config failed`, code: ret }
      return Promise.reject(error);
    }
    ActivatedThemeUtil.notifyApplyTheme();
    return true;
  }

  async writeCfgAndCopyResource(tConfigArgs: TConfigArg): Promise<boolean> {
    let customPath: string = TSPathUtils.getThemeCustomPackagePath(this.themeInfo);
    FileUtil.createDirRecur(customPath);
    const filePath: string =
      StringUtils.join('/', [customPath, tConfigArgs.target, tConfigArgs.qualifier, tConfigArgs.fileName]);
    TsLog.debug(TAG, `writeCfg fileName:${FileUtil.getFileName(filePath)}`);
    try {
      const uriPath: string = fileUri.getUriFromPath(filePath);
      const normalizePath: string = new fileUri.FileUri(uriPath).normalize().path;
      if (!normalizePath.startsWith(customPath)) {
        return false;
      }
    } catch (error) {
      TsLog.info(TAG, `write config fail msg:${error.code},code:${error.code}`);
    }
    let copyResult: boolean = true;
    if (tConfigArgs.originPath) {
      const customTargetPath: string = StringUtils.join('/',
        [customPath, tConfigArgs.target, tConfigArgs.qualifier, FileUtil.getFileName(tConfigArgs.originPath)]);
      copyResult = await FileUtil.copyFileAsync(tConfigArgs.originPath, customTargetPath);
    }
    return FileUtil.writeFileSync(filePath, tConfigArgs.value) && copyResult;
  }

  private toOptions(targets: TargetType[]): ThemeOptions {
    let map: Map<TargetType, (themeOptions: ThemeOptions) => void> = new Map()
    map.set(TARGET_HOME, (themeOptions) => themeOptions.enableHome());
    map.set(TARGET_FONT, (themeOptions) => themeOptions.enableFont());
    map.set(TARGET_LOCK, (themeOptions) => themeOptions.enableLock());
    map.set(TARGET_AOD, (themeOptions) => themeOptions.enableAod());
    map.set(TARGET_ICONS, (themeOptions) => themeOptions.enableIcons());
    map.set(TARGET_SKIN, (themeOptions) => themeOptions.enableSkin());

    let themeOption: ThemeOptions = new ThemeOptions();

    for (const target of targets) {
      let enableAction: Nullable<(themeOptions: ThemeOptions) => void> = map.get(target);
      if (enableAction) {
        enableAction(themeOption);
      } else {
        TsLog.warning(TAG, `${target} cannot enable the AB directory.`);
      }
    }
    if (themeOption.lock === ThemeOptions.ENABLE) {
      themeOption.enableLockConfig();
    }
    return themeOption;
  }

  /**
   * 过滤主题使能配置文件，处理特殊场景
   *
   * @param tConfigArgs
   */
  private filterConfig(tConfigArgs: TConfigArg[]): void {
    // 过滤只是锁屏时钟使能场景（无壁纸修改）
    const filteredArgs: TConfigArg[] = tConfigArgs.filter(
      arg => arg.target === TARGET_LOCK && arg.fileName === LOCK_CLOCK_CONFIG_FILENAME);
    if (filteredArgs.length >= 1) {
      TsLog.info(TAG, `apply custom config only locl clock`);
      TsEventProvider.getInstance().setOnlyClockActive(true);
    }
  }
}