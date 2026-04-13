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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { rpc } from '@kit.IPCKit';
import { bundleManager } from '@kit.AbilityKit';
import { QuickBarConnectEvent, QuickBarServiceManager } from './QuickBarServiceManager';
import { ErrorCode } from '../utils/DockMenuTaskUtils';
import { PcDockHiSysEventMgr } from '../manager/PcDockHiSysEventMgr';

const TAG = 'QuickBarServiceStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CHECK_TAG = 'PCService_QuickBarManager';

export class QuickBarStub extends rpc.RemoteObject {
  constructor(des: string) {
    super(des);
  }

  async onRemoteMessageRequest(
    code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    options: rpc.MessageOption
  ): Promise<boolean> {
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PHONE) {
      return false;
    }
    try {
      let callingSlot: number = rpc.IPCSkeleton.getCallingTokenId();
      let callingP: number = rpc.IPCSkeleton.getCallingPid();
      let callingUid: number = rpc.IPCSkeleton.getCallingUid();
      let bundleName: string = bundleManager.getBundleNameByUidSync(callingUid);
      if (data.readInterfaceToken() !== CHECK_TAG) {
        log.showWarn('onRemoteMessageRequest unknown request');
        return false;
      }
      log.showInfo(`onRemoteMessageRequest action ${code}, bundleName: ${bundleName},` +
        ` who calls: ${callingP}, slot: ${callingSlot}, isAsync: ${options.isAsync()}`);
      switch (code) {
        case QuickBarConnectEvent.GET_CUSTOM_CATEGORIES:
          await this.getCustomCategories(bundleName, reply);
          break;
        case QuickBarConnectEvent.ADD_CUSTOM_CATEGORY:
          await this.addCustomCategory(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.UPDATE_CUSTOM_CATEGORY:
          await this.updateCustomCategory(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.DELETE_CUSTOM_CATEGORY:
          await this.deleteCustomCategory(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.GET_TASKS_FROM_CATEGORY:
          await this.getTasksFromCategory(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.ADD_QUICK_TASK:
          await this.addQuickTask(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.UPDATE_QUICK_TASK:
          await this.updateQuickTask(bundleName, data, reply);
          break;
        case QuickBarConnectEvent.DELETE_QUICK_TASK:
          await this.deleteQuickTask(bundleName, data, reply);
          break;
      }
      return true;
    } catch (err) {
      log.showError(`onRemoteMessageRequest err code: ${err.code}`);
      return false;
    }
  }

  private async getCustomCategories(bundleName: string, reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`getCustomCategories`);
    const res = await QuickBarServiceManager.getInstance().getCustomCategories(bundleName, reply);
    this.processErrorCode(res, reply);
  }

  private async addCustomCategory(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`addCustomCategory`);
    PcDockHiSysEventMgr.reportOperationCategory(bundleName, 'addMenu');
    const res: number = await QuickBarServiceManager.getInstance().addCustomCategory(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private async updateCustomCategory(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`updateCustomCategory`);
    const res: number = await QuickBarServiceManager.getInstance().updateCustomCategory(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private async deleteCustomCategory(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`deleteCustomCategory`);
    PcDockHiSysEventMgr.reportOperationCategory(bundleName, 'delMenu');
    const res: number = await QuickBarServiceManager.getInstance().deleteCustomCategory(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private async getTasksFromCategory(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`getTasksFromCategory`);
    const res = await QuickBarServiceManager.getInstance().getTasksFromCategory(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private async addQuickTask(bundleName: string, data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`addQuickTask`);
    PcDockHiSysEventMgr.reportOperationTask(bundleName, 'addMenu');
    const res = await QuickBarServiceManager.getInstance().addQuickTask(bundleName, data, reply);
    log.showInfo(`addQuickTask`);
    this.processErrorCode(res, reply);
  }

  private async updateQuickTask(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`updateQuickTask`);
    const res: number = await QuickBarServiceManager.getInstance().updateQuickTask(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private async deleteQuickTask(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<void> {
    log.showInfo(`deleteQuickTask`);
    PcDockHiSysEventMgr.reportOperationTask(bundleName, 'delMenu');
    const res: number = await QuickBarServiceManager.getInstance().deleteQuickTask(bundleName, data, reply);
    this.processErrorCode(res, reply);
  }

  private processErrorCode(res: number, reply: rpc.MessageSequence): void {
    if (res !== ErrorCode.OK) {
      reply.writeBoolean(res !== ErrorCode.OK);
      reply.writeInt(res);
    }
  }
}

export function createQuickBarStub(des: string): QuickBarStub {
  return new QuickBarStub(des);
}