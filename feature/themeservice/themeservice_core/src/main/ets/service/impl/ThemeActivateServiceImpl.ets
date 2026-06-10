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

import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import {
  OriginType,
  TARGET_AOD,
  TARGET_SUB_SCREEN,
  TARGET_HOME,
  TARGET_LOCK,
  TConfigArg,
  ThemeActivateApi,
  ThemeCode,
  ThemeInfo,
  ThemeOptions,
  ThemePackInfo,
  TServiceApi,
  WallPaperInfo,
  ActivateEventData,
  EventId
} from '@ohos/themeservice_inner_api/Index';
import {
  EventEmitter,
  FileUtil,
  JsonUtils,
  NullableType,
  StringUtils,
  TsLog
} from '@ohos/themeservicebase/Index';
import { PresetThemeExtCache } from '../../cache/PresetThemeCache';
import { ThemeCacheInfo, ThemeEditInfo } from '../../cache/ThemeInfoStoreCache';
import { getThemePackParser } from '../../preset/ThemePackParser';
import { TSPathUtils } from '../../util/TSPathUtils';
import { PathValidateUtil } from '../../validate/PathValidateUtil';
import { FontInfo } from '../model/FontInfo';
import { ApplyConfigExecutor } from './activate/ApplyConfigExecutor';
import { ApplyFontExecutor } from './activate/ApplyFontExecutor';
import { ApplyIconsExecutor } from './activate/ApplyIconsExecutor';
import { ThemePackageInstaller } from './activate/installer/ThemePackgeInstaller';
import { SetWallPaperExecutor } from './activate/SetWallPaperExecutor';
import { ThemeMixedExecutor } from './activate/ThemeMixedExecutor';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { themeTrialService } from './ThemeTrialServiceImpl';
import { EditThemeArg, From } from '@ohos/themeservice_inner_api/src/main/ets/model/EditThemeArg';
import { SetSkinExecutor } from './activate/SetSkinExecutor';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

const TAG: string = `ThemeActivateService`;

export class ThemeActivateServiceImpl implements ThemeActivateApi {
  static async createThemeInfo(themeDir: string, eid: string): Promise<ThemeInfo> {
    let themePackageInfo: ThemePackInfo = await getThemePackParser().parse(themeDir);
    let themeId: string = '';
    try {
      let id: object = JSON.parse(themePackageInfo?.description)['id'];
      themeId = typeof id === 'string' ? id : id?.toString();
    } catch (error) {
      TsLog.warning(TAG, `activate theme pkg format invalid`);
    }
    let themeInfo: ThemeInfo = new ThemeInfo(themeId, eid);
    themeInfo.originThemePack = themePackageInfo;
    return themeInfo;
  }

