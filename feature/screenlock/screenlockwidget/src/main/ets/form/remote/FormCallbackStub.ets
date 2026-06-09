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

import rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import FormRemoteUtils from './FormRemoteUtils';

const TAG = 'FormCallbackStub'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export interface FormStartPosition {
  x: number,
  y: number
}

interface RemoteMessage {
  code: number,
  formInfo?: CardItemInfo,
  startPosition?: FormStartPosition,
  index: number
}

/**
 * 卡片中心页返回状态码
 */
export enum FormCenterResponseCode {
  /**
   * 卡片中心页面关闭
   */
  CLOSE_FORM_CENTER = 0,

  ADD_FORM = 1,

  DRAG_FORM_START = 2,

  CREATE_FORM_SUCCESS = 3,

  CREATE_FORM_FAILED = 4,

  JUMP_TO_FORM_MANAGER = 5,

  BACK_TO_FORM_CENTER = 6,

  CREATE_FORM_LIMIT = 7,

  NO_ENOUGH_AREA = 8,

  DROP_ANIMATION_END = 9,

  DRAG_FORM_END = 10
}

export interface FormResponseHandler {
  exitFormCenter: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;

  addForm: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;

  onDragStart: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;

  enterFormManager: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;

  enterFormCenter: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;
  
  onAnimationEnd: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;

  onDragEnd: (cardInfo?: CardItemInfo, position?: FormStartPosition) => void;
}

export class FormCallbackStub extends rpc.RemoteObject {
  private handleMap?: Map<number, Function>;

  constructor(descriptor: string, handler: FormResponseHandler) {
    super(descriptor);
    this.handleMap = new Map([
      [FormCenterResponseCode.CLOSE_FORM_CENTER, handler.exitFormCenter],
      [FormCenterResponseCode.ADD_FORM, handler.addForm],
      [FormCenterResponseCode.DRAG_FORM_START, handler.onDragStart],
      [FormCenterResponseCode.JUMP_TO_FORM_MANAGER, handler.enterFormManager],
      [FormCenterResponseCode.BACK_TO_FORM_CENTER, handler.enterFormCenter],
      [FormCenterResponseCode.DROP_ANIMATION_END, handler.onAnimationEnd],
      [FormCenterResponseCode.DRAG_FORM_END, handler.onDragEnd],
    ])
  }

  public async onRemoteMessageRequest(code: number, data: rpc.MessageSequence,
    reply: rpc.MessageSequence, options: rpc.MessageOption): Promise<boolean> {
    log.showInfo(`onRemoteMessageRequest code = ${code}`);
    let ret: boolean = false;

    try {
      if (data.readInterfaceToken() !== this.getDescriptor()) {
        log.showError(`onRemoteMessageRequest check token failed`);
        return false;
      }
      let msg: RemoteMessage = JSON.parse(FormRemoteUtils.getRemoteString(data)) as RemoteMessage;
      log.showInfo(`msg = ${msg?.code}`)
      this.handleMap?.get(msg.code)?.(msg.formInfo, msg.startPosition);
      ret = !!msg;
    } catch (err) {
      log.showError('onRemoteMessageRequest failed');
    }
    return ret;
  }
}