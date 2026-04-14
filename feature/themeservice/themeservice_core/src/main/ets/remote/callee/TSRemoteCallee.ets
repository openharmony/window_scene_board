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
import { Permissions } from '@kit.AbilityKit';
import {
  ActivateType,
  Constants,
  EditThemeArg,
  FontInfo,
  OriginType,
  TConfigArg,
  ThemeInfo,
  ThemeOptions,
  ThemeRecommendInfo,
  ThemeResource,
  TrialContentType,
  TrialRollbackType,
  TServiceApi,
  TSRemoteMethod,
  WallPaperInfo,
} from '@ohos/themeservice_inner_api/Index';
import {
  CalleeMethodSet,
  checkNonNull,
  logPostInterceptor,
  logPreInterceptor,
  NullableType,
  RemoteCallee,
  RemoteInterceptor,
  TsLog,
} from '@ohos/themeservicebase/Index';
import { deleteOnlineThemeService } from '../../service/impl/DeleteOnlineThemeServiceImpl';
import { globalPersistService } from '../../service/impl/GlobalPersistServiceImpl';
import { activateThemeService } from '../../service/impl/ThemeActivateServiceImpl';
import { themeInfoService } from '../../service/impl/ThemeInfoServiceImpl';
import { themePropertyService } from '../../service/impl/ThemePropertyServiceImpl';
import { themeTrialService } from '../../service/impl/ThemeTrialServiceImpl';
import { themeVipService } from '../../service/impl/ThemeVipServiceImpl';
import { tsOnlineRecommend } from '../../service/impl/TsOnlineRecommendImpl';
import { resetService } from '../../service/impl/TSResetServiceImpl';
import { GlobalPersistInfo } from '../model/GlobalPersistInfo';
import { OnlineThemeInfo } from '../model/OnlineThemeInfo';
import { TrialThemeInfo } from '../model/TrialThemeInfo';
import { openharmony_APP, RETAIL_APP } from './TrustCallerInfo';
import { TSParamChecker } from './TSParamChecker';
import { TSRemoteCalleeApi } from './TSRemoteCalleeApi';
import { updateThemeInfoService } from '../../service/impl/UpdateThemeInfoServiceImpl';
import { UpdateResourceInfo } from '../../cache/UpdateThemeInfoCache';

const TAG: string = 'TSRemoteCallee';

export class TSRemoteCallee implements RemoteCallee, TSRemoteCalleeApi {
  onAddPreInterceptor(interceptors: RemoteInterceptor[]): void {
    interceptors.unshift(logPreInterceptor);
  }

  onAddPostInterceptor(interceptors: RemoteInterceptor[]): void {
    interceptors.unshift(logPostInterceptor);
  }

  getRemotePermissions(): Permissions[] {
    return [`ohos.permission.ACTIVATE_THEME_PACKAGE`];
  }

