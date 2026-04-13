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
import { bundleManager } from '@kit.AbilityKit';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { BaseServiceStubUtils } from '@ohos/componenthelper';
import { PageRouterServiceCode } from '@ohos/commonconstants';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { FormCenterViewManager, IExecutor } from '@ohos/launchercommon';
import { FormCenterViewParam, FormCenterLocation } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormManageResponse, ServiceReturnMsg, SubFormManageResponse } from './ServiceInterface';

const TAG: string = 'OpenFormManageService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const ASDE_BUNDLE = 'com.ohos.asde';

export class OpenFormManageService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    const extraData: FormCenterViewParam | undefined = extra as FormCenterViewParam;
    if (CheckEmptyUtils.checkStrIsEmpty(extraData?.bundleName)) {
      log.showError('bundleName is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    log.showInfo(`open form manage, bundleName: ${extraData.bundleName}` +
      `isSupportDrag: ${extraData.isSupportDrag} isSupportCreateAnimate: ${extraData.isSupportCreateAnimate}.`);
    extraData.openHighIndexView = true;
    extraData.location = FormCenterLocation.SCENE_PANEL;

    try {
      let clientCallUid = rpc.IPCSkeleton.getCallingUid();
      let clientBundleName = bundleManager.getBundleNameByUidSync(clientCallUid);
      log.showInfo(`execute clientBundleName: ${clientBundleName}`);
      extraData.isAsdeOpen = (clientBundleName === ASDE_BUNDLE);
    } catch (error) {
      log.error('execute getBundleName error', error);
    }

    FormCenterViewManager.getInstance().openFormManagerView(extraData);
    // 处理卡片管理操作的结果
    GlobalContext.getContext()?.eventHub.on('waitFormManagerResponse',
      (response: FormManageResponse) => this.handleOpenFormManageResult(remoteObject, response));
    // 处理卡片管理加卡的结果
    GlobalContext.getContext()?.eventHub.on('waitSubFormManagerResponse',
      (subResponse: SubFormManageResponse) => this.handleOpenFormManageResult(remoteObject, subResponse.code,
        subResponse));
    return ServiceReturnMsg.RET_SUCCESS;
  }

  private handleOpenFormManageResult(remoteObject: rpc.IRemoteObject | null | undefined,
    response?: FormManageResponse, subResponse?: SubFormManageResponse): void {
    GlobalContext.getContext()?.eventHub.off('waitFormManagerResponse');
    GlobalContext.getContext()?.eventHub.off('waitSubFormManagerResponse');
    if (!remoteObject) {
      log.showError('remoteObject is null!');
      return;
    }

    // 此处打桩加卡成功, 通知回调给client端
    let retStr: string = '';
    if (subResponse) {
      log.showInfo('subResponse');
      retStr =
        JSON.stringify({
          code: subResponse.code,
          formInfo: subResponse.formInfo,
          startPosition: subResponse.startPosition
        });
    } else {
      retStr = JSON.stringify({ response: response });
    }
    const option = new rpc.MessageOption();
    const reply = new rpc.MessageSequence();
    const data = new rpc.MessageSequence();
    log.showInfo(`response: ${retStr}`);

    BaseServiceStubUtils.writeStringInSegments(data, retStr);
    remoteObject.sendMessageRequest(PageRouterServiceCode.FORM_MANAGE, data, reply, option)
      .then((result) => {
        if (result?.errCode === 0) {
          log.showError('send msg request callback result success.');
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