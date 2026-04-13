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
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import BundleResourceModel from '@ohos/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';

const TAG = 'TipsJump';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const APP_BUNDLE_NAME = '';
const TIPS_APP_ID = '';
const URI_FORMATTER = '';
const CODE_SUCCESS_ERROR = 0;
type startAbleContext = common.UIAbilityContext | common.ServiceExtensionContext;

/**
 * 玩机页面卡片枚举
 */
export enum FunType {
  SMART_REMINDER = 'SF-10044804_f009'
}

/**
 * 玩机页面大数据统计类型枚举
 */
export enum RecordType {
  SMART_REMINDER = '127'
}

/**
 * 内嵌帮助接入玩机技巧
 *
 */
export class TipsJumpUtils {
  /**
   * 跳转到玩机技巧指定页面
   *
   * @param startAbleContext 上下文,类型要求：common.UIAbilityContext |
   common.ServiceExtensionContext
   * @param funNum:页面FunNum
   * @param type 入口类型ID，用于打点
   */
  public static jumpTips(context: startAbleContext, funNum: string, type: string): void {
    let uri = util.format(URI_FORMATTER, funNum, type);
    TipsJumpUtils.jumpAppByUri(context, uri);
  }

  /**
   * 跳转到OpenHarmony应用的指定页面，使用uri方式
   */
  private static jumpAppByUri(context: startAbleContext, uri: string): void {
    log.showInfo('try jump to app');
    let want: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri
    };
    context.startAbility(want, (err: BusinessError) => {
      if (err.code !== CODE_SUCCESS_ERROR) {
        log.showWarn('jump to [tips app] failed, err msg : %{private}s',
          err.message);
      } else {
        log.showInfo('jump to [tips app] success');
      }
    });
  }

  public static isAppInstalled(): Promise<boolean> {
    const bundleModel = new BundleResourceModel();
    return bundleModel.isSpecificAppInstalled(APP_BUNDLE_NAME, TIPS_APP_ID);
  }
}