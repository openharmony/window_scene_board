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

// import theme from '@ohos.theme.themeManager';
import { HashMap } from '@kit.ArkTS';
import { BusinessError, settings } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import ArrayList from '@ohos.util.ArrayList';
import zlib from '@ohos.zlib';
import { ActivatedThemeUtil } from '../../../../util/ActivatedThemeUtil';
import {
  ActivateEventData,
  EventId,
  TARGET_LOCK,
  TARGET_SKIN,
  TARGET_SUB_SCREEN,
  ThemeInfo,
  ThemeOptions,
  ThemePackInfo
} from '@ohos/themeservice_inner_api';
import {
  EventEmitter,
  FileUtil,
  JsonUtils,
  NullableType,
  ObjectUtils,
  StringUtils,
  TsLog
} from '@ohos/themeservicebase';
import { DeviceHelper } from '../../../../util/DeviceHelper';
import { ActivateThemeErrType, HiSysEventUtils } from '../../../../util/HiSysEventUtils';
import { RecordCustomUtil } from '../../../../util/RecordCustomUtil';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { globalPersistService } from '../../GlobalPersistServiceImpl';
import { themeTrialService } from '../../ThemeTrialServiceImpl';
import { AbsResourceInstaller } from './AbsResourceInstaller';
import { AodInstaller } from './AodInstaller';
import { ExtResourceInstaller } from './ExtResourceInstaller';
import { FontInstaller } from './FontInstaller';
import { IconsInstaller } from './IconsInstaller';
import { LongTakeInstaller } from './LongTakeInstaller';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';
import { SkinInstaller } from './SkinInstaller';
import { SubScreenInstaller } from './SubScreenInstaller';
import { WallPaperInstaller } from './WallPaperInstaller';
import { statfs } from '@kit.CoreFileKit';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

const TAG: string = 'ThemePackageInstaller';
const FACE_RECOGNIZE_UNLOCK: string = 'face_recognize_unlock';
const FACE_RECOGNIZE_SLIDE_UNLOCK: string = 'face_recognize_slide_unlock';
const LIMIT_SIZE: number = 500 * 1024 * 1024;

export class ThemePackageInstaller extends AbsResourceInstaller {
  private themeExtendResources: Array<string> = ['preview', 'personalize', 'description.json', 'i18n'];

  private subActivateResource: Array<string> =
    ['home', 'lock', 'icons', 'fonts', 'skin', 'fa', 'aod', 'sub_screen', 'unlock', 'long_take'];

  private checkFailResource: string[] = ['icons', 'home', 'aod'];

  private subActivateInstallerMap: HashMap<string, AbsResourceInstaller> = new HashMap();

  private enableOptionsMap: HashMap<string, (option: Nullable<ThemeOptions>) => boolean> = new HashMap();

  private option: ThemeOptions | undefined = undefined;

  private enableAll: boolean = false;

  private enableInnerScreenOnly: boolean = false;

  private activateTime: number = 0;

  private tPackageOption: zlib.Options = {
    level: zlib.CompressLevel.COMPRESS_LEVEL_BEST_SPEED,
    memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
    strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
  };

