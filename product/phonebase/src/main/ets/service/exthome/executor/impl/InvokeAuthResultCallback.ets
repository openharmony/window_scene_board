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

import rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, EventManager, OuterHomeCallbackEvent } from '@ohos/frameworkwrapper';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { IExecutor } from '../IExecutor';
import { BundleVerifyUtils } from '../../BundleVerifyUtils';

const TAG = 'InvokeAuthResultCallback';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const REQUIRE_PERMISSION: string = 'ohos.permission.ACCESS_SCREEN_LOCK_INNER';
const CODE_SHOW_SIMPIN_STATE: number = 2;

/**
 * 指纹，人脸识别认证结果，sim卡显示状态回调
 *
 * @since 2024-05-22
 */
export class InvokeAuthResultCallback implements IExecutor {
  public mRemoteObject: rpc.IRemoteObject | null = null;
  public eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 指纹，人脸识别认证结果、sim卡显示状态监听、wakeUp事件
   * @param extra
   * @param remoteObject
   */
  async execute(extra?: object, remoteObject?: rpc.IRemoteObject | null): Promise<void> {
    log.info('invoke auth result callback');
    if (!remoteObject) {
      log.error('remoteObject is null');
      return;
    }
    if (this.mRemoteObject) {
      log.info('remoteObject is already exists, unregister event');
      this.mRemoteObject = null;
      this.eventMgr.offAll();
    }
    this.mRemoteObject = remoteObject;
    this.eventMgr.on(OuterHomeCallbackEvent, (event: OuterHomeCallbackEvent) => {
      if (!this.mRemoteObject) {
        log.error('mRemoteObject is null');
        return;
      }
      let option = new rpc.MessageOption();
      let reply = new rpc.MessageSequence();
      let data = new rpc.MessageSequence();
      data.writeString(event.eventData);
      this.mRemoteObject.sendMessageRequest(event.eventCode, data, reply, option).then((result) => {
        const RESULT_SUCCESS: number = 0;
        if (result?.errCode !== RESULT_SUCCESS) {
          log.error(`send auth result failed , errCode is ${result?.errCode}`);
        }
      }).catch((e: Error) => {
        log.error(`send auth result error, message:${e?.message}`);
      }).finally(() => {
        data.reclaim();
        reply.reclaim();
      });
    });
    if (ScreenLockApi.isSimLocked()) {
      let shouldShowSIMCard: boolean = true;
      const eventData = JSON.stringify({ shouldShowSIMCard: shouldShowSIMCard });
      let outerHomeCallbackEvent = new OuterHomeCallbackEvent(CODE_SHOW_SIMPIN_STATE, eventData);
      EvtBus.post(OuterHomeCallbackEvent, outerHomeCallbackEvent);
    }
  }

  /**
   * 获取指纹，人脸识别认证结果权限认证
   */
  async verifyIdentity(bundleName: string): Promise<boolean> {
    if (!BundleVerifyUtils.hasPermission(bundleName, REQUIRE_PERMISSION)) {
      log.error(`verifyIdentity failed, reason: permission denied, bundleName:${bundleName}`);
      return false;
    }
    return true;
  }
}