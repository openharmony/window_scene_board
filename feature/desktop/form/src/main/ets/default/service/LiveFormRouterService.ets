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

import { rpc } from '@kit.IPCKit';
import { StartAbilityUtil } from '@ohos/windowscene';
import { CheckEmptyUtils, LogDomain, Logger, StartType } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CloseAppManager, FormConstants, IExecutor, LiveFormSupportMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { IRequestService } from '@ohos/componenthelper/src/main/ets/utils/BaseServiceStub';
import { RequestMethod, ServiceReturnMsg } from './ServiceInterface';

const TAG: string = 'LiveFormRouterService';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);

export class LiveFormParam {
  public bundleName?: string;
  public abilityName?: string;
  public formId?: string;
}

export class LiveFormRouterService implements IRequestService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.START_ABILITY_BY_LIVE_FORM, (): IExecutor => new StartAbilityByLiveFormService()],
  ]);

  onRequest(want: Want): void {
    const method: string = String(want.parameters?.requestMethod ?? '');
    if (CheckEmptyUtils.checkStrIsEmpty(method)) {
      log.showWarn(TAG, `onRequest invalid method: ${method}`);
      return;
    }

    const executor: (() => IExecutor) | undefined = LiveFormRouterService.executorMap.get(method);
    if (!executor) {
      log.showWarn(TAG, `onRequest unknown executor, method: ${method}`);
      return;
    }

    executor().execute(want);
  }
}

class StartAbilityByLiveFormService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    if (!extra) {
      log.showError(TAG, 'extra is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }
    let want: Want = extra as Want;
    if (!want.parameters) {
      log.showError(TAG, 'parameters is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }
    let parameters: Record<string, Object> = want.parameters;

    // 解析formId
    if (!parameters[FormConstants.FORM_ID_PARAM]) {
      log.showError(TAG, 'FORM_ID_PARAM is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }
    let formId: string = parameters[FormConstants.FORM_ID_PARAM] as string;

    // 解析目标want
    if (!parameters[FormConstants.JSON_WANT_PARAM]) {
      log.showError(TAG, 'JSON_WANT_PARAM is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }
    let jsonWant: string = parameters[FormConstants.JSON_WANT_PARAM] as string;
    let targetWant: Want;
    try {
      targetWant = JSON.parse(jsonWant);
    } catch (err) {
      log.showError(TAG, `Failed to parse jsonWant, code: ${err?.code}, message: ${err?.message}`);
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    // 拉起互动卡片
    if (!targetWant.bundleName) {
      log.showError(TAG, 'bundleName is missing in targetWant!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }
    log.showInfo(TAG, `StartAbilityByLiveFormService, formId: ${formId}, targetBundleName: ${targetWant.bundleName}`);
    CloseAppManager.getInstance().setStartAppType(StartType.CARD, formId, undefined, undefined,
      targetWant.bundleName);
    StartAbilityUtil.startAbilityFromOther(targetWant);
    return ServiceReturnMsg.RET_SUCCESS;
  }
}

