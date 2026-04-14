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

import wantAgentController from '@ohos.app.ability.wantAgent';
import { NotificationAction } from '@ohos/systemuicommon';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { GlassNtfActionManager } from '../manager/GlassNtfActionManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'GlassNtfActionVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NtfActionVM {
  private callback: ActionCallback | null = null;

  /*
   * 初始化通知动作回调
   *
   * @param callback
   * */
  public init(callback: ActionCallback): void {
    if (!callback) {
      return;
    }
    this.callback = callback;
  }

  /*
   * 注销通知横幅回调
   * */
  public onDestroy(): void {
    if (this.callback) {
      this.callback = null;
    }
  }

  /*
   * 开始触发通知消息携带的意图
   *
   * @param action
   * @param isAutoCancel
   * @param inputContent
   * */
  public startNtfAction(action: NotificationAction, isAutoCancel: boolean, inputContent?: string): void {
    if (!action) {
      return;
    }
    let entry = this.callback?.getNtfEntry();
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    if (entry) {
      log.info('startNtfAction: ' + entry.hashCode + ', ' + entry.getGroupTypeKey());
    }
    this.checkAndStart(action, isAutoCancel, inputContent);
  }

  /*
   * 效验并触发通知消息携带的action意图
   *
   * @param action
   * @param isAutoCancel
   * @param inputContent
   * */
  public checkAndStart(action: NotificationAction, isAutoCancel: boolean, inputContent?: string): void {
    if (!action) {
      return;
    }
    try {
      log.info('Start call getOperationType');
      wantAgentController.getOperationType(action.wantAgent).then((data: number) => {
        log.info(`getOperationType ok! ${data}`);
        this.startActionInner(action, isAutoCancel, inputContent);
      }).catch(() => {
        log.showError('getOperationType failed1');
        this.startActionInner(action, isAutoCancel, inputContent);
      });
    } catch (err) {
      log.showError('getOperationType failed2');
      this.startActionInner(action, isAutoCancel, inputContent);
    }
  }

  /*
   * 触发通知内部意图
   *
   * @param action
   * @param isAutoCancel
   * @param inputContent
   * */
  public startActionInner(action: NotificationAction, isAutoCancel: boolean, inputContent?: string): void {
    if (!action) {
      return;
    }
    let entry = this.callback?.getNtfEntry();
    this.startActionWantAgent(action, isAutoCancel, entry as NotificationEntry, inputContent);
  }

  /*
   * 触发消息意图
   *
   * @param action
   * @param isAutoCancel
   * @param inputContent
   * @param ntfEntry
   * */
  public startActionWantAgent = (action: NotificationAction,
    isAutoCancel: boolean,
    ntfEntry: NotificationEntry,
    inputContent?: string
  ): void => {
    if (!action) {
      log.showInfo(`startActionWantAgent cancel,action is invalid`);
      return;
    }
    GlassNtfActionManager.getInstance().startWantAgent(action.wantAgent, undefined, action.userInputKey, inputContent);
    log.info('startActionWantAgent action: ' + action.actionTitle + ', isAutoCancel: ' + isAutoCancel +
      ', isAutoDelete: ' + ntfEntry.isAutoDelete + ', ntf: ' + ntfEntry.hashCode + ', ' + ntfEntry.getGroupTypeKey());
    if (isAutoCancel && ntfEntry.isAutoDelete) {
      GlassNtfActionManager.getInstance().removeNotificationByClick(ntfEntry);
    }
  }
}

/**
 * 组件回调器
 */
export interface ActionCallback {
  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry | null;

  /**
   * 获取通知面板类型
   *
   * @return 通知面板类型
   */
  getNtfType(): number;
}