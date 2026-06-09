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
import { LemSubScreenInfo } from '@ohos/themeservice_core_lem/src/main/ets/lem/LemSubScreenInfo';
import { SubScreenInfo } from '@ohos/themeservice_core_subscreen/src/main/ets/subscreen/SubScreenInfo';
import {
  ActivateType,
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
  TSRemoteMethod,
  WallPaperInfo,
} from '@ohos/themeservice_inner_api';
import { NullableType, RemoteCaller, TsContext } from '@ohos/themeservicebase';
import { RemoteCode, VERSION_0 } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { TSRemoteCalleeApi } from '../../../../main/ets/remote/callee/TSRemoteCalleeApi';
import { GlobalPersistInfo } from '../../../../main/ets/remote/model/GlobalPersistInfo';
import { OnlineThemeInfo } from '../../../../main/ets/remote/model/OnlineThemeInfo';
import { TrialThemeInfo } from '../../../../main/ets/remote/model/TrialThemeInfo';
import { ThemeInfoV2 } from './model/ThemeInfo';
import { ThemeInfoCodec } from './ThemeInfoCodec';
import { UpdateResourceInfo } from '../../../../main/ets/cache/UpdateThemeInfoCache';

/**
 * Ts测跨端接口版本号，手动修改分别测试不同解码器
 */
const REMOTE_VERSION: number = VERSION_0;

export interface TSLemRemoteApi {
  /**
   * 应用外屏主题。调用放：外屏主题
   * @param subScreenInfo 外屏主题信息
   * @returns 应用是否成功
   */
  lemActivateSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<boolean>;

  /**
   * 获取外屏主题列表
   * @returns 主题列表
   */
  lemGetSubScreenThemes(): Promise<Nullable<LemSubScreenInfo[]>>;

  /**
   * 添加外屏外屏主题
   * @param subScreenInfo 要添加的外屏主题
   * @returns 添加后的主题列表
   */
  lemAddSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<Nullable<LemSubScreenInfo[]>>;

  /**
   * 删除指定的外屏主题
   * @param themeId 要删除的主题ID
   * @returns 删除后的主题列表
   */
  lemDeleteSubScreenTheme(themeId: string): Promise<Nullable<LemSubScreenInfo[]>>;
}

export interface TSSubScreenRemoteApi {
  /**
   * 应用外屏主题。调用放：外屏主题
   * @param subScreenInfo 外屏主题信息
   * @returns 应用是否成功
   */
  activateSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<boolean>;

  /**
   * 获取外屏主题列表
   * @returns 主题列表
   */
  getSubScreenThemes(): Promise<Nullable<SubScreenInfo[]>>;

  /**
   * 添加外屏外屏主题
   * @param subScreenInfo 要添加的外屏主题
   * @returns 添加后的主题列表
   */
  addSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<Nullable<SubScreenInfo[]>>;

  /**
   * 删除指定的外屏主题
   * @param themeId 要删除的主题ID
   * @returns 删除后的主题列表
   */
  deleteSubScreenTheme(themeId: string): Promise<Nullable<SubScreenInfo[]>>;
}

export interface TSCoreRemoteApi extends TSRemoteCalleeApi {
  /**
   * 大小画廊获取主题列表。调用方：合一编辑器
   * @param type 获取主题列表入口类型
   * @returns 主题列表信息
   */
  getThemeListV2(type: number): Promise<NullableType<ThemeInfoV2[]>>;

  /**
   * 获取当前主题。调用方：合一编辑器
   * @returns 当前主题信息
   */
  getCurrentThemeV2(): Promise<NullableType<ThemeInfoV2>>;

  /**
   * 可信调用者测试
   * @returns
   */
  trustCallerTest(): Promise<void>;
}

export class TSCoreRemoteCallerImpl implements TSCoreRemoteApi, TSLemRemoteApi, TSSubScreenRemoteApi {
  private readonly remoteCaller: RemoteCaller;

  constructor(context: TsContext) {
    this.remoteCaller = new RemoteCaller(context, {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'TSOhosTestServiceAbility',
    });
  }

  getCurrentFont(): Promise<NullableType<FontInfo>> {
    return this.remoteCaller.request<NullableType<FontInfo>>(REMOTE_VERSION, TSRemoteMethod.GET_CURRENT_FONT);
  }

  trustCallerTest(): Promise<void> {
    return this.remoteCaller.request(REMOTE_VERSION, 'trustCallerTest');
  }