  async activateEditedTheme(editorId: string, option?: ThemeOptions | undefined,
    innerScreenOnly: boolean = false): Promise<boolean> {
    TsLog.info(TAG, `activateEditedTheme`);
    let themeInfo: NullableType<ThemeInfo> = await themeInfoService.get().getThemeByEditorId(editorId);
    if (!themeInfo) {
      TsLog.warning(TAG, `get Theme by editorId: ${editorId} error`);
      const error: BusinessError<string> =
        { name: `error`, message: `get Theme by editorId: ${editorId} error`, code: RemoteCode.ERR_THEME_INFO };
      return Promise.reject(error);
    }
    let ret: number = await new ThemePackageInstaller(themeInfo).activateThemeOpt(option, innerScreenOnly);
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `active edited theme failed`);
      const error: BusinessError<string> = { name: `error`, message: `active edited theme failed`, code: ret };
      return Promise.reject(error);
    }
    TsLog.info(TAG, `activate theme editorId: ${themeInfo.editorId} success`);

    // 如果仅应用外屏主题，这里不再更新内屏主题信息和缓存数据
    if (await this.whetherUpdateTheme(innerScreenOnly, option)) {
      await themeInfoService.get().applyTheme(themeInfo);
    }
    return true;
  }

  async saveThemeCustom(path: string, custom?: string, isUsable: boolean = true): Promise<string> {
    TsLog.info(TAG, `saveThemeCustom`);
    let formatPath = '';
    let formatCustomPath = '';
    try {
      formatPath = await this.validatePath(path, 'saveThemeCustom');
      if (custom && !StringUtils.isEmpty(custom)) {
        formatCustomPath = await this.validatePath(custom, 'saveThemeCustom');
      }
    } catch (err) {
      TsLog.info(TAG, `saveThemeCustom error`);
      return Promise.reject(err);
    }
    // 如果传入的custom为空，查找画廊里是否有未编辑过的当前主题，不再生成新的主题
    let themeCacheInfoList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (themeCacheInfoList && !FileUtil.isFileExists(formatCustomPath)) {
      const themeId: string = await this.getThemeId(formatPath);
      let themeInfo: Nullable<ThemeCacheInfo> = themeCacheInfoList.find(theme => theme?.id === themeId &&
        !this.isEditedTheme(theme.editorId));
      if (themeInfo) {
        themeInfo.isUsable = isUsable;
        return themeInfo.editorId;
      }
    }
    let eid: string = systemDateTime.getTime(true).toString();
    const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(formatPath, eid);
    themeInfo.isUsable = isUsable;
    await this.prepareCustom(formatPath, themeInfo, new ThemeApplyScope().enableOther(), formatCustomPath);
    await themeInfoService.get().applyTheme(themeInfo, new Map(), true, false);
    return themeInfo.editorId;
  }

  async activateThemeCustom(path: string, custom?: string, option?: ThemeOptions, apply?: boolean,
    innerScreenOnly: boolean = false): Promise<boolean> {
    TsLog.info(TAG, `activateThemeCustom`);
    let formatPath = '';
    let formatCustomPath = '';
    try {
      formatPath = await this.validatePath(path, 'activateThemeCustom');
      if (custom && !StringUtils.isEmpty(custom)) {
        formatCustomPath = await this.validatePath(custom, 'activateThemeCustom');
      }
    } catch (err) {
      TsLog.info(TAG, `activateThemeCustom error`);
      return Promise.reject(err);
    }
    TSPathUtils.printFileNameByPath(formatCustomPath, option);
    let pathConfig = new PathConfiguration();
    pathConfig.setOriginPath(formatPath);
    pathConfig.setCustomPath(formatCustomPath);
    let result: number = await this.activateThemeWrapper(pathConfig, option, apply, innerScreenOnly);
    if (result !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `active custom theme failed`);
      const error: BusinessError<string> = { name: `error`, message: `active custom theme failed`, code: result };
      return Promise.reject(error);
    }
    return true;
  }

  async editTheme(editArg: EditThemeArg, innerScreenOnly: boolean = false): Promise<boolean> {
    let themeInfo: NullableType<ThemeInfo> = await themeInfoService.get().getThemeByEditorId(editArg.editorId);
    if (!themeInfo) {
      TsLog.warning(TAG, `editTheme by editorId: ${editArg.editorId} error, No theme record.`);
      const error: BusinessError<string> = {
        name: `error`,
        message: `editTheme by editorId: ${editArg.editorId} error, No theme record`,
        code: RemoteCode.ERR_THEME_INFO
      };
      return Promise.reject(error);
    }
    TSPathUtils.printFileNameByPath(editArg.customPath, editArg.option);
    TsLog.info(TAG, `editTheme editorId: ${themeInfo.editorId} start`);
    if (!StringUtils.isEmpty(editArg.customPath)) {
      if (themeInfo.originThemePack?.srcPath) {
        let themeApplyScope: ThemeApplyScope = await this.getThemeApplyScope(innerScreenOnly, editArg.option);
        await this.prepareCustom(themeInfo.originThemePack.srcPath, themeInfo, themeApplyScope, editArg.customPath);
      }
      if (!editArg.activate) {
        TsLog.info(TAG, `No Active theme:${themeInfo.editorId}`);
        if (await this.whetherUpdateTheme(innerScreenOnly, editArg.option)) {
          themeInfo.isUsable = editArg.isUsable;
          await themeInfoService.get().applyTheme(themeInfo, new Map(), true, false);
        }
        this.notifySaveTheme(themeInfo, editArg.option);
        return true;
      }
    }
    let result: number = await new ThemePackageInstaller(themeInfo).activateThemeOpt(editArg.option, innerScreenOnly);
    if (result !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `active edited theme failed`);
      const error: BusinessError<string> = { name: `error`, message: `edit theme failed`, code: result };
      return Promise.reject(error);
    }
    TsLog.info(TAG, `editTheme editorId: ${themeInfo.editorId} success`);

    // 如果仅应用外屏主题，这里不再更新内屏主题信息和缓存数据
    if (await this.whetherUpdateTheme(innerScreenOnly, editArg.option)) {
      themeInfo.isUsable = editArg.isUsable;
      await themeInfoService.get().applyTheme(themeInfo);
    }
    return true;
  }

  async notifySaveTheme(themeInfo: ThemeInfo, option?: ThemeOptions): Promise<void> {
    const activateEventData: ActivateEventData = {
      id: themeInfo.id,
      editorId: themeInfo.editorId,
      fullActivate: option === undefined,
      path: themeInfo.originThemePack?.srcPath,
      sub_screen: option?.sub_screen === ThemeOptions.ENABLE,
      customPath: themeInfo.customThemePack?.srcPath,
      apply: false
    }
    TsLog.info(TAG, 'notify save theme');
    EventEmitter.emit(EventId.EVENT_SAVE_THEME, activateEventData);
  }

  async getThemeApplyScope(innerScreenOnly: boolean, option?: ThemeOptions): Promise<ThemeApplyScope> {
    let themeApplyScope: ThemeApplyScope = new ThemeApplyScope();
    if (innerScreenOnly) {
      themeApplyScope.enableInnerScreen();
      return themeApplyScope;
    }
    if (option && option.sub_screen === ThemeOptions.ENABLE) {
      let optionStr: string | undefined = JsonUtils.stringify(option)
      if (optionStr) {
        // 如果是2，表示optionStr的值是{‘sub_screen’：'1'}, 表示仅sub_screen被赋值，是仅应用外屏场景
        optionStr.split(':').length === 2 ? themeApplyScope.enableSubScreen() : themeApplyScope.enableOther();
      }
      return themeApplyScope;
    }
    themeApplyScope.enableOther();
    return themeApplyScope;
  }

  async activateTheme(path: string, option?: ThemeOptions, apply?: boolean,
    innerScreenOnly: boolean = false): Promise<boolean> {
    TsLog.info(TAG, `activateTheme`);
    let formatPath = '';
    try {
      formatPath = await this.validatePath(path, 'activateTheme');
    } catch (err) {
      return Promise.reject(err);
    }
    TSPathUtils.printFileNameByPath(formatPath, option);
    let pathConfig = new PathConfiguration();
    pathConfig.setOriginPath(formatPath);
    let result: number = await this.activateThemeWrapper(pathConfig, option, apply, innerScreenOnly);
    if (result !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `activate theme failed`);
      const error: BusinessError<string> = { name: `error`, message: `activate theme failed`, code: result };
      return Promise.reject(error);
    }
    return true;
  }

  private isEditedTheme(editorId: string): boolean {
    const custom: string = TSPathUtils.getThemeCustomPackagePath(editorId);
    if (!FileUtil.isFileExists(custom)) {
      return false;
    }
    const isAodEdited: boolean = FileUtil.isFileExists(`${custom}/${TARGET_AOD}`);
    if (isAodEdited) {
      TsLog.info(TAG, `theme has edited custom aod, editorId:${editorId}`);
      return true;
    }
    const isLockEdited: boolean = FileUtil.isFileExists(`${custom}/${TARGET_LOCK}`);
    if (isLockEdited) {
      TsLog.info(TAG, `theme has edited custom lock, editorId:${editorId}`);
      return true;
    }
    const isHomeEdited: boolean = FileUtil.isFileExists(`${custom}/${TARGET_HOME}`);
    if (isHomeEdited) {
      TsLog.info(TAG, `theme has edited custom home, editorId:${editorId}`);
      return true;
    }
    const isSubScreenEdited: boolean = FileUtil.isFileExists(`${custom}/${TARGET_SUB_SCREEN}`);
    if (isSubScreenEdited) {
      TsLog.info(TAG, `theme has edited custom sub_screen, editorId:${editorId}`);
      return true;
    }
    return false;
  }

  private async getThemeId(themeDir: string): Promise<string> {
    let themeId: string = '';
    let description: string = '';
    try {
      description = await FileUtil.readFileContent(`${themeDir}/description.json`);
    } catch (e) {
      TsLog.error(TAG, `parse themePath`, e);
      return themeId;
    }
    if (StringUtils.isEmpty(description)) {
      TsLog.warning(TAG, `getThemeId error`);
      return themeId;
    }
    try {
      let id: object = JSON.parse(description)['id'];
      themeId = typeof id === 'string' ? id : id?.toString();
    } catch (error) {
      TsLog.warning(TAG, `find first unEdited theme, pkg format invalid`);
    }
    return themeId;
  }

  private async activateThemeWrapper(pathConfig: PathConfiguration, option?: ThemeOptions,
    apply: boolean = true, innerScreenOnly: boolean = false, from: From = 'default'): Promise<number> {
    TsLog.info(TAG, `activateThemeWrapper,apply:${apply}`);
    // 过滤得到画廊中存在的没有编辑过的默认主题
    let themeCacheInfoList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (apply && themeCacheInfoList && (!option || innerScreenOnly) && !FileUtil.isFileExists(pathConfig.customPath)) {
      const themeId: string = await this.getThemeId(pathConfig.originPath);
      let firstTheme: Nullable<ThemeCacheInfo> = themeCacheInfoList.find(theme => theme?.id === themeId &&
        !this.isEditedTheme(theme.editorId));
      if (firstTheme && !await themeTrialService().isTrialTheme(firstTheme.editorId)) {
        try {
          // 使能画廊中存在的没有编辑过的默认主题（非试用主题）
          await activateThemeService().activateEditedTheme(firstTheme.editorId, undefined, innerScreenOnly);
        } catch (err) {
          let error: BusinessError<string> = err as BusinessError<string>;
          TsLog.info(TAG, `activate first duplicate theme , activate exist theme , result = ${error?.code}`);
          return error?.code ?? RemoteCode.ERR_UNKNOWN;
        }
        return RemoteCode.SUCCESS;
      }
    }
    let defaultTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    let eid: string = systemDateTime.getTime(true).toString();
    if (pathConfig.customPath && FileUtil.isFileExists(pathConfig.customPath) && !apply) {
      // X宇宙需求,第一次应用生成一个画廊，后面会动态生成图片，再次应用不需要生成画廊
      eid = defaultTheme.editorId;
    }
    const themeInfo: ThemeInfo = await ThemeActivateServiceImpl.createThemeInfo(pathConfig.originPath, eid);
    const mixedExecutor: ThemeMixedExecutor = new ThemeMixedExecutor(defaultTheme, themeInfo);
    const mixedThemeEditInfo: ThemeEditInfo =
      await mixedExecutor.activateThemeMixed(pathConfig.originPath, option, apply, from);
    const activateTheme: NullableType<ThemeInfo> = mixedExecutor.isMixed() ? defaultTheme : themeInfo;
    let themeApplyScope: ThemeApplyScope = await this.getThemeApplyScope(innerScreenOnly, option);
    await this.prepareCustom(pathConfig.originPath, activateTheme, themeApplyScope, pathConfig.customPath);
    const ret: number = await new ThemePackageInstaller(activateTheme).activateThemeOpt(option,
      innerScreenOnly, apply);
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `activateTheme failed`);
      return ret;
    }
    TsLog.info(TAG,
      `activateTheme mixedTheme:${mixedThemeEditInfo},editorId: ${activateTheme.editorId} success,apply:${apply}`);

    // 如果仅应用外屏主题，这里不再更新内屏主题信息和缓存数据
    if (await this.whetherUpdateTheme(innerScreenOnly, option)) {
      apply ? await themeInfoService.get().applyTheme(activateTheme, mixedThemeEditInfo) :
        await themeInfoService.get().applyTheme(defaultTheme, mixedThemeEditInfo);
    }
    return ret;
  }

  /**
   * 是否需要更新内屏主题的缓存和数据
   * @param innerScreenOnly 是否仅应用内屏
   * @param option 主题应用的范围
   * @returns 结果 true：需要更新，false：不需要更新
   */
  private async whetherUpdateTheme(innerScreenOnly: boolean, option?: ThemeOptions): Promise<boolean> {
    let themeApplyScope: ThemeApplyScope = await this.getThemeApplyScope(innerScreenOnly, option);
    if (themeApplyScope.subScreen === ThemeOptions.ENABLE) {
      return false;
    }
    return true;
  }

  private async prepareCustom(path: string, activateTheme: ThemeInfo, themeApplyScope: ThemeApplyScope,
    custom?: string): Promise<void> {
    // 如果增量资源不存在，直接返回
    if (!custom || !FileUtil.isFileExists(custom)) {
      TsLog.info(TAG, `custom path is null or not exists`);
      return;
    }
    let customPackagePath = TSPathUtils.getThemeCustomPackagePath(activateTheme);

    // 如果不是仅应用外屏和仅应用内屏场景，还是走之前逻辑
    if (themeApplyScope.other === ThemeOptions.ENABLE) {
      TsLog.info(TAG, `prepareCustom copy all resource`);
      await this.copyThemeResource(path, custom, customPackagePath);
      return;
    }

    // 如果主题仅应用外屏，需要先删除原始增量包下的外屏增量资源，再把custom下的sub_screen拷贝到增量路径
    if (themeApplyScope.subScreen === ThemeOptions.ENABLE) {
      TsLog.info(TAG, `prepareCustom copy sub_screen resource`);
      await FileUtil.rmdirAsync(`${customPackagePath}/${TARGET_SUB_SCREEN}`);
      await FileUtil.copyDirAsync(`${custom}/${TARGET_SUB_SCREEN}` ?? '', customPackagePath);
      return;
    }
    let customRootPath = TSPathUtils.getTsCustomRootPath();

    // 如果主题仅应用内屏，需要保留原始增量包下的外屏增量资源
    if (FileUtil.createDirRecur(`${customRootPath}/${'tempRes'}`)) {
      TsLog.info(TAG, `prepareCustom copy innnerScreen resource`);
      await FileUtil.copyDirAsync(`${customPackagePath}/${TARGET_SUB_SCREEN}` ?? '', `${customRootPath}/${'tempRes'}`);
      await this.copyThemeResource(path, custom, customPackagePath);
      await FileUtil.rmdirAsync(`${customPackagePath}/${TARGET_SUB_SCREEN}`);
      await FileUtil.copyDirAsync(`${customRootPath}/${'tempRes'}` ?? '', customPackagePath);
      await FileUtil.rmdirAsync(`${customRootPath}/${'tempRes'}`);
    }
  }

  private async copyThemeResource(path: string, custom: string, customPath: string): Promise<void> {
    await FileUtil.rmdirAsync(customPath);
    // 山海经自定义主题会修改AOD部分资源
    if (FileUtil.isFileExists(`${custom}/${TARGET_AOD}`)) {
      const aodOriginResource: string = `${path}/${TARGET_AOD}`;
      await FileUtil.copyDirAsync(`${aodOriginResource}/` ?? '',
        `${customPath}/${TARGET_AOD}`);
    }
    await FileUtil.copyDirAsync(`${custom}/` ?? '', customPath);
  }

  async setWallPaper(wallPaperInfos: WallPaperInfo[]): Promise<boolean> {
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `set wallpaper not find current theme`);
      const error: BusinessError<string> =
        { name: `error`, message: `set wallpaper not find current theme`, code: RemoteCode.ERR_THEME_INFO };
      return Promise.reject(error);
    }
    for (let wallPaperInfo of wallPaperInfos) {
      for (let wallPaper of wallPaperInfo.wallPapers) {
        try {
          await this.validatePath(wallPaper.src, 'setWallPaper');
        } catch (err) {
        return Promise.reject(err);
      }
      }
    }
    return await new SetWallPaperExecutor(themeInfo).setWallPaper(wallPaperInfos);
  }

  async applyIcons(iconsDir: string): Promise<boolean> {
    try {
      await this.validatePath(iconsDir, 'applyIcons');
    } catch (err) {
      return Promise.reject(err);
    }
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `apply icon not find current theme`);
      const error: BusinessError<string> =
        { name: `error`, message: `apply icon not find current theme`, code: RemoteCode.ERR_THEME_INFO };
      return Promise.reject(error);
    }
    return await new ApplyIconsExecutor(themeInfo).applyIcons(iconsDir);
  }

  async setSkin(skinPath: string, pkgNames: string[]): Promise<boolean> {
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `set skin not find current theme`);
      return false;
    }
    // 清空skin对应下pkg资源
    if (StringUtils.isEmpty(skinPath)) {
      return await new SetSkinExecutor(themeInfo).setSkin(skinPath, pkgNames);
    }
    const validatePkgNames = await this.validatePkgNames(skinPath, pkgNames);
    if (!validatePkgNames) {
      return false;
    }
    try {
      await this.validatePath(skinPath, 'setSkin');
    } catch (err) {
      return Promise.reject(err);
    }
    return await new SetSkinExecutor(themeInfo).setSkin(skinPath, pkgNames);
  }

  async applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[],
    multiWeight?: boolean): Promise<number> {
    try {
      await this.validatePath(ttf, `applyFont`);
    } catch (err) {
      return Promise.reject(err);
    }
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `applyFont not find current theme`);
      const error: BusinessError<string> =
        { name: `error`, message: `applyFont not find current theme`, code: RemoteCode.ERR_THEME_INFO };
      return Promise.reject(error);
    }
    return await new ApplyFontExecutor(themeInfo).applyFont(id, ttf, originType, ttfExt, multiWeight);
  }

  async applyCustomConfig(tConfigArgs: TConfigArg[], activated?: boolean): Promise<boolean> {
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `apply custom config not find current theme`);
      const error: BusinessError<string> =
        { name: `error`, message: `apply custom config not find current theme`, code: RemoteCode.ERR_THEME_INFO };
      return Promise.reject(error);
    }
    return await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs, activated);
  }

  async activateDefaultTheme(): Promise<boolean> {
    try {
      let defaultThemeDir = await getThemePackParser().getDefaultDir();
      if (!defaultThemeDir) {
        // 不存在默认主题
        TsLog.error(TAG, `activateDefaultTheme failed , no default theme`);
        const error: BusinessError<string> = {
            name: `error`,
            message: `activateDefaultTheme failed , no default theme`,
            code: RemoteCode.ERR_DEFAULT_THEME
          };
        return Promise.reject(error);
      }
      // 获取主题画廊中是否存在没有编辑过的默认主题
      let themePackageInfo: ThemePackInfo = await getThemePackParser().parseDefault();
      let themeId: string = '';
      try {
        let id: object = JSON.parse(themePackageInfo?.description)['id'];
        themeId = typeof id === 'string' ? id : id?.toString();
      } catch (err) {
        TsLog.info(TAG, `activateDefaultTheme id is empty`)
        const error: BusinessError<string> =
          { name: `error`, message: `activateDefaultTheme id is empty`, code: RemoteCode.ERR_THEME_ID };
        return Promise.reject(error);
      }
      // 过滤得到画廊中存在的没有编辑过的默认主题
      let themeCacheInfoList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
      if (themeCacheInfoList) {
        let firstTheme: Nullable<ThemeCacheInfo> =
          themeCacheInfoList.find(theme => theme?.id === themeId && theme?.themeEditInfo?.size === 0);
        if (firstTheme && firstTheme.editorId) {
          // 使能画廊中存在的没有编辑过的默认主题
          let result: boolean = await activateThemeService().activateEditedTheme(firstTheme.editorId);
          TsLog.info(TAG, `activateDefaultTheme , activate exist theme , result = ${result}`);
          return result;
        }
      }
      // 使能新默认主题，画廊中会增加一条记录
      let result: boolean = await activateThemeService().activateTheme(defaultThemeDir);
      TsLog.info(TAG, `activateDefaultTheme , activate new theme , result = ${result}`);
      return result;
    } catch (err) {
      TsLog.error(TAG, `activateDefaultTheme err`, err);
      return Promise.reject(err);
    }
  }

  async activateDefaultFont(): Promise<boolean> {
    try {
      let defaultFont: NullableType<FontInfo> = await PresetThemeExtCache.getInstance().getDefaultFont();
      if (!defaultFont) {
        // 不存在默认字体
        TsLog.error(TAG, `activateDefaultFont failed , no default font`);
        const error: BusinessError<string> =
          { name: `error`, message: `activateDefaultFont failed , no default font`, code: RemoteCode.ERR_DEFAULT_FONT };
        return Promise.reject(error);
      }
      // 使能默认字体
      let result: number =
        await activateThemeService().applyFont(defaultFont.id, defaultFont.ttfFileSrc, defaultFont.origin);
      TsLog.info(TAG, `activateDefaultFont , result = ${result}`);
      return result === ThemeCode.SUCCESS;
    } catch (err) {
      TsLog.error(TAG, `activateDefaultFont err`, err);
      return Promise.reject(err);
    }
  }

  private async validatePath(path: string, name: string): Promise<string> {
    const trustRet: boolean = await PathValidateUtil.validatePath(path);
    if (trustRet) {
      return PathValidateUtil.formatPath(path);
    }
    TsLog.warning(TAG, `${name} validate path fail,${path}`);
    const error: BusinessError<string> =
      { name: `error`, message: `${name} validatePath is empty`, code: RemoteCode.ERR_ILLEGAL_PATH };
    return Promise.reject(error);
  }

  private async validatePkgNames(path: string, pkgNames: string[]): Promise<boolean> {
    const trustRet: boolean = await PathValidateUtil.validatePkgPath(path, pkgNames);
    if (!trustRet) {
      TsLog.warning(TAG, 'validate pkgNames error');
    }
    return trustRet;
  }

  async activateThemeStyle(contentType: string[], style: string): Promise<boolean> {
    let currentTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    let result: number = await new ThemePackageInstaller(currentTheme).activateStyle(contentType, style);
    if (result !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `active theme style failed`);
      const error: BusinessError<string> = { name: `error`, message: `active theme style failed`, code: result };
      return Promise.reject(error);
    }
    return true;
  }
}

export function activateThemeService(): ThemeActivateApi {
  return TServiceApi.themeActivate();
}

export class PathConfiguration {
  public originPath: string = '';
  public customPath?: string;

  public setOriginPath(path: string): void {
    this.originPath = path;
  }

  public setCustomPath(path?: string): void {
    this.customPath = path;
  }
}

export class ThemeApplyScope {
  public static readonly ENABLE: string = `1`;
  public innerScreen?: string;
  public subScreen?: string;
  public other?: string;

  public enableInnerScreen(): ThemeApplyScope {
    this.innerScreen = ThemeApplyScope.ENABLE;
    return this;
  }

  public enableSubScreen(): ThemeApplyScope {
    this.subScreen = ThemeApplyScope.ENABLE;
    return this;
  }

  public enableOther(): ThemeApplyScope {
    this.other = ThemeApplyScope.ENABLE;
    return this;
  }
}