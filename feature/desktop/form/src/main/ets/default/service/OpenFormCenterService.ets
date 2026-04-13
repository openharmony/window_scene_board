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
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { BaseServiceStubUtils } from '@ohos/componenthelper';
import { PageRouterServiceCode } from '@ohos/commonconstants';
import { FormCenterViewManager, IExecutor } from '@ohos/launchercommon';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormCenterResponse, FormCenterResponseCode, ServiceReturnMsg } from './ServiceInterface';

const TAG: string = 'OpenFormCenterService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class OpenFormCenterService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let extraData: FormCenterViewParam | undefined = extra as FormCenterViewParam;
    if (CheckEmptyUtils.isEmpty(extraData)) {
      log.showError('extraData is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    log.showInfo(`open form center, height: ${extraData.viewHeight}. ${extraData.formDisplayType}`);
    FormCenterViewManager.getInstance().openFormCenterView(extraData);

    // 处理卡片管理加卡的结果
    GlobalContext.getContext()?.eventHub.on('waitFormCenterResponse',
      (response: FormCenterResponse) => this.handleOpenFormCenterResult(remoteObject, response));
    return ServiceReturnMsg.RET_SUCCESS;
  }

  private handleOpenFormCenterResult(remoteObject: rpc.IRemoteObject | null | undefined,
    response: FormCenterResponse): void {
    if (!remoteObject || !response) {
      GlobalContext.getContext()?.eventHub.off('waitFormCenterResponse');
      log.showError('remoteObject or response is null!');
      return;
    }
    log.showInfo(`responseCode: ${response.code}`);
    if ((response.code === FormCenterResponseCode.ADD_FORM ||
      response.code === FormCenterResponseCode.DRAG_FORM_START) && !response.formInfo) {
      log.showError('can not add empty formInfo');
      return;
    }
    if (response.code === FormCenterResponseCode.CLOSE_FORM_CENTER) {
      GlobalContext.getContext()?.eventHub.off('waitFormCenterResponse');
    }
    // 此处打桩加卡成功, 通知回调给client端
    let retStr: string = '';
    if (response.code === FormCenterResponseCode.ADD_FORM) {
      retStr =
        JSON.stringify({ code: response.code, formInfo: response.formInfo, startPosition: response.startPosition });
    } else if (response.code === FormCenterResponseCode.DRAG_FORM_START) {
      retStr =
        JSON.stringify({ code: response.code, formInfo: response.formInfo, startPosition: response.startPosition });
    } else {
      retStr = JSON.stringify({ code: response.code });
    }
    const option = new rpc.MessageOption();
    const reply = new rpc.MessageSequence();
    const data = new rpc.MessageSequence();

    try {
      data.writeInterfaceToken(remoteObject.getDescriptor());
    } catch (e) {
      log.showError('write token error');
    }
    BaseServiceStubUtils.writeStringInSegments(data, retStr);
    remoteObject.sendMessageRequest(PageRouterServiceCode.FORM_MANAGE, data, reply, option)
      .then((result) => {
        if (result?.errCode === 0) {
          log.showInfo('send msg request callback result success.');
        }
      })
      .catch((e: Error) => {
        log.showError(`send msg request callback result failed, message:${e?.message}.`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }
}