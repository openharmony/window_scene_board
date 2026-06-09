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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CardItemInfo, FormConstants, IExecutor } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormEditViewManager, FormEditViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import { IRequestService } from '@ohos/componenthelper/src/main/ets/utils/BaseServiceStub';
import { RequestMethod, ServiceReturnMsg } from './ServiceInterface';

const TAG: string = 'FormEditRouterService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormEditRouterService implements IRequestService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.OPEN_FORM_EDIT_VIEW, (): IExecutor => new OpenFormEditService()],
    [RequestMethod.CLOSE_FORM_EDIT_VIEW, (): IExecutor => new CloseFormEditService()],
    [RequestMethod.OPEN_FORM_EDIT_SEC_PAGE_VIEW, (): IExecutor => new OpenFormEditSecPageService()],
    [RequestMethod.CLOSE_FORM_EDIT_SEC_PAGE_VIEW, (): IExecutor => new CloseFormEditSecPageService()],
  ]);

  onRequest(want: Want): void {
    const method: string = String(want.parameters?.requestMethod ?? '');
    if (CheckEmptyUtils.checkStrIsEmpty(method)) {
      log.showWarn(`onRequest invalid method: ${method}`);
      return;
    }

    const executor: (() => IExecutor) | undefined = FormEditRouterService.executorMap.get(method);
    if (!executor) {
      log.showWarn(`onRequest unknown executor, method: ${method}`);
      return;
    }

    let extra: FormEditViewParam = new FormEditViewParam();
    extra.bundleName = want.parameters?.[FormConstants.BUNDLE_PARAM] as string;
    extra.formInfo = want.parameters?.formInfo as CardItemInfo;
    extra.viewHeight = want.parameters?.viewHeight as number;
    extra.secPageAbilityName = want.parameters?.secPageAbilityName as string;

    executor().execute(extra);
  }
}

class OpenFormEditService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let extraData: FormEditViewParam | undefined = extra as FormEditViewParam;
    if (CheckEmptyUtils.isEmpty(extraData)) {
      log.showError('extraData is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    log.showInfo('open form edit view.');
    FormEditViewManager.getInstance().openFormEditView(extraData);
    return ServiceReturnMsg.RET_SUCCESS;
  }
}

class CloseFormEditService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    log.showInfo('close form edit view.');
    FormEditViewManager.getInstance().closeFormEditView();
    return ServiceReturnMsg.RET_SUCCESS;
  }
}

class OpenFormEditSecPageService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let extraData: FormEditViewParam | undefined = extra as FormEditViewParam;
    if (CheckEmptyUtils.isEmpty(extraData)) {
      log.showError('extraData is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    log.showInfo(`open form edit second page view, bundleName: ${extraData.bundleName}`);
    FormEditViewManager.getInstance().openFormEditSecPageView(extraData);
    return ServiceReturnMsg.RET_SUCCESS;
  }
}

class CloseFormEditSecPageService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    log.showInfo('close form edit second page view.');
    FormEditViewManager.getInstance().closeFormEditSecPageView();
    return ServiceReturnMsg.RET_SUCCESS;
  }
}

