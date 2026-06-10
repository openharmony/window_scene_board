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
import { preferences } from '@kit.ArkData';
import { systemDateTime } from '@kit.BasicServicesKit';
import {
  ORIGIN_PRESET,
  ORIGIN_PRESET_FRAGMENT,
  OriginType,
  TargetType,
  TContentPrivStatus
} from '@ohos/themeservice_inner_api';
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';
import {
  AnyType,
  ArrayUtils,
  ContextUtil,
  JsonUtils,
  NullableType,
  ObjectUtils,
  PreferenceApi,
  Singleton,
  StoreCache,
  StoreManager,
  TsLog,
  VERSION_EMPTY
} from '@ohos/themeservicebase';
import { ActivatedThemeCache } from './ActivatedThemeCache';
import { ThemePackCache, ThemePackCacheData } from './ThemePackCache';

const TAG: string = 'ThemeInfoStoreCache';

export type ThemeEditInfo = Map<TargetType, ThemeExtendInfo>;

export class ThemeCacheInfo {
  /**
   * 主题id
   */
  public id: string = '';
  /**
   * 编辑id
   */
  public editorId: string = '';
  /**
   * 锁屏大画廊中的顺序
   */
  public order: number = 0;
  /**
   * 设置小画廊中的顺序，从0开始添加顺序有小到大
   */
  public addOrder: number = 0;
  /**
   * 新增相同主题时，新增主题名称添加数字后缀
   */
  public themeIndex: number = 0;
  /**
   * 是否为当前应用主题
   */
  public isUsing: boolean = false;
  /**
   * 主题来源类型 - 不一定是真正的主题包属性（仅用于TS内部使用）
   * 1.online: 从主题app下载
   * 2.preset：手机预置
   * 3.presetFragment:手机预置小包
   */
  public originType: OriginType = ORIGIN_PRESET;

  /**
   * 原始主题包路径
   */
  public srcPath: string = '';
  /**
   * 主题编辑信息
   */
  public themeEditInfo: ThemeEditInfo = new Map();
  /**
   * 是否是托管上云主题（预置小包）
   */
  public isPresetFragment: boolean = false;
  /**
   * 主题包是否可以应用(潘多拉二期主题新增不可应用状态，合一编辑器会读取该字段)
   */
  public isUsable: boolean = true;
  /**
   * 在线资源信息缓存（会员到期时间、内容可用状态）
   */
  public onlineInfo?: OnlineInfo;
}

export class ThemeExtendInfo {
  /**
   * 自定义主题资源类型：preset | online | presetFragment
   */
  public type: OriginType = ORIGIN_PRESET;
  /**
   * 资源id
   */
  public resourceId: string = '';
  /**
   * 资源原始路径
   */
  public srcPath: string = '';
  /**
   * 在线资源信息（会员到期时间、内容可用状态）
   */
  public onlineInfo?: OnlineInfo

  constructor(type: OriginType, resourceId: string, srcPath: string) {
    this.type = type;
    this.resourceId = resourceId;
    this.srcPath = srcPath;
  }
}

/**
 * 在线资源信息（会员到期时间、内容可用状态）
 */
export class OnlineInfo {
  /**
   * 会员到期时间
   */
  public vipExpirationDate?: number;
  /**
   * 内容可用状态，disable：资源不可用，enable：资源可用，vip：会员资源需要校验会员是否到期
   */
  public contentPrivStatus?: TContentPrivStatus;

  constructor(vipExpirationDate?: number, contentPrivStatus?: TContentPrivStatus) {
    this.vipExpirationDate = vipExpirationDate;
    this.contentPrivStatus = contentPrivStatus;
  }
}

export class ThemeInfoStoreCache extends StoreCache<ThemeCacheInfo[], string[]> {
  private static readonly INSTANCE: Singleton<ThemeInfoStoreCache> =
    new Singleton<ThemeInfoStoreCache>(() => new ThemeInfoStoreCache());