  constructor(themeInfo: ThemeInfo) {
    super('', themeInfo);
    this.subActivateInstallerMap.set('home', new WallPaperInstaller('home', themeInfo));
    this.subActivateInstallerMap.set('lock', new WallPaperInstaller('lock', themeInfo));
    this.subActivateInstallerMap.set('icons', new IconsInstaller(themeInfo));
    this.subActivateInstallerMap.set('fonts', new FontInstaller(themeInfo));
    this.subActivateInstallerMap.set('skin', new SkinInstaller(themeInfo));
    this.subActivateInstallerMap.set('fa', new ResourceBasicInstaller('fa', themeInfo));
    this.subActivateInstallerMap.set('aod', new AodInstaller(themeInfo));
    this.subActivateInstallerMap.set('sub_screen', new SubScreenInstaller(themeInfo));
    this.subActivateInstallerMap.set('unlock', new WallPaperInstaller('unlock', themeInfo));
    this.subActivateInstallerMap.set('long_take', new LongTakeInstaller(themeInfo));

    this.enableOptionsMap.set('home', (option: ThemeOptions) => {
      return option?.home === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('lock', (option: ThemeOptions) => {
      return option?.lock === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('icons', (option: ThemeOptions) => {
      return option?.icons === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('fonts', (option: ThemeOptions) => {
      return option?.fonts === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('skin', (option: ThemeOptions) => {
      return option?.skin === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('aod', (option: ThemeOptions) => {
      return option?.aod === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('fa', (option: ThemeOptions) => {
      return option?.fa === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('sub_screen', (option: ThemeOptions) => {
      return option?.sub_screen === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('unlock', (option: ThemeOptions) => {
      return option?.lock === ThemeOptions.ENABLE;
    });
    this.enableOptionsMap.set('long_take', (option: ThemeOptions) => {
      return option?.long_take === ThemeOptions.ENABLE;
    });
  }

  public async activateThemeOpt(option?: ThemeOptions, innerScreenOnly: boolean = false,
    apply: boolean = true): Promise<number> {
    TsLog.info(TAG, `activateThemeOpt`);
    if (await FileUtil.rmdirAsync(TSPathUtils.getTsPackagedPath())) {
      TsLog.info(TAG, 'activateThemeOpt, clean tmp path');
    }
    this.option = option;
    this.enableInnerScreenOnly = innerScreenOnly;
    let prepareRet: boolean = await this.prepare();
    if (!prepareRet) {
      TsLog.warning(TAG, `activateThemeOpt prepare fail`);
      return RemoteCode.ERR_ILLEGAL_FORMAT;
    }
    await this.install();
    let activateRet: number = RemoteCode.ERR_UNKNOWN;
    try {
      activateRet = await this.applyToSystemAbility();
      await this.clearGlobalPersistData(option);
      TsLog.info(TAG, `activateTheme success`);
    } catch (err) {
      TsLog.info(TAG, 'applyTheme error,' + err);
    } finally {
      RecordCustomUtil.recordCustomFilesName(activateRet === RemoteCode.SUCCESS, this.getThemeInfo());
      await this.cleanIfNeeded();
      await this.cleanTrialCache(option);
      this.applyFaceRecognizeSlideUnlock(activateRet === RemoteCode.SUCCESS);
      this.notify(activateRet === RemoteCode.SUCCESS, apply);
      this.reportEvent(activateRet);
    }
    return activateRet;
  }

  private async reportEvent(activateRet: number): Promise<void> {
    HiSysEventUtils.reportDataSize();
    if (activateRet === RemoteCode.SUCCESS) {
      HiSysEventUtils.reportApplyTheme(this.getThemeInfo().id);
    }
  }

  private notify(activateRet: boolean, apply: boolean) {
    if (!activateRet) {
      return;
    }
    const activateEventData: ActivateEventData = {
      id: this.getThemeInfo().id,
      editorId: this.getThemeInfo().editorId,
      fullActivate: this.enableAll,
      path: this.getThemeInfo().originThemePack?.srcPath,
      home: this.option?.home === ThemeOptions.ENABLE,
      lock: this.option?.lock === ThemeOptions.ENABLE,
      aod: this.option?.aod === ThemeOptions.ENABLE,
      icons: this.option?.icons === ThemeOptions.ENABLE,
      skin: this.option?.skin === ThemeOptions.ENABLE,
      sub_screen: this.option?.sub_screen === ThemeOptions.ENABLE,
      fa: this.option?.fa === ThemeOptions.ENABLE,
      customPath: TSPathUtils.getThemeCustomPackagePath(this.getThemeInfo().editorId),
      apply: apply,
      lockConfig: this.option?.lockConfig === ThemeOptions.ENABLE,
    }
    EventEmitter.emit(EventId.EVENT_ACTIVATE_THEME, activateEventData);
  }

  private async applyFaceRecognizeSlideUnlock(activateRet: boolean): Promise<void> {
    try {
      let state: string =
        settings.getValueSync(getContext(), FACE_RECOGNIZE_UNLOCK, '-1', settings.domainName.USER_SECURITY);
      let interactive: Nullable<string[]> = this.getThemeInfo().interactive;
      if (!interactive) {
        let description: Nullable<string> = JsonUtils.parse(this.getThemeInfo().originThemePack?.description ?? '');
        interactive = description ? description['interactive'] : interactive;
      }
      if (activateRet && state === '1' && interactive?.includes('lock') && this.enableAll) {
        let result = settings.setValueSync(getContext(), FACE_RECOGNIZE_UNLOCK, '0',
          settings.domainName.USER_SECURITY);
        let enableResult = settings.setValueSync(getContext(), FACE_RECOGNIZE_SLIDE_UNLOCK, '1',
          settings.domainName.USER_SECURITY);
        TsLog.info(TAG, `applyFaceRecognizeSlideUnlock result1: ${result}, result2: ${enableResult}`);
      }
    } catch (err) {
      TsLog.info(TAG, 'applyFaceRecognizeSlideUnlock error,' + err);
    }
  }

  private async applyToSystemAbility(): Promise<number> {
    let code: number = RemoteCode.SUCCESS;
    code = await this.queryFreeSize();
    if (code !== RemoteCode.SUCCESS) {
      TsLog.info(TAG, `applyToSystemAbility failed, code: ${code}`);
      return code;
    }
    let activateErr: BusinessError = {
      code: 0,
      name: '',
      message: '',
    };
    try {
      await this.activateWithShare();
      return code;
    } catch (err) {
      TsLog.info(TAG, `activateShare error: ${err}`);
      try {
        await this.activateWithPackage();
        return code;
      } catch (errorInfo) {
        TsLog.info(TAG, `activateWithPackage errorInfo: ${errorInfo}`);
        code = (err as BusinessError<string>)?.code;
      }
      activateErr = err
    } finally {
      let themeInfo: ThemeInfo = this.getThemeInfo();
      let origin: string = themeInfo.originThemePack?.origin ?? ``;
      if (code !== RemoteCode.SUCCESS) {
        HiSysEventUtils.reportActivateTheme(themeInfo.id, origin,
          ActivateThemeErrType.ACTIVATE_FAIL, activateErr.code.toString());
      }

      let duration: number = Date.now() - this.activateTime;
      if (duration > 1000) { // 超过1S返回，打点
        HiSysEventUtils.reportActivateDuration(themeInfo.id, origin,
          this.activateTime.toString(), duration.toString(),
          code === RemoteCode.SUCCESS ? 0 : 1);
      }
    }
    return code === undefined ? RemoteCode.ERR_UNKNOWN : code;
  }

  private async queryFreeSize(): Promise<number> {
    let shareFreeSize: number = Number.MIN_VALUE;
    let tsFreeSize: number = Number.MIN_VALUE;
    try {
      shareFreeSize = await statfs.getFreeSize(TSPathUtils.themeSharePath);
      tsFreeSize = await statfs.getFreeSize(TSPathUtils.getTsRootPath());
    } catch (error) {
      TsLog.info(TAG, 'queryFreeSize failed,' + error);
      let code: number = (error as BusinessError<string>)?.code;
      return code === undefined ? RemoteCode.ERR_UNKNOWN : code;
    }
    if (shareFreeSize > LIMIT_SIZE && tsFreeSize > LIMIT_SIZE) {
      return RemoteCode.SUCCESS;
    }
    return RemoteCode.ERR_LACK_STORAGE;
  }

  private async prepare(): Promise<boolean> {
    if (!this.option || this.enableInnerScreenOnly) {
      this.option = new ThemeOptions();
      this.option.home = ThemeOptions.ENABLE;
      this.option.lock = ThemeOptions.ENABLE;
      this.option.icons = ThemeOptions.ENABLE;
      this.option.aod = ThemeOptions.ENABLE;
      this.option.skin = ThemeOptions.ENABLE;
      this.option.fonts = ThemeOptions.ENABLE;
      this.option.fa = ThemeOptions.ENABLE;
      this.option.long_take = ThemeOptions.ENABLE;
      if (DeviceHelper.isSmallFoldProduct() && !this.enableInnerScreenOnly) {
        this.option.sub_screen = ThemeOptions.ENABLE;
      }
      this.enableAll = true;
      TsLog.info(TAG, `Activate theme all`);
      // 应用完整主题包需要校验主题包格式
      if (this.enableAll && !this.checkPackageValid(this.getThemeInfo())) {
        TsLog.info(TAG, `Activate full theme package format invalid`);
        return false;
      }
    }
    // 准备主题包整合资源目录
    FileUtil.createDirRecur(this.getThemeTypePackagedPath());
    return true;
  }

  private checkPackageValid(themeInfo: ThemeInfo): boolean {
    if (ObjectUtils.isNull(themeInfo)) {
      return false;
    }
    if (StringUtils.isEmpty(themeInfo.id)) {
      TsLog.warning(TAG, 'theme id empty');
      return false;
    }
    const originThemePath: NullableType<string> = themeInfo.originThemePack?.srcPath;
    if (!FileUtil.isFileExists(originThemePath)) {
      const themePack: NullableType<ThemePackInfo> = themeInfo.originThemePack;
      TsLog.warning(TAG, `theme lost,type:${themePack?.origin},name:${FileUtil.getFileName(originThemePath)}`);
      return false;
    }
    return true;
  }

  async install(): Promise<boolean> {
    let resourceList: ArrayList<AbsResourceInstaller> = this.createResourceInstaller();
    let failRes: string [] = [];
    for (let index = 0; index < resourceList.length; index++) {
      let installRet: boolean = false;
      const resourceInstaller: AbsResourceInstaller = resourceList[index];
      try {
        installRet = await resourceInstaller.install();
      } catch (e) {
        TsLog.error(TAG, `install error:` + e);
      }
      if (!installRet && this.checkFailResource.includes(resourceInstaller.getThemeType())) {
        failRes.push(resourceInstaller.getThemeType());
      }
    }
    let isInstallSuccess: boolean = failRes.length === 0;
    if (!isInstallSuccess) {
      let themeInfo: ThemeInfo = this.getThemeInfo();
      let origin: string = themeInfo.originThemePack?.origin ?? '';
      HiSysEventUtils.reportActivateTheme(themeInfo.id, origin, ActivateThemeErrType.COPY_FAIL,
        JsonUtils.stringify(failRes));
    }
    return isInstallSuccess;
  }

  private async activateWithPackage(): Promise<void> {
    TsLog.info(TAG, `activateWithPackage`);
    await zlib.compressFile(TSPathUtils.getTsPackagedPath(), `${TSPathUtils.getTsRootPath()}${'/theme.zip'}`,
      this.tPackageOption);
    await FileUtil.renameAsync(`${TSPathUtils.getTsRootPath()}${'/theme.zip'}`,
      `${TSPathUtils.getTsRootPath()}${'/theme.hwt'}`);
    let activateParam: string = '';
    if (!this.enableAll && this.option) {
      try {
        activateParam = JSON.stringify(this.option);
      } catch (error) {
        TsLog.warning(TAG, `activateWithPackage error`);
      }
    }
    // return theme.activateTheme(`${TSPathUtils.getTsRootPath()}${'/theme.hwt'}`, activateParam);
  }

  private async activateWithShare(): Promise<void> {
    TsLog.info(TAG, `activateWithShare`);
    const activateShare: string = `/data/themes/s`;
    const shareActivationPath: string = `/data/themes/s/activation`;
    if (!FileUtil.isFileExists(shareActivationPath)) {
      FileUtil.createDirRecur(shareActivationPath);
    }
    await FileUtil.trimDirAsync(shareActivationPath);
    await FileUtil.copyDirAsync(`${TSPathUtils.getTsPackagedPath()}/` ?? '', shareActivationPath);
    TSPathUtils.printFileNameByPath(shareActivationPath, this.option);
    await this.copyOtherResource(shareActivationPath);
    let activateParam: string = '';
    if (!this.enableAll && this.option) {
      try {
        activateParam = JSON.stringify(this.option);
      } catch (error) {
        TsLog.warning(TAG, `activateWithShare option fail`);
      }
    }
    this.activateTime = Date.now();
    // return theme.activateTheme(activateShare, activateParam);
  }

  private async copyOtherResource(shareActivationPath: string): Promise<void> {
    if (!this.enableInnerScreenOnly) {
      return;
    }
    let subScreenPath = ActivatedThemeUtil.getActivateResPath('sub_screen');
    if (FileUtil.isFileExists(subScreenPath)) {
      TsLog.info(TAG, `copyOtherResource subScreenPath`);
      await FileUtil.copyDirAsync(subScreenPath ?? '', shareActivationPath)
    }
  }

  private async cleanIfNeeded(): Promise<void> {
    TsLog.info(TAG, `clean tmp resource`);
    if (FileUtil.isFileExists(TSPathUtils.getTsPackagedPath())) {
      await fs.rmdir(TSPathUtils.getTsPackagedPath());
    }
    if (FileUtil.isFileExists(`${TSPathUtils.getTsRootPath()}${'/theme.hwt'}`)) {
      await fs.unlink(`${TSPathUtils.getTsRootPath()}${'/theme.hwt'}`);
    }
    let result = await FileUtil.trimDirAsync(`/data/themes/s/activation`);
    if (!result) {
      TsLog.warning(TAG, `cleanIfNeeded trimDirAsync error.`);
    }
  }

  /**
   * 使能主题/字体，清除之前试用缓存信息
   * @param option
   */
  private async cleanTrialCache(option?: ThemeOptions): Promise<void> {
    if (option) {
      if (option.fonts === ThemeOptions.ENABLE) {
        // 使能字体，清除之前试用字体缓存
        TsLog.info(TAG, `clean trial font cache`);
        await themeTrialService().stopTrialTheme('font')
      }
    } else {
      // 使能主题，清除之前试用主题缓存
      TsLog.info(TAG, `clean trial theme cache`);
      await themeTrialService().stopTrialTheme('theme')
    }
  }

  private createResourceInstaller(): ArrayList<AbsResourceInstaller> {
    let resourceList: ArrayList<AbsResourceInstaller> = new ArrayList();
    this.subActivateResource.forEach((subRes: string) => {
      let enableOpt: Nullable<(themeOption: Nullable<ThemeOptions>) => boolean> = this.enableOptionsMap.get(subRes);
      if (enableOpt && enableOpt(this.option)) {
        resourceList.add(this.subActivateInstallerMap.get(subRes));
      }
    });
    if (this.enableAll) {
      this.themeExtendResources.forEach((resourceType: string) => {
        resourceList.add(new ExtResourceInstaller(resourceType, this.getThemeInfo()));
      });
    }
    return resourceList;
  }

  /**
   * 使能资源切换
   * @param contentType 需要切换的资源名
   * @param style 切换的风格
   * @returns 是否切换成功
   */
  async activateStyle(contentType: string[], style: string): Promise<number> {
    TsLog.info(TAG, `activateStyle`);
    let resourceMap: HashMap<string, ResourceBasicInstaller> = this.createStyleResInstaller(contentType);
    let option: ThemeOptions = new ThemeOptions();
    let needActivate: boolean = false;
    for (let pair of resourceMap) {
      let installer: ResourceBasicInstaller = pair[1];
      let res: boolean = await installer.installExtension(style);
      if (!res) {
        TsLog.warning(TAG, `install fail, type = ${pair[0]}, style = ${style}`);
      } else {
        needActivate = true;
        this.string2Options(option, pair[0]);
      }
    }
    if (!needActivate) {
      TsLog.warning(TAG, `no need activate style`);
      this.cleanIfNeeded();
      return RemoteCode.ERR_UNKNOWN;
    }
    this.option = option;
    this.option.disableContentSwitch();
    let activateRet: number = RemoteCode.ERR_UNKNOWN;
    try {
      activateRet = await this.applyToSystemAbility();
      TsLog.info(TAG, `activateStyle success`);
    } catch (err) {
      TsLog.info(TAG, 'activateStyle error,' + err);
    } finally {
      this.cleanIfNeeded();
    }
    return activateRet;
  }

  private string2Options(option: ThemeOptions, type: string): void {
    switch (type) {
      case 'home':
        option.enableHome();
        break;
      case 'lock':
        option.enableLock();
        break;
      case 'aod':
        option.enableAod();
        break;
      case 'icons':
        option.enableIcons();
        break;
      case 'skin':
        option.enableSkin();
        break;
      case 'fonts':
        option.enableFont();
        break;
      case 'fa':
        option.enableFa();
        break;
      case 'long_take':
        option.enableLongTake();
        break;
      case 'sub_screen':
        option.enableSubScreen();
        break;
      default:
        break;
    }
    TsLog.info(TAG, `stringToOptions, type = ${type}`);
  }

  private createStyleResInstaller(contentType: string[]): HashMap<string, ResourceBasicInstaller> {
    let resourceMap: HashMap<string, ResourceBasicInstaller> = new HashMap();
    contentType.forEach((type) => {
      let installer: AbsResourceInstaller | undefined = this.subActivateInstallerMap.get(type);
      if (installer instanceof ResourceBasicInstaller) {
        resourceMap.set(type, installer);
      }
      if (type === TARGET_SKIN && DeviceHelper.isSmallFoldProduct()) {
        let installer: AbsResourceInstaller | undefined = this.subActivateInstallerMap.get(TARGET_SUB_SCREEN);
        if (installer instanceof ResourceBasicInstaller) {
          resourceMap.set(TARGET_SUB_SCREEN, installer);
        }
      }
    });
    return resourceMap;
  }

  private async clearGlobalPersistData(option?: ThemeOptions): Promise<void> {
    if (option) {
      // 该场景非切换主题，所以直接返回
      return;
    }
    TsLog.info(TAG, `clearGlobalPersistData`);
    return await globalPersistService.get().clearGlobalPersistData();
  }
}

