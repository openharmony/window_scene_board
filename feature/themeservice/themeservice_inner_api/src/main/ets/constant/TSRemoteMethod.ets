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

export namespace TSRemoteMethod {
  /**
   * 应用字体
   */
  export const APPLY_FONT_V2: string = `applyFontV2`;

  /**
   * 设置当前主题配置
   */
  export const SET_CURRENT_THEME_CFG: string = `setCurrentThemeCfg`;

  /**
   * 应用字体
   */
  export const APPLY_ICONS: string = `applyIcons`;

  /**
   * 保存主题
   */
  export const SAVE_THEME_CUSTOM: string = `saveThemeCustom`;

  /**
   * 设置皮肤
   */
  export const SET_SKIN: string = `setSkin`;

  /**
   * 恢复出厂
   */
  export const FACTORY_RESET: string = `factoryReset`;

  /**
   * 获取主题列表（合一编辑器-画廊）
   */
  export const GET_THEME_LIST: string = `getThemeList`;

  /**
   * 获取当前主题
   */
  export const GET_CURRENT_THEME: string = `getCurrentTheme`;

  /**
   * 画廊移除主题
   */
  export const REMOVE_THEME: string = `removeTheme`;

  /**
   * 修改主题属性值
   */
  export const MODIFY_THEME_PROPERTY_VALUE: string = `modifyThemePropertyValue`;

  /**
   * 获取主题属性值
   */
  export const GET_THEME_PROPERTY_VALUE: string = `getThemePropertyValue`;

  /**
   * 删除主题属性值
   */
  export const REMOVE_THEME_PROPERTY_VALUE: string = `removeThemePropertyValue`;

  /**
   * 主题app通知画廊推荐更新
   */
  export const NOTIFY_ONLINE_RECOMMEND_UPDATE: string = `notifyOnlineRecommendationUpdate`;

  /**
   * 获取推荐信息
   */
  export const GET_ONLINE_RECOMMENDATION: string = `getOnlineRecommendation`;


  export const SET_WALLPAPER: string = `setWallPaper`;

  /**
   * 应用主题
   */
  export const ACTIVATE_THEME: string = `activateTheme`;

  /**
   *应用自定义主题
   */
  export const ACTIVATE_THEME_CUSTOM: string = `activateThemeCustom`;

  /**
   * 激活编辑主题
   */
  export const ACTIVATE_EDITED_THEME: string = `activateEditedTheme`;

  /**
   * 画廊等编辑主题
   */
  export const EDIT_THEME: string = `editTheme`;

  /**
   * 删除主题
   */
  export const DELETE_THEME: string = `deleteTheme`;

  /**
   * 上云托管主题下载
   */
  export const HOSTED_THEME_DOWNLOADED: string = `hostedThemeDownloaded`;

  /**
   * 激活试用主题
   */
  export const ACTIVATE_TRIAL_THEME: string = `activateTrialTheme`;

  /**
   * 提升试用主题
   */
  export const PROMOTE_TRIAL_THEME: string = `promoteTrialTheme`;

  /**
   * 回滚主题
   */
  export const ROLLBACK_THEME: string = `rollbackTheme`;

  /**
   * 获取试用主题
   */
  export const GET_TRIAL_THEME: string = `getTrialTheme`;

  /**
   * 应用aod
   */
  export const APPLY_AOD: string = `applyAod`;

  /**
   * 获取在线主题信息列表
   */
  export const GET_ONLINE_THEME_LIST: string = `getOnlineThemeList`;

  /**
   * 更新在线主题信息
   */
  export const UPDATE_ONLINE_THEME: string = `updateOnlineTheme`;

  /**
   * 校准限免主题信息
   */
  export const CORRECT_LIMITED_FREE_THEME: string = `correctLimitedFreeTheme`;

  /**
   * 获取当前字体信息
   */
  export const GET_CURRENT_FONT: string = `getCurrentFont`;

  /**
   * 切换当前主题风格
   */
  export const ACTIVATE_THEME_STYLE: string = `activeThemeStyle`;

  /**
   * 设置主题的持久化信息
   */
  export const SET_GLOBAL_PERSIST: string = `setGlobalPersist`;

  /**
   * 获取主题的持久化信息
   */
  export const GET_GLOBAL_PERSIST: string = `getGlobalPersist`;

  /**
   * 获取需要更新的主题
   */
  export const GET_UPDATE_THEME_LIST: string = `getUpdateThemeList`;

  /**
   * 忽略需要更新的主题
   */
  export const IGNORE_UPDATE_THEME: string = `ignoreUpdateTheme`;

  /**
   * 清除所有更新主题缓存
   */
  export const CLEAR_UPDATE_THEME_ALL_CACHE: string = `clearUpdateThemeAllCache`;
}