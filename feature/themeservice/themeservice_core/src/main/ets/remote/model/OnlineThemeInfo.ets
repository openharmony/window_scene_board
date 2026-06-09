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
import { TargetType, TContentPrivStatus } from '@ohos/themeservice_inner_api/Index';

/**
 * 在线主题状态值 disable:0 enable:1 vip:2
 */
const PRIV_STATUS_VALUE: TContentPrivStatus[] = ['disable', 'enable', 'vip'];

/**
 * 提供给主题App的在线资源数据结构
 */
export interface OnlineThemeInfo {
  /**
   * 资源ID
   */
  id: string;

  /**
   * 资源类型
   */
  type: TargetType;

  /**
   * 内容可用状态，disable：0 资源不可用，enable：1 资源可用，vip：2 会员资源需要校验会员是否到期
   */
  contentPrivStatus?: number;
}

/**
 * 从在线资源数据对象 中 获取内容可用状态
 * @param onlineThemeInfo 在线资源数据对象
 * @returns 内容可用状态
 */
export function getContentPrivStatus(onlineThemeInfo?: OnlineThemeInfo): TContentPrivStatus {
  if (onlineThemeInfo === undefined || onlineThemeInfo.contentPrivStatus === undefined) {
    return 'disable'
  }
  return PRIV_STATUS_VALUE[onlineThemeInfo.contentPrivStatus] ?? 'disable';
}

/**
 * 创建在线资源数据类对象
 * @param id 资源id
 * @param type 资源类型
 * @param contentPrivStatus 内容可用状态
 * @returns 在线资源数据类对象
 */
export function createOnlineThemeInfo(id: string, type: TargetType,
  contentPrivStatus?: TContentPrivStatus): OnlineThemeInfo {
  let onlineThemeInfo: OnlineThemeInfo = { id: id, type: type };
  if (!contentPrivStatus) {
    onlineThemeInfo.contentPrivStatus = undefined;
    return onlineThemeInfo;
  }
  let index: number = PRIV_STATUS_VALUE.findIndex(value => value === contentPrivStatus)
  if (index >= 0) {
    onlineThemeInfo.contentPrivStatus = index;
    return onlineThemeInfo;
  }
  onlineThemeInfo.contentPrivStatus = undefined;
  return onlineThemeInfo;
}