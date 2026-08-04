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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { BaseServiceStubUtils } from '@ohos/componenthelper';
import { PageRouterServiceCode } from '@ohos/commonconstants';
import type { IExecutor } from '@ohos/launchercommon';
import { ScreenLockAniParam } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniData';
import { screenLockAniMgr, ScreenLockAniScene } from '@ohos/screenlockwidget/src/main/ets/formAni/ScreenLockFormAniMgr';
import {
  AddFormAnimationData,
  FormCenterResponseCode,
  ServiceReturnMsg
} from './ServiceInterface';

const TAG: string = 'PlayAddFormAnimationService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class PlayAddFormAnimationService implements IExecutor {
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    const extraData = extra as AddFormAnimationData;
    if (!extraData) {
      log.showError('open theme form manage failed, extra data is invalid!');
      return ServiceReturnMsg.RET_INVALID_EXTRA_DATA;
    }

    log.showInfo(`start dropAnimation form (${extraData.startPosition.x}, ${extraData.startPosition.y}) to (${extraData.endPosition.x}, ${extraData.endPosition.y})`);
    /* 这段动画有问题，会导致白屏
    let param: ScreenLockAniParam = {
      startPosition: {
        x: extraData.startPosition.x,
        y: extraData.startPosition.y
      },
      endPosition: {
        x: extraData.endPosition.x,
        y: extraData.endPosition.y
      },
      color: extraData.color,
      isLightWallpaper: extraData.isLightWallpaper,
      scaleX: extraData.scaleX,
      scaleY: extraData.scaleY
    }
    screenLockAniMgr.playAnimation(ScreenLockAniScene.BIND_SHEET, extraData.key, param,
      () => {
        this.onDropAnimationEnd(remoteObject)
      });*/
    this.onDropAnimationEnd(remoteObject)
    return ServiceReturnMsg.RET_SUCCESS;
  }

  private onDropAnimationEnd(remoteObject?: rpc.IRemoteObject | null) {
    log.showInfo('onDropAnimationEnd');
    if (!remoteObject) {
      log.showError('remoteObject is null!');
      return;
    }

    const option = new rpc.MessageOption();
    const reply = new rpc.MessageSequence();
    const data = new rpc.MessageSequence();

    try {
      data.writeInterfaceToken(remoteObject.getDescriptor());
    } catch (e) {
      log.showError('write token error');
    }
    let retStr = JSON.stringify({code: FormCenterResponseCode.DROP_ANIMATION_END});
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