  private constructor() {
    super(new ThemeInfoStoreManger(), async (oldVersion, newVersion, oldData) => {
      TsLog.info(TAG, `oldVersion:${oldVersion} -> newVersion:${newVersion}`);
      if (oldVersion === VERSION_EMPTY) {
        // 首次启用，从预置数据中初始化缓存
        return this.getInitData();
      }
      return Promise.resolve(undefined);
    });
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): ThemeInfoStoreCache {
    return ThemeInfoStoreCache.INSTANCE.get();
  }

  /**
   * 从预置数据中初始化缓存
   * @returns
   */
  private async getInitData(): Promise<ThemeCacheInfo[]> {
    const cacheInfos: ThemeCacheInfo[] = [];
    let presetList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
    if (!presetList || ObjectUtils.isNull(presetList)) {
      return cacheInfos;
    }
    let isChangeOrder: boolean = false;
    let order: number = presetList.length;
    for (const presetData of presetList) {
      let cacheInfo: ThemeCacheInfo = new ThemeCacheInfo();
      cacheInfo.id = presetData.id;
      cacheInfo.editorId = systemDateTime.getTime(true).toString();
      if (presetData.isDefault) {
        cacheInfo.order = presetList.length;
      } else {
        cacheInfo.order = --order;
      }
      cacheInfo.addOrder = presetList.indexOf(presetData);
      cacheInfo.isUsing = presetData.isDefault;
      const presetOrigin: OriginType = presetData.themePack?.origin ?? ORIGIN_PRESET;
      cacheInfo.originType = presetOrigin;
      cacheInfo.isPresetFragment = presetOrigin === ORIGIN_PRESET_FRAGMENT;
      cacheInfo.srcPath = presetData.themePack?.srcPath;
      cacheInfos.push(cacheInfo);
      if (cacheInfo.isUsing) {
        // 如果预置主题数量大于等于2个，设置当前默认展示主题处于小画廊第二个展示位置
        if (presetList.length >= 2 && cacheInfo.addOrder === 0) {
          cacheInfo.addOrder = 1;
          isChangeOrder = true;
        }
        TsLog.info(TAG, `getInitData cacheInfo id : ${cacheInfo.id}`);
        ActivatedThemeCache.getInstance().update(cacheInfo);
      }
    }
    // 如果预置主题数量大于等于2个，设置第二个预置主题处于小画廊第一个展示位置
    if (cacheInfos.length >= 2 && cacheInfos[1].addOrder === 1 && isChangeOrder) {
      cacheInfos[1].addOrder = 0;
    }
    TsLog.info(TAG, `getInitData = ${cacheInfos.length}`);
    return cacheInfos;
  }

  public async reset(): Promise<boolean> {
    let initData: ThemeCacheInfo[] = await this.getInitData();
    if (initData?.length > 0) {
      return this.update(initData);
    } else {
      return this.clear().then(() => true);
    }
  }
}

class ThemeInfoStoreManger implements StoreManager<ThemeCacheInfo[], string[]> {
  private readonly preferenceApi: PreferenceApi;

  constructor() {
    this.preferenceApi = TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'ts_themeInfoV4');
  }

  getName(): string {
    return `ThemeInfoStoreManger`;
  }

  put(key: string, value: number | string[]): Promise<void> {
    return this.preferenceApi.put(key, value);
  }

  get(key: string, def?: number | string[] | undefined): Promise<number | string[] | undefined> {
    return this.preferenceApi.get(key, def)
      .then((result: preferences.ValueType) => result as number | string[] | undefined);
  }

  decode(values: string[]): ThemeCacheInfo[] {
    const reviver: (key: string, value: AnyType) => AnyType = (key, value) => {
      if (key === 'id' || key === 'editorId') {
        return value?.toString();
      }
      return undefined;
    }
    return ArrayUtils.map(values,
      (value: string) => JsonUtils.parse<ThemeCacheInfo>(value, new ThemeCacheInfo(), reviver));
  }

  encode(cacheInfos: ThemeCacheInfo[]): string[] {
    return ArrayUtils.map(cacheInfos, (cacheInfo: ThemeCacheInfo) => JsonUtils.stringify(cacheInfo));
  }

  clear(): Promise<void> {
    return this.preferenceApi.clear();
  }
}