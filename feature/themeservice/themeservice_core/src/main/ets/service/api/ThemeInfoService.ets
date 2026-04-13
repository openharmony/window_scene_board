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
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { NullableType } from '@ohos/themeservicebase';
import { ThemeCacheInfo, ThemeEditInfo } from '../../cache/ThemeInfoStoreCache';
import { FontInfo } from '../model/FontInfo';

/**
 * 画廊主题历史试用记录管理服务
 */
export interface ThemeInfoService {
  init(): Promise<void>;

  /**
   * 获取应用过的全部主题缓存信息
   * @returns 全部主题缓存信息
   */
  getCacheThemeList(): NullableType<ThemeCacheInfo[]>;

  /**
   * 更新应用过的全部主题缓存信息
   * @param themeCacheInfoArray 待更新的全部主题缓存信息
   * @returns true：成功
   */
  updateCacheThemeList(themeCacheInfoArray: ThemeCacheInfo[]): Promise<boolean>;

  /**
   * 获取当前应用主题的缓存信息
   * @returns 当前应用主题的缓存信息
   */
  getCurrentCacheTheme(): Promise<NullableType<ThemeCacheInfo>>;

  /**
   * 更新当前应用主题的缓存信息
   * @param themeCacheInfo 待更新的当前应用主题的缓存信息
   * @returns true：成功
   */
  updateCurrentCacheTheme(themeCacheInfo: ThemeCacheInfo): Promise<boolean>;

  /**
   * 获取主题列表
   * @param {number} type - 主题类型
   * @return {Promise<NullableType<ThemeInfo[]>>} 返回一个Promise，其解析值为主题信息数组，可能为null
   */
  getThemeList(type: number): Promise<NullableType<ThemeInfo[]>>;

  /**
   * 获取正在应用的主题信息
   * @returns {Promise<ThemeInfo>} 返回一个Promise，其解析值为主题信息
   */
  getCurrentTheme(): Promise<ThemeInfo>;

  /**
   * 获取当前正在应用的字体信息
   * @returns {Promise<FontInfo>} 返回一个Promise，其解析值为主题信息
   */
  getCurrentFont(): Promise<FontInfo>;

  /**
   * 获取主题信息
   * @param editorId 画廊编辑ID
   * @returns 主题信息ThemeInfo
   */
  getThemeByEditorId(editorId: string): Promise<NullableType<ThemeInfo>>;

  /**
   * 移除主题
   * @param editorIds 主题编辑id列表
   * @param notifyChange 通知合一编辑器主题变化
   * @returns
   */
  removeTheme(editorIds: string[], notifyChange?: boolean): Promise<void>;

  /**
   * 应用主题
   * @param themeInfo 主题信息
   * @param themeEditInfo 主题编辑信息
   * @param notifyChange 通知合一编辑器主题变化
   * @param isUsing 是否应用主题, true应用主题, false仅保存不应用主题
   * @returns
   */
  applyTheme(themeInfo: ThemeInfo, themeEditInfo?: ThemeEditInfo, notifyChange?: boolean,
    isUsing?: boolean): Promise<void>;

  /**
   * 刷新主题信息
   * @param id 主题资源id
   * @param path 下载后的资源路径
   * @returns 结果 true：更新成功，false：更新处理失败
   */
  updateHostedTheme(themeId: string, path: string): Promise<boolean>;

  /**
   * 重置画廊数据，获取预置主题列表展示出来
   * @returns
   */
  reset(): Promise<void>;
}