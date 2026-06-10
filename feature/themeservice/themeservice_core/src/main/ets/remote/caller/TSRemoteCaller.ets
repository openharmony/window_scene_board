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

import { Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { TrialContentType } from '@ohos/themeservice_inner_api/Index';
import { ContextUtil, JsonUtils, RemoteCaller } from '@ohos/themeservicebase/Index';
import { OnlineThemeInfo } from '../model/OnlineThemeInfo';
import { PreThemeInfo } from '../model/PreThemeInfo';
import { SearchItems, ThemeSearchInfo } from '../model/ThemeSearchInfo';

const TAG: string = 'TSRemoteCaller';

/**
 * 主题App无法拉起UI，需Ts拉起主题App UI界面
 */
export const RESULT_TO_THEME_APP_UI: number = -2;

/**
 * 限时免费主题到期通知
 */
export const NOTIFY_THEME_APP_EXPIRES: number = 1;

/**
 * 限时免费主题提前通知
 */
export const NOTIFY_THEME_APP_EXPIRES_ADVANCED: number = 2;

/**
 * 试用到期通知主题App，主题App返回数据结构
 */
export interface TrialExpiresResult {
  /**
   * 错误码，0：主题App正常处理，-2：主题App无法拉起UI，需Ts拉起主题App UI界面
   */
  errCode: number;

  /**
   * 主题App处理回退结果，true：主题App正常处理，false：主题App拉起UI出错或校验权限不通过，需TS执行回退默认主题/字体操作
   */
  returnValue: boolean;
}

export interface UpdatableResourceResult {
  /**
   * 错误码，0：返回正常
   */
  errCode: number;

  /**
   * 主题app返回的需要更新的主题信息,json数据数组
   */
  returnValue: string[];
}

/**
 * 搜索词注入，设置返回数据结构
 */
export interface ThemeSearchResult {
  /**
   * 设置返回结果，success：操作成功，fail：操作失败，invalid method：无效方法
   */
  resultValue: string;
}

export namespace TSRemoteCaller {
  /**
   * 命令编号：使能搜索项
   */
  const SETTINGS_ENABLE_SEARCH_ITEMS: number = 2;
  /**
   * 命令编号：试用过期通知，对应主题App方法 trialExpires
   */
  const COMMAND_TRIAL_EXPIRES: number = 5;
  /**
   * 命令编号：通知主题App更新在线资源缓存
   */
  const COMMAND_NOTIFY_UPDATE_ONLINE_THEME: number = 6;
  /**
   * 命令编号：通知主题App更新计时器时长
   */
  const COMMAND_NOTIFY_CORRECT_DURATION: number = 7;
  /**
   * 命令编号：限免过期通知
   */
  const COMMAND_LIMITEDFREE_EXPIRES: number = 8;
  /**
   * 命令编号：请求主题app返回待更新的主题信息
   */
  const COMMAND_GET_UPDATABLE_RES: number = 10;
  /**
   * 需要拉起的主题App对应ServiceExtAbility
   */
  const THEME_APP_SERVICE_WANT: Want = {
    bundleName: 'com.ohos.thememanager',
    abilityName: 'ThemeOpenServiceExtAbility'
  };
  /**
   * 需要拉起的设置对应SettingsExtService
   */
  const SETTINGS_SERVICE_WANT: Want = {
    bundleName: 'com.ohos.settings',
    abilityName: 'SettingsExtService'
  };
  /**
   * 试用到期通知主题app
   * @param trialType 试用类型
   * @param contentId 试用内容ID
   * @param prevThemeData 待回退主题信息
   * @returns 通知结果 true：通知成功， false: 通知失败默认兜底回退
   */
  export function notifyTrialExpires(trialType: TrialContentType, contentId: string,
    prevThemeData: PreThemeInfo): Promise<TrialExpiresResult | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(), THEME_APP_SERVICE_WANT)
      .sendMessageRequest<TrialExpiresResult | undefined>(COMMAND_TRIAL_EXPIRES,
        (req: rpc.MessageSequence) => {
          req.writeString(trialType);
          req.writeString(contentId);
          req.writeString(JsonUtils.stringify(prevThemeData));
        },
        (reply: rpc.MessageSequence) => {
          let result: TrialExpiresResult = {
            errCode: reply.readInt(),
            returnValue: reply.readBoolean()
          }
          return result;
        });
  }

  /**
   * 限免到期通知主题app
   * @param contentType 试用类型
   * @param contentId 试用内容ID
   * @param prevThemeData 待回退主题信息
   * @param tpye 通知类型 1、限时免费主题到期通知 2、限时免费主题提前通知
   * @returns 通知结果 true：通知成功， false: 通知失败默认兜底回退
   */
  export function noticeLimitFree(contentType: TrialContentType, contentId: string,
    prevThemeData: PreThemeInfo, type: number): Promise<TrialExpiresResult | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(), THEME_APP_SERVICE_WANT)
      .sendMessageRequest<TrialExpiresResult | undefined>(COMMAND_LIMITEDFREE_EXPIRES,
        (req: rpc.MessageSequence) => {
          req.writeString(contentType);
          req.writeString(contentId);
          req.writeString(JsonUtils.stringify(prevThemeData));
          req.writeInt(type);
        },
        (reply: rpc.MessageSequence) => {
          let result: TrialExpiresResult = {
            errCode: reply.readInt(),
            returnValue: reply.readBoolean()
          }
          return result;
        });
  }

  /**
   * 校准限免主题信息
   * @param contentType 试用类型
   * @param contentId 试用内容ID
   * @param prevThemeData 待回退主题信息
   * @returns 通知结果 true：通知成功， false: 通知失败默认兜底回退
   */
  export function notifyCorrectLimiteFreeDuration(): Promise<TrialExpiresResult | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(), THEME_APP_SERVICE_WANT)
      .sendMessageRequest<TrialExpiresResult | undefined>(COMMAND_NOTIFY_CORRECT_DURATION,
        (req: rpc.MessageSequence) => {
        },
        (reply: rpc.MessageSequence) => {
          let result: TrialExpiresResult = {
            errCode: reply.readInt(),
            returnValue: reply.readBoolean()
          }
          return result;
        });
  }

  export function notifyUpdateOnlineTheme(scene: number,
    onlineThemes?: OnlineThemeInfo[]): Promise<number | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(), THEME_APP_SERVICE_WANT)
      .sendMessageRequest<number | undefined>(COMMAND_NOTIFY_UPDATE_ONLINE_THEME,
        (req: rpc.MessageSequence) => {
          req.writeInt(scene);
          req.writeString(JsonUtils.stringify(onlineThemes));
        },
        (reply: rpc.MessageSequence) => {
          return reply.readInt();
        });
  }

  export function getUpdatableResourceList(contentType: string = 'theme'):
    Promise<UpdatableResourceResult | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(),
      THEME_APP_SERVICE_WANT).sendMessageRequest<UpdatableResourceResult | undefined>(COMMAND_GET_UPDATABLE_RES,
      (req: rpc.MessageSequence) => {
        req.writeString(contentType);
      },
      (reply: rpc.MessageSequence) => {
        let result: UpdatableResourceResult = {
          errCode: reply.readInt(),
          returnValue: reply.readStringArray(),
        };
        return result;
      });
  }

  /**
   * 主题包搜索词动态注入设置
   * @param method 方法名
   * @param searchItems 搜索词内容
   * @returns 操作结果 success：操作成功，fail：操作失败，invalid method：无效方法
   */
  export function notifySearchItems(method: string, searchItems: SearchItems): Promise<ThemeSearchResult | undefined> {
    return new RemoteCaller(ContextUtil.getTsServiceContext(), SETTINGS_SERVICE_WANT)
      .sendMessageRequest<ThemeSearchResult | undefined>(SETTINGS_ENABLE_SEARCH_ITEMS,
        (req: rpc.MessageSequence) => {
          let themeSearchInfo: ThemeSearchInfo = { method: method, extra: searchItems};
          req.writeString(JSON.stringify(themeSearchInfo));
        },
        (reply: rpc.MessageSequence) => {
          let result: ThemeSearchResult = {
            resultValue: reply.readString()
          };
          return result;
        });
  }
}