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

import type { IExecutor } from '@ohos/launchercommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { HandleDialogClick } from './impl/HandleDialogClick';
import { QueryExposeEventLogs } from './impl/QueryExposeEventLogs';
import { QueryFormDistribution } from './impl/QueryFormDistribution';
import { QuerySpecifiedScreenInfos } from './impl/QuerySpecifiedScreenInfos';
import { RemoveAbilityForm } from './impl/RemoveAbilityForm';
import { ResetAiSuggestionForms } from './impl/ResetAiSuggestionForms';
import { UpdateAiSuggestionForms } from './impl/UpdateAiSuggestionForms';
import { AddCardToDesktop } from './impl/AddCardToDesktop';
import { GetAppAllowList } from './impl/GetAppAllowList';
import { QueryFormDistributions } from './impl/QueryFormDistributions';
import { QueryLauncherFormAndFormstackInfos } from './impl/QueryLauncherFormAndFormstackInfos';
import lazy { GetAppCategory, GetCardIsAddToOuter, QueryIsBlockApps } from './impl/QueryOuterAppManager';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'AiSuggestionService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 请求方法
 *
 * @since 2023-08-11
 */
export const enum RequestMethod {
  /**
   * 查询特定FA卡片在桌面分布情况
   */
  GET_FORM_DISTRIBUTION = 'getFormDistribution',

  /**
   * 查询所在屏幕对应的展示信息
   */
  GET_SPECIFIED_SCREEN_INFOS = 'getSpecifiedScreenInfos',

  /**
   * 查询曝光数据
   */
  GET_EXPOSE_EVENT_LOGS = 'getExposeEventLogs',

  /**
   * 语音助手建议主动刷新服务卡片
   */
  UPDATE_AI_SUGGESTION_FORMS = 'updateAiSuggestionForms',

  /**
   * 语音助手建议主动停止服务推荐
   */
  RESET_AI_SUGGESTION_FORMS = 'resetAiSuggestionForms',

  /**
   * 删除语音助手建议卡片
   */
  REMOVE_ABILITY_FORM = 'removeAbilityForm',

  /**
   * 语音助手建议对话框取消操作
   */
  DIALOG_CLICK_CANCEL = 'onDialogClickCancel',

  /**
   * 语音助手建议添加到桌面
   */
  ADD_CARD_TO_DESKTOP = 'addCardToDesktop',

  /**
   * 应用列表
   */
  GET_APP_ALLOW_LIST = 'getAppAllowList',

  /**
   * 小折叠查询特定FA卡片在桌面分布情况
   */
  GET_FORM_DISTRIBUTIONS = 'getFormDistributions',

  /**
   * 查询桌面所有的卡片和堆叠信息
   */
  GET_LAUNCHER_FORM_AND_FORMSTACK_INFOS = 'getLauncherFormAndFormstackInfos',

  /**
   * 判断多个应用或ability是否是未适配应用
   */
  QUERY_IS_BLOCK_APPS = 'queryIsBlockApps',

  /**
   * 获取应用分类
   */
  GET_APP_CATEGORY = 'getAppCategory',

  /**
  * 获取卡片是否可添加至外屏
  */
  GET_CARD_IS_ADD_TO_OUTER = 'getCardIsAddToOuter',
}

/**
 * 语音助手建议业务服务
 *
 * @since 2023-08-11
 */
export class AiSuggestionService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.GET_FORM_DISTRIBUTION, (): IExecutor => new QueryFormDistribution()],
    [RequestMethod.GET_SPECIFIED_SCREEN_INFOS, (): IExecutor => new QuerySpecifiedScreenInfos()],
    [RequestMethod.GET_EXPOSE_EVENT_LOGS, (): IExecutor => new QueryExposeEventLogs()],
    [RequestMethod.UPDATE_AI_SUGGESTION_FORMS, (): IExecutor => new UpdateAiSuggestionForms()],
    [RequestMethod.RESET_AI_SUGGESTION_FORMS, (): IExecutor => new ResetAiSuggestionForms()],
    [RequestMethod.REMOVE_ABILITY_FORM, (): IExecutor => new RemoveAbilityForm()],
    [RequestMethod.DIALOG_CLICK_CANCEL, (): IExecutor => new HandleDialogClick()],
    [RequestMethod.ADD_CARD_TO_DESKTOP, (): IExecutor => new AddCardToDesktop()],
    [RequestMethod.GET_APP_ALLOW_LIST, (): IExecutor => new GetAppAllowList()],
    [RequestMethod.GET_FORM_DISTRIBUTIONS, (): IExecutor => new QueryFormDistributions()],
    [RequestMethod.GET_LAUNCHER_FORM_AND_FORMSTACK_INFOS, (): IExecutor => new QueryLauncherFormAndFormstackInfos()],
    [RequestMethod.QUERY_IS_BLOCK_APPS, (): IExecutor => new QueryIsBlockApps()],
    [RequestMethod.GET_APP_CATEGORY, (): IExecutor => new GetAppCategory()],
    [RequestMethod.GET_CARD_IS_ADD_TO_OUTER, (): IExecutor => new GetCardIsAddToOuter()],
  ]);

  async onCall(json: string): Promise<string> {
    let msg: CallMessage | undefined = undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return Response.INVALID_METHOD_ERROR;
    }

    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}`);
    const executor = AiSuggestionService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}`);
      return Response.UNKNOWN_METHOD_ERROR;
    }
    return executor().execute(msg.extra);
  }

  isSupportSegments(): boolean {
    return true;
  }
}

/**
 * 请求消息
 *
 * @since 2023-08-11
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}