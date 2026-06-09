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

import { OnlineThemeInfo } from '../../remote/model/OnlineThemeInfo';


/**
 * 通知主题App刷新缓存场景 0: 账号变化 1：手机系统时间修改 2：应用主题
 */
export type NotifyUpdateScene = 0 | 1 | 2;

export const NOTIFY_UPDATE_SCENE_HWID: NotifyUpdateScene = 0;

export const NOTIFY_UPDATE_SCENE_TIME: NotifyUpdateScene = 1;

export const NOTIFY_UPDATE_SCENE_THEME: NotifyUpdateScene = 2;

/**
 * 主题会员资源服务
 */
export interface ThemeVipService {
  /**
   * 从所有应用过的主题缓存信息中，获取资源ID不重复的在线资源数组，
   * @returns 在线资源数组
   */
  getOnlineThemeList(): Promise<Nullable<OnlineThemeInfo[]>>;

  /**
   * 主题App返回在线资源数组，更新到主题缓存信息中
   * @param onlineThemes 待更新的在线资源数组
   * @returns ThemeCode.SUCCESS 操作成功
   */
  updateOnlineTheme(onlineThemeInfos: OnlineThemeInfo[], vipExpirationDate: number): Promise<number>;

  /**
   * 通知主题App刷新缓存
   * @param isNeedClean 是否需要清理在线资源会员信息
   * @param scene 通知主题App刷新缓存场景 0: 账号变化 1：手机系统时间修改 2：应用主题
   * @returns 无返回
   */
  notifyUpdateOnlineTheme(isNeedClean: boolean, scene: NotifyUpdateScene): Promise<void>;
}