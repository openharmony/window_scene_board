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

import { rpc } from '@kit.IPCKit';
import Want from '@ohos.app.ability.Want';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import type { IService } from '@ohos/componenthelper';
import { CardItemInfo, CommonConstants, FormConstants, IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormModel } from '@ohos/launchercommon/src/main/ets/model/FormModel';
import { IRequestService } from '@ohos/componenthelper/src/main/ets/utils/BaseServiceStub';
import { FormCenterViewParam, TemplateCardInfo } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { OpenFormManageService } from './OpenFormManageService';
import { CallMessage, RequestMethod, ServiceReturnMsg } from './ServiceInterface';
import { OpenFormCenterService } from './OpenFormCenterService';
import { CloseFormCenterService } from './CloseFormCenterService';
import { CloseFormManageService } from './CloseFormManageService';
import { PlayAddFormAnimationService } from './PlayAddFormAnimationService';

const TAG: string = 'FormManageRouterService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormManageRouterService implements IService, IRequestService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.OPEN_FORM_CENTER_VIEW, (): IExecutor => new OpenFormCenterService()],
    [RequestMethod.CLOSE_FORM_CENTER_VIEW, (): IExecutor => new CloseFormCenterService()],
    [RequestMethod.OPEN_FORM_MANAGE_VIEW, (): IExecutor => new OpenFormManageService()],
    [RequestMethod.CLOSE_FORM_MANAGE_VIEW, (): IExecutor => new CloseFormManageService()],
    [RequestMethod.PLAY_ADD_FORM_ANIMATION, (): IExecutor => new PlayAddFormAnimationService()],
  ])

  async onCall(json: string, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let msg: CallMessage;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
      return ServiceReturnMsg.RET_INVALID_JSON_DATA;
    }

    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method.');
      return ServiceReturnMsg.RET_INVALID_METHOD;
    }

    const method: string = msg.method;
    log.showInfo(`onCall method = ${method}.`);
    const executor = FormManageRouterService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onCall unknown method = ${method}.`);
      return ServiceReturnMsg.RET_UNKNOWN_METHOD;
    }

    return executor().execute(msg.extra, remoteObject);
  }

  isSupportSegments(): boolean {
    return true;
  }

  onRequest(want: Want): void {
    const method: string = String(want.parameters?.requestMethod ?? '');
    if (CheckEmptyUtils.checkStrIsEmpty(method)) {
      log.showWarn(`onRequest invalid method: ${method}`);
      return;
    }

    const executor: (() => IExecutor) | undefined = FormManageRouterService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onRequest unknown executor, method: ${method}`);
      return;
    }

    let extra: FormCenterViewParam = new FormCenterViewParam();
    extra.bundleName = want.parameters?.[FormConstants.BUNDLE_PARAM] as string;
    extra.formInfo = this.getFormInfoFromWant(want);
    extra.viewHeight = want.parameters?.viewHeight as number;
    extra.isSupportDrag = want.parameters?.isSupportDrag as boolean;
    extra.isSupportCreateAnimate = want.parameters?.isSupportCreateAnimate as boolean;
    extra.templateCardList = this.getTemplateCardList(want, extra.bundleName);
    executor().execute(extra);
  }

  private getTemplateCardList(want: Want, bundleName: string): TemplateCardInfo[] {
    const isSystemApp: boolean = FormModel.getInstance().isSystemApp(bundleName);
    const isEmptyTargetForm: boolean = CheckEmptyUtils.isEmpty(want.parameters?.[FormConstants.FORM_INFO_LIST]);
    let templateCards: TemplateCardInfo[] = [];
    // 应用内拉起特定卡片只对系统应用生效
    if (isEmptyTargetForm || !isSystemApp) {
      log.showInfo(`not pull up specific cards isEmptyTargetForm: ${isEmptyTargetForm}, isSystemApp: ${isSystemApp}`);
      return templateCards;
    }
    let formInfoList: Object[] = want.parameters?.[FormConstants.FORM_INFO_LIST] as Object[];
    formInfoList = formInfoList.slice(0, 16);
    formInfoList.forEach(i => {
      templateCards.push({
        label: Reflect.get(i, FormConstants.TARGET_FORM_LABEL) as string,
        description: Reflect.get(i, FormConstants.TARGET_FORM_DESCRIPTION) as string,
        dimension: Reflect.get(i, FormConstants.TARGET_FORM_DIMENSION) as number,
        formData: Reflect.get(i, FormConstants.TARGET_FORM_DATA) as string,
      })
    })
    return templateCards;
  }

  private getFormInfoFromWant(want: Want): CardItemInfo {
    let formInfo = want.parameters?.formInfo as CardItemInfo;

    if (CheckEmptyUtils.isEmpty(formInfo)) {
      formInfo = new CardItemInfo();
      formInfo.bundleName = (want.parameters?.[FormConstants.BUNDLE_PARAM] ?? '') as string;
      formInfo.abilityName = (want.parameters?.[FormConstants.ABILITY_PARAM] ?? '') as string;
      formInfo.moduleName = (want.parameters?.[FormConstants.MODULE_PARAM] ?? '') as string;
      formInfo.cardName = (want.parameters?.[FormConstants.NAME_PARAM] ?? '') as string;
      formInfo.cardDimension =
        (want.parameters?.[FormConstants.DIMENSION_PARAM] ?? CommonConstants.CARD_DIMENSION_1x2) as number;
    }

    return formInfo;
  }
}