  setSkin(skinPkg: String, pkgNames: string[]): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.SET_SKIN, skinPkg, pkgNames)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  getOnlineThemeList(): Promise<Nullable<OnlineThemeInfo[]>> {
    return this.remoteCaller.request(REMOTE_VERSION, TSRemoteMethod.GET_ONLINE_THEME_LIST);
  }

  updateOnlineTheme(onlineThemeInfos: OnlineThemeInfo[], vipExpirationDate: number): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.UPDATE_ONLINE_THEME, onlineThemeInfos,
      vipExpirationDate)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  setCurrentThemeCfg(tConfigArgs: TConfigArg[], activated?: boolean | undefined): Promise<boolean> {
    throw Error('Please Invoking Method "TSOhosTestManger.getTsKitRemoteApi().setCurrentThemeCfg()"');
  }

  applyIcons(iconResource: string): Promise<boolean> {
    throw Error('Please Invoking Method "TSOhosTestManger.getTsKitRemoteApi().applyIcons()"');
  }

  applyAod(aodThemeDir: string): Promise<boolean> {
    throw Error('Please Invoking Method "TSOhosTestManger.getTsKitRemoteApi().applyAod()"');
  }

  modifyThemePropertyValue(id: string, property: string, defaultValue?: string): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.MODIFY_THEME_PROPERTY_VALUE,
      id, property, defaultValue).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  getThemePropertyValue(id: string, property: string): Promise<string> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.GET_THEME_PROPERTY_VALUE, id,
      property).then(ret => {
      if (typeof ret === 'string') {
        return ret;
      }
      return '';
    });
  }

  removeThemePropertyValue(id: string, property?: string): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.REMOVE_THEME_PROPERTY_VALUE,
      id, property).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  setWallPaper(wallPapers: WallPaperInfo[]): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.SET_WALLPAPER, wallPapers).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  activateTheme(themeDir: string, option?: ThemeOptions | undefined, apply?: boolean | undefined): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.ACTIVATE_THEME, themeDir, option,
      apply).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  activateThemeCustom(themeDir: string, customThemePkgPath?: string | undefined,
    option?: ThemeOptions | undefined, apply?: boolean | undefined): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.ACTIVATE_THEME_CUSTOM, themeDir,
      customThemePkgPath,
      option, apply)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  saveThemeCustom(themeDir: string, custom?: string | undefined, isUsable?: boolean | undefined): Promise<string> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.SAVE_THEME_CUSTOM, themeDir,
      custom, isUsable)
      .then(ret => {
        if (typeof ret === 'string') {
          return ret;
        }
        return '';
      });
  }

  applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[],
    multiWeight?: boolean): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.APPLY_FONT_V2, id, ttf,
      originType).then(ret => {
      if (typeof ret === 'number') {
        return ret;
      }
      return RemoteCode.ERR_INNER_IDL;
    });
  }

  removeTheme(editorId: string): Promise<void> {
    return this.remoteCaller.request(REMOTE_VERSION, TSRemoteMethod.REMOVE_THEME, editorId);
  }

  deleteTheme(themeResources: ThemeResource[]): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.DELETE_THEME, themeResources)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  activateEditedTheme(editorId: string, option?: ThemeOptions | undefined): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.ACTIVATE_EDITED_THEME, editorId, option)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  editTheme(editArg: EditThemeArg): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.EDIT_THEME, editArg)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  getThemeListV2(type: number): Promise<Nullable<ThemeInfoV2[]>> {
    return this.remoteCaller.request2(REMOTE_VERSION, TSRemoteMethod.GET_THEME_LIST,
      ThemeInfoCodec.decoder<ThemeInfoV2[]>([]), type);
  }

  getCurrentThemeV2(): Promise<NullableType<ThemeInfoV2>> {
    return this.remoteCaller.request2(REMOTE_VERSION, TSRemoteMethod.GET_CURRENT_THEME,
      ThemeInfoCodec.decoder<ThemeInfoV2>(new ThemeInfoV2()));
  }

  getThemeList(type: number): Promise<NullableType<ThemeInfo[]>> {
    return this.remoteCaller.request(REMOTE_VERSION, TSRemoteMethod.GET_THEME_LIST, type);
  }

  getCurrentTheme(): Promise<NullableType<ThemeInfo>> {
    return this.remoteCaller.request(REMOTE_VERSION, TSRemoteMethod.GET_CURRENT_THEME);
  }

  factoryReset(): Promise<void> {
    return this.remoteCaller.request(REMOTE_VERSION, TSRemoteMethod.FACTORY_RESET);
  }

  notifyOnlineRecommendationUpdate(recommendInfoList: ThemeRecommendInfo[]): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.NOTIFY_ONLINE_RECOMMEND_UPDATE,
      recommendInfoList)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  getOnlineRecommendation(): Promise<Nullable<ThemeRecommendInfo[]>> {
    return this.remoteCaller.request<ThemeRecommendInfo[]>(REMOTE_VERSION, TSRemoteMethod.GET_ONLINE_RECOMMENDATION);
  }

  hostedThemeDownloaded(id: string, path: string): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.HOSTED_THEME_DOWNLOADED, id, path)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  activateTrialTheme(path: string, trialDuration: number, trialType: TrialContentType, activateType?: ActivateType,
    reminderDuration?: number): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.ACTIVATE_TRIAL_THEME, path, trialDuration,
      trialType, activateType, reminderDuration)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  promoteTrialTheme(id: string, path: string, trialType: TrialContentType): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.PROMOTE_TRIAL_THEME, id, path, trialType)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  rollbackTheme(rollbackType: TrialRollbackType): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.ROLLBACK_THEME, rollbackType)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  getTrialTheme(): Promise<Nullable<TrialThemeInfo>> {
    return this.remoteCaller.request<TrialThemeInfo>(REMOTE_VERSION, TSRemoteMethod.GET_TRIAL_THEME);
  }

  lemActivateSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, 'lemActivateSubScreenTheme', subScreenInfo)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  lemGetSubScreenThemes(): Promise<Nullable<LemSubScreenInfo[]>> {
    return this.remoteCaller.request<LemSubScreenInfo[]>(REMOTE_VERSION, 'lemGetSubScreenThemes');
  }

  lemAddSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<Nullable<LemSubScreenInfo[]>> {
    return this.remoteCaller.request<LemSubScreenInfo[]>(REMOTE_VERSION, 'lemAddSubScreenTheme', subScreenInfo);
  }

  lemDeleteSubScreenTheme(themeId: string): Promise<Nullable<LemSubScreenInfo[]>> {
    return this.remoteCaller.request<LemSubScreenInfo[]>(REMOTE_VERSION, 'lemDeleteSubScreenTheme', themeId);
  }

  activateSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, 'activateSubScreenTheme', subScreenInfo)
      .then(ret => {
        if (typeof ret === 'boolean') {
          return ret;
        }
        return false;
      });
  }

  getSubScreenThemes(): Promise<Nullable<SubScreenInfo[]>> {
    return this.remoteCaller.request<SubScreenInfo[]>(REMOTE_VERSION, 'getSubScreenThemes');
  }

  addSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<Nullable<SubScreenInfo[]>> {
    return this.remoteCaller.request<SubScreenInfo[]>(REMOTE_VERSION, 'addSubScreenTheme', subScreenInfo);
  }

  deleteSubScreenTheme(themeId: string): Promise<Nullable<SubScreenInfo[]>> {
    return this.remoteCaller.request<SubScreenInfo[]>(REMOTE_VERSION, 'deleteSubScreenTheme', themeId);
  }

  correctLimitedFreeTheme(id: string, type: TrialContentType, limitedDuration: number,
    reminderDuration: number): Promise<number> {
    return this.remoteCaller.request<number>(REMOTE_VERSION, TSRemoteMethod.CORRECT_LIMITED_FREE_THEME, id, type,
      limitedDuration, reminderDuration)
      .then(ret => {
        if (typeof ret === 'number') {
          return ret;
        }
        return RemoteCode.ERR_INNER_IDL;
      });
  }

  activateThemeStyle(contentType: string[], style: string): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.ACTIVATE_THEME_STYLE, contentType, style).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  setGlobalPersist(globalPersistInfo: GlobalPersistInfo): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.SET_GLOBAL_PERSIST, globalPersistInfo).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  getGlobalPersist(): Promise<Nullable<GlobalPersistInfo>> {
    return this.remoteCaller.request<Nullable<GlobalPersistInfo>>(REMOTE_VERSION, TSRemoteMethod.GET_GLOBAL_PERSIST);
  }

  getUpdateThemeList(): Promise<NullableType<UpdateResourceInfo[]>> {
    return this.remoteCaller.request<NullableType<UpdateResourceInfo[]>>(REMOTE_VERSION, TSRemoteMethod.GET_UPDATE_THEME_LIST);
  }

  ignoreUpdateTheme(id: string, ignoreVersion: string): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.IGNORE_UPDATE_THEME, id,
      ignoreVersion).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }

  clearUpdateThemeAllCache(): Promise<boolean> {
    return this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.CLEAR_UPDATE_THEME_ALL_CACHE).then(ret => {
      if (typeof ret === 'boolean') {
        return ret;
      }
      return false;
    });
  }
}