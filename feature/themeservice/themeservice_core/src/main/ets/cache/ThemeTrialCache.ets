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
import { ActivateType, TrialContentType, OriginType, TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { ContextUtil, PreferenceStoreCache, Singleton } from '@ohos/themeservicebase/Index';


/**
 * 待回退原始主题/字体信息
 */
export class RollbackThemeInfo {
  /**
   * 回退主题ID
   */
  public themeId?: string;
  /**
   * 回退主题编辑ID
   */
  public editorId?: string;
  /**
   * 回退主题-AOD内容ID
   */
  public aodId?: string;
  /**
   * 回退主题-桌面壁纸ID
   */
  public homeId?: string;
  /**
   * 回退主题-锁屏壁纸ID
   */
  public lockId?: string;
  /**
   * 回退主题-皮肤内容ID
   */
  public skinId?: string;
  /**
   * 回退字体ID
   */
  public fontId?: string;
  /**
   * 回退字体ttf文件路径
   */
  public fontPath?: string;
  /**
   * 可扩展的回退字体ttf文件路径数组
   */
  public fontPathExt?: string[];
  /**
   * 回退字体安装来源
   */
  public fontOrigin?: OriginType;
}


/**
 * 试用信息缓存数据类
 */
export class TrialCacheData {
  /**
   * 使能类型 0：试用， 1：限免
   */
  public activateType: ActivateType = 0;
  /**
   * 试用类型 theme：试用主题， font：试用字体
   * 注：历史缓存字段名称不能修改
   */
  public trialType: TrialContentType = 'theme';
  /**
   * 当前试用主题id（只在试用主题场景）
   */
  public trialThemeId?: string;
  /**
   * 主题/字体试用成功后当前主题对应的编辑ID（只在试用主题场景）
   */
  public trialThemeEditorId?: string;
  /**
   * 当前试用字体ID（只在试用字体场景）
   */
  public trialFontId?: string;
  /**
   * 到期时间
   */
  public endTime?: number;
  /**
   * 定时器ID，用于取消该定时器
   */
  public endTimerId?: number;
  /**
   * 提醒到期时间
   */
  public reminderTime?: number;
  /**
   * 提醒定时器id
   */
  public reminderTimerId?: number;
  /**
   * 待回退主题/字体信息
   */
  public rollbackThemeInfo?: RollbackThemeInfo;
}


/**
 * 主题试用缓存，存储正在试用的主题信息，单例对象试用
 */
export class ThemeTrialCache extends PreferenceStoreCache<TrialCacheData> {
  private static readonly INSTANCE: Singleton<ThemeTrialCache> =
    new Singleton<ThemeTrialCache>(() => new ThemeTrialCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'trial_theme'));
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): ThemeTrialCache {
    return ThemeTrialCache.INSTANCE.get();
  }
}