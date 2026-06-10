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
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { TARGET_SKIN, ThemeInfo, ThemeOptions } from '@ohos/themeservice_inner_api';
import { ActivatedThemeUtil } from '../../../util/ActivatedThemeUtil';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { ThemePackageInstaller } from './installer/ThemePackgeInstaller';
import { BusinessError } from '@kit.BasicServicesKit';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

const TAG: string = 'SetSkinExecutor';

export class SetSkinExecutor {
  private readonly themeInfo: ThemeInfo;

  constructor(themeInfo: ThemeInfo) {
    this.themeInfo = themeInfo;
  }

  async setSkin(skinPath: string, pkgNames: string[]): Promise<boolean> {
    TsLog.info(TAG, 'Set skin');
    let customPath: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}`;
    // 恢复pkg的skin到默认
    if (!skinPath) {
      return this.clearSkin(customPath, pkgNames);
    }
    // 替换部分pkg的skin
    return this.replaceSkin(skinPath, customPath, pkgNames);
  }

  private async clearSkin(customPath: string, pkgNames: string[]) {
    TsLog.warning(TAG, 'clearSkin');
    let skinCustomPath: string = `${customPath}/${TARGET_SKIN}`;
    let activatedSkins: string = `${ActivatedThemeUtil.getActivatedThemePath()}${'app/'}${TARGET_SKIN}`;
    if (!FileUtil.isFileExists(activatedSkins)) {
      activatedSkins = `${ActivatedThemeUtil.getActivatedThemePath()}${TARGET_SKIN}`;
    }
    if (!FileUtil.isFileExists(activatedSkins)) {
      return true;
    }
    await FileUtil.deleteAsync(skinCustomPath);
    if (!await FileUtil.copyDirAsync(activatedSkins, `${customPath}`)) {
      TsLog.warning(TAG, 'clear skin fail');
      await FileUtil.deleteAsync(skinCustomPath);
      const error: BusinessError<string> = { name: `error`, message: `clear skin fail`, code: RemoteCode.ERR_COPY_FAILED };
      return Promise.reject(error);
    }
    for (let pkgName of pkgNames) {
      await FileUtil.deleteAsync(`${skinCustomPath}/${pkgName}`);
    }
    const ret: number = await new ThemePackageInstaller(this.themeInfo)
      .activateThemeOpt(new ThemeOptions().enableSkin());
    TsLog.info(TAG, `Set skin ret:${ret}`);
    await FileUtil.deleteAsync(skinCustomPath);
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `clear skin failed`);
      const error: BusinessError<string> = { name: `error`, message: `clear skin failed`, code: ret }
      return Promise.reject(error);
    }
    return true;
  }

  private async replaceSkin(skinPath: string, customPath: string, pkgNames: string[]) {
    TsLog.warning(TAG, 'replaceSkin');
    const skinCustomPath = `${customPath}/${TARGET_SKIN}`;
    await FileUtil.deleteAsync(skinCustomPath);
    let activatedSkins: string = `${ActivatedThemeUtil.getActivatedThemePath()}${'app/'}${TARGET_SKIN}`;
    if (!FileUtil.isFileExists(activatedSkins)) {
      activatedSkins = `${ActivatedThemeUtil.getActivatedThemePath()}${TARGET_SKIN}`;
    }
    if (FileUtil.isFileExists(activatedSkins)) {
      const copyRet = await FileUtil.copyDirAsync(activatedSkins, customPath);
      if (!copyRet) {
        TsLog.info(TAG, 'copyDirAsync activatedSkins err');
        await FileUtil.deleteAsync(skinCustomPath);
        const error: BusinessError<string> = { name: `error`, message: `copyDirAsync activatedSkins err`, code: RemoteCode.ERR_COPY_FAILED };
        return Promise.reject(error);
      }
    } else {
      // 没有skin目录，需要构造一个description.json
      this.initDescription(skinPath, skinCustomPath);
    }
    for (let pkgName of pkgNames) {
      if (FileUtil.isFileExists(`${skinCustomPath}/${pkgName}`)) {
        await FileUtil.deleteAsync(`${skinCustomPath}/${pkgName}`);
      }
      let ret: boolean = await FileUtil.copyDirAsync(`${skinPath}/${TARGET_SKIN}/${pkgName}`, `${skinCustomPath}`);
      if (!ret) {
        await FileUtil.deleteAsync(skinCustomPath);
        TsLog.info(TAG, `replace skin fail, pkg: ${pkgName}`);
        await FileUtil.deleteAsync(skinCustomPath);
        const error: BusinessError<string> = { name: `error`, message: `replace skin fail, pkg: ${pkgName}`, code: RemoteCode.ERR_COPY_FAILED };
        return Promise.reject(error);
      }
      const replaceDescRet =
        FileUtil.copyFileSync(`${skinPath}/description.json`, `${skinCustomPath}/${pkgName}/description.json`);
      if (!replaceDescRet) {
        TsLog.info(TAG, `replace description fail, pkg: ${pkgName}`);
        await FileUtil.deleteAsync(skinCustomPath);
        const error: BusinessError<string> = { name: `error`, message: `replace description fail, pkg: ${pkgName}`, code: RemoteCode.ERR_COPY_FAILED };
        return Promise.reject(error);
      }
    }
    const ret: number = await new ThemePackageInstaller(this.themeInfo)
      .activateThemeOpt(new ThemeOptions().enableSkin());
    TsLog.info(TAG, `Set skin ret:${ret}`);
    await FileUtil.deleteAsync(skinCustomPath);
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `replace skin failed`);
      const error: BusinessError<string> = { name: `error`, message: `replace skin failed`, code: ret };
      return Promise.reject(error);
    }
    return true;
  }

  private async initDescription(skinPath: string, skinCustomPath: string) {
    try {
      const descriptionContent = await FileUtil.readFileContent(`${skinPath}/description.json`);
      const description: object = JSON.parse(descriptionContent);
      // 主题id需要设置为空，因为setSkin只应用子资源
      description['id'] = '';
      FileUtil.writeFileSync(`${skinCustomPath}/description.json`, JsonUtils.stringify(description));
    } catch (err) {
      TsLog.warning(TAG, `initDescription err: ${err}`);
    }
  }
}