  onRegister(methodSet: CalleeMethodSet): void {
    methodSet.register(TSRemoteMethod.GET_UPDATE_THEME_LIST, this.getUpdateThemeList);
    methodSet.register(TSRemoteMethod.IGNORE_UPDATE_THEME, this.ignoreUpdateTheme, { parallel: false });
    methodSet.register(TSRemoteMethod.CLEAR_UPDATE_THEME_ALL_CACHE, this.clearUpdateThemeAllCache, {
      parallel: false, trustCallers: [openharmony_APP],
    });
    methodSet.register(TSRemoteMethod.ACTIVATE_THEME_STYLE, this.activateThemeStyle, { parallel: false });
    methodSet.register(TSRemoteMethod.SET_GLOBAL_PERSIST, this.setGlobalPersist, { parallel: false });
    methodSet.register(TSRemoteMethod.GET_GLOBAL_PERSIST, this.getGlobalPersist);
    methodSet.register(TSRemoteMethod.GET_CURRENT_FONT, this.getCurrentFont);
    methodSet.register(TSRemoteMethod.APPLY_FONT_V2, this.applyFont, { parallel: false });
    methodSet.register(TSRemoteMethod.SET_CURRENT_THEME_CFG, this.setCurrentThemeCfg, { parallel: false });
    methodSet.register(TSRemoteMethod.FACTORY_RESET, this.factoryReset, {
      parallel: false, trustCallers: [RETAIL_APP]
    });
    methodSet.register(TSRemoteMethod.APPLY_ICONS, this.applyIcons, { parallel: false });
    methodSet.register(TSRemoteMethod.SAVE_THEME_CUSTOM, this.saveThemeCustom, { parallel: false });
    methodSet.register(TSRemoteMethod.SET_SKIN, this.setSkin, { parallel: false });
    methodSet.register(TSRemoteMethod.APPLY_AOD, this.applyAod, { parallel: false });
    methodSet.register(TSRemoteMethod.GET_THEME_LIST, this.getThemeList);
    methodSet.register(TSRemoteMethod.GET_CURRENT_THEME, this.getCurrentTheme);
    methodSet.register(TSRemoteMethod.REMOVE_THEME, this.removeTheme);
    methodSet.register(TSRemoteMethod.MODIFY_THEME_PROPERTY_VALUE, this.modifyThemePropertyValue);
    methodSet.register(TSRemoteMethod.GET_THEME_PROPERTY_VALUE, this.getThemePropertyValue);
    methodSet.register(TSRemoteMethod.REMOVE_THEME_PROPERTY_VALUE, this.removeThemePropertyValue);
    methodSet.register(TSRemoteMethod.NOTIFY_ONLINE_RECOMMEND_UPDATE, this.notifyOnlineRecommendationUpdate,
      { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.GET_ONLINE_RECOMMENDATION, this.getOnlineRecommendation);
    methodSet.register(TSRemoteMethod.SET_WALLPAPER, this.setWallPaper, { parallel: false, hasTimedOut: true });
    methodSet.register(TSRemoteMethod.ACTIVATE_THEME, this.activateTheme, { parallel: false, hasTimedOut: true });
    methodSet.register(TSRemoteMethod.ACTIVATE_THEME_CUSTOM, this.activateThemeCustom,
      { parallel: false, hasTimedOut: true });
    methodSet.register(TSRemoteMethod.ACTIVATE_EDITED_THEME, this.activateEditedTheme,
      { parallel: false, hasTimedOut: true });
    methodSet.register(TSRemoteMethod.EDIT_THEME, this.editTheme, { parallel: false, hasTimedOut: true });
    methodSet.register(TSRemoteMethod.DELETE_THEME, this.deleteTheme, { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.HOSTED_THEME_DOWNLOADED, this.hostedThemeDownloaded, { trustCallers: [openharmony_APP] });

    // 主题app - 试用业务
    methodSet.register(TSRemoteMethod.ACTIVATE_TRIAL_THEME, this.activateTrialTheme, { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.PROMOTE_TRIAL_THEME, this.promoteTrialTheme, { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.ROLLBACK_THEME, this.rollbackTheme, { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.GET_TRIAL_THEME, this.getTrialTheme, { trustCallers: [openharmony_APP] });

    // 主题app - 会员到期
    methodSet.register(TSRemoteMethod.GET_ONLINE_THEME_LIST, this.getOnlineThemeList, { trustCallers: [openharmony_APP] });
    methodSet.register(TSRemoteMethod.UPDATE_ONLINE_THEME, this.updateOnlineTheme, { trustCallers: [openharmony_APP] });

    // 主题app - 限时免费主题
    methodSet.register(TSRemoteMethod.CORRECT_LIMITED_FREE_THEME, this.correctLimitedFreeTheme,
      { trustCallers: [openharmony_APP] });

    // 产品lem 远端接口注册
    TServiceApi.lem().registerRemoteMethod(methodSet);
    TServiceApi.subScreen().registerRemoteMethod(methodSet);
  }

  getThemeList(type: number): Promise<NullableType<ThemeInfo[]>> {
    return themeInfoService.get().getThemeList(type);
  }

  getCurrentTheme(): Promise<NullableType<ThemeInfo>> {
    return themeInfoService.get().getCurrentTheme();
  }

  modifyThemePropertyValue(id: string, property: string, defaultValue?: string): Promise<boolean> {
    return themePropertyService.get().modifyThemePropertyValue(id, property, defaultValue);
  }

  getThemePropertyValue(id: string, property: string): Promise<string> {
    return themePropertyService.get().getThemePropertyValue(id, property);
  }

  removeThemePropertyValue(id: string, property?: string): Promise<boolean> {
    return themePropertyService.get().removeThemePropertyValue(id, property);
  }

  removeTheme(editorId: string): Promise<void> {
    let editorIdList: string[] = [editorId];
    return themeInfoService.get().removeTheme(editorIdList);
  }

  async applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[],
    multiWeight?: boolean): Promise<number> {
    return await activateThemeService().applyFont(checkNonNull(id), ttf, originType, ttfExt, multiWeight);
  }

  async setCurrentThemeCfg(tConfigArgs: TConfigArg[], activated?: boolean): Promise<boolean> {
    return await activateThemeService().applyCustomConfig(tConfigArgs, activated);
  }

  factoryReset(): Promise<void> {
    TsLog.info(TAG, `factoryReset`);
    return resetService().execute();
  }

  async setSkin(skinPkg: string, pkgNames: string[]): Promise<boolean> {
    return await activateThemeService().setSkin(skinPkg, pkgNames);
  }

  async applyIcons(iconResource: string): Promise<boolean> {
    return await activateThemeService().applyIcons(iconResource);
  }

  notifyOnlineRecommendationUpdate(recommendInfoList: ThemeRecommendInfo[]): Promise<number> {
    return tsOnlineRecommend().notifyOnlineRecommendationUpdate(recommendInfoList);
  }

  getOnlineRecommendation(): Promise<NullableType<ThemeRecommendInfo[]>> {
    return tsOnlineRecommend().getOnlineRecommendation();
  }

  setWallPaper(wallPapers: WallPaperInfo[]): Promise<boolean> {
    return activateThemeService().setWallPaper(wallPapers)
  }

  activateTheme(themeDir: string, option?: ThemeOptions, apply?: boolean, innerScreenOnly?: boolean): Promise<boolean> {
    return activateThemeService().activateTheme(themeDir, option, apply, innerScreenOnly);
  }

  async applyAod(aodThemeDir: string): Promise<boolean> {
    return activateThemeService()
      .activateTheme(await TSParamChecker.path(aodThemeDir), new ThemeOptions().enableAod(), true);
  }

  activateThemeCustom(path: string, custom?: string, option?: ThemeOptions, apply?: boolean,
    innerScreenOnly?: boolean): Promise<boolean> {
    return activateThemeService().activateThemeCustom(path, custom, option, apply, innerScreenOnly);
  }

  async saveThemeCustom(path: string, custom?: string, isUsable: boolean = true): Promise<string> {
    return activateThemeService().saveThemeCustom(path, custom, isUsable);
  }

  activateEditedTheme(editorId: string, option?: ThemeOptions, innerScreenOnly?: boolean): Promise<boolean> {
    return activateThemeService().activateEditedTheme(editorId, option, innerScreenOnly);
  }

  async editTheme(editArg: EditThemeArg, innerScreenOnly?: boolean): Promise<boolean> {
    await TSParamChecker.editThemeArg(editArg);
    return activateThemeService().editTheme(editArg, innerScreenOnly);
  }

  /**
   * 主题app删除主题接口
   * @param themeResources 删除主题资源列表
   * @returns 删除主题是否成功
   */
  deleteTheme(themeResources: ThemeResource[]): Promise<boolean> {
    return deleteOnlineThemeService.get().deleteTheme(themeResources);
  }

  hostedThemeDownloaded(id: string, path: string): Promise<boolean> {
    return themeInfoService.get().updateHostedTheme(id, path);
  }

  async activateTrialTheme(path: string, trialDuration: number, trialType: TrialContentType,
    activateType?: ActivateType, reminderDuration?: number): Promise<number> {
    let themePath: string = await TSParamChecker.path(path);
    if (activateType === undefined) {
      activateType = Constants.TRIAL;
      TSParamChecker.trialDuration(trialDuration);
      reminderDuration = undefined;
    } else {
      if (activateType === Constants.LIMITED_FREE) {
        TSParamChecker.limitedFreeDuration(trialDuration);
        if (reminderDuration) {
          TSParamChecker.limitedFreeDuration(reminderDuration);
        }
      } else if (activateType === Constants.TRIAL) {
        TSParamChecker.trialDuration(trialDuration);
        reminderDuration = undefined;
      }
    }
    return themeTrialService().activateTrialTheme(themePath, trialDuration, trialType, activateType, reminderDuration);
  }

  async promoteTrialTheme(id: string, path: string, trialType: TrialContentType): Promise<number> {
    let themePath: string = await TSParamChecker.path(path);
    return themeTrialService().promoteFreeTheme(id, themePath, trialType);
  }

  rollbackTheme(rollbackType: TrialRollbackType): Promise<number> {
    return themeTrialService().rollbackTheme(rollbackType);
  }

  getTrialTheme(): Promise<TrialThemeInfo> {
    return themeTrialService().getTrialTheme();
  }

  getOnlineThemeList(): Promise<Nullable<OnlineThemeInfo[]>> {
    return themeVipService().getOnlineThemeList();
  }

  updateOnlineTheme(onlineThemeInfos: OnlineThemeInfo[], vipExpirationDate: number): Promise<number> {
    return themeVipService().updateOnlineTheme(onlineThemeInfos, vipExpirationDate);
  }

  correctLimitedFreeTheme(id: string, contentType: TrialContentType, limitedDuration: number,
    reminderDuration: number): Promise<number> {
    return themeTrialService()
      .correctLimitedFreeTheme(id, contentType, TSParamChecker.limitedFreeDuration(limitedDuration),
        TSParamChecker.limitedFreeDuration(reminderDuration));
  }

  async getCurrentFont(): Promise<NullableType<FontInfo>> {
    const fontInner = await themeInfoService.get().getCurrentFont();
    return { id: fontInner.id, multiWeight: fontInner.multiWeight };
  }

  activateThemeStyle(contentType: string[], style: string): Promise<boolean> {
    return activateThemeService().activateThemeStyle(contentType, style);
  }

  setGlobalPersist(globalPersistInfo: GlobalPersistInfo): Promise<boolean> {
    return globalPersistService.get().setGlobalPersist(globalPersistInfo);
  }

  getGlobalPersist(): Promise<Nullable<GlobalPersistInfo>> {
    return globalPersistService.get().getGlobalPersist();
  }

  getUpdateThemeList():Promise<NullableType<UpdateResourceInfo[]>> {
    return updateThemeInfoService.get().getUpdateThemeListAndRefresh();
  }

  ignoreUpdateTheme(id: string, ignoreVersion: string): Promise<boolean> {
    return updateThemeInfoService.get().ignoreUpdateTheme(id, ignoreVersion);
  }

  clearUpdateThemeAllCache(): Promise<boolean> {
    return updateThemeInfoService.get().clearUpdateThemeAllCache();
  }
}
