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

import type abilityCommon from '@ohos.app.ability.common';
import { bundleManager, common, Want } from '@kit.AbilityKit'
import { rpc } from '@kit.IPCKit'
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CallMessage, RequestMethod } from '../common/ServiceInterface';
import {
  FormDisplayType,
  FormCenterViewParam,
  FormCenterLocation
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import FormRemoteUtils from './FormRemoteUtils';
import { FormCallbackStub, FormResponseHandler } from './FormCallbackStub';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ScreenLockAniParam } from '../../formAni/ScreenLockFormAniData';

const FORM_SERVICE: Want = {
  bundleName: 'com.ohos.sceneboard',
  abilityName: 'PageRouterService'
}

const TAG = 'FormProxy'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SYNC: number = 0;
const WAIT_TIME: number = 3;
const REQUEST_CODE: number = 1;

export default class FormProxy {
  private handler: FormResponseHandler;
  private context?: abilityCommon.ServiceExtensionContext
  private remote?: rpc.IRemoteObject;
  private connectCode?: number;
  private connectOptions?: Promise<void>;
  private data: rpc.MessageSequence = rpc.MessageSequence.create();
  private reply: rpc.MessageSequence = rpc.MessageSequence.create();
  private stub: FormCallbackStub;

  constructor(context: abilityCommon.ServiceExtensionContext, handler: FormResponseHandler) {
    this.context = context;
    this.handler = handler;
    this.stub = new FormCallbackStub('formCallbackStub', this.handler);
  }

  private clearConnectInfo(): void {
    try {
      this.data.reclaim();
      this.reply.reclaim();
    } catch (err) {
      log.showError(`failed to reclaim`);
    }
    this.remote = undefined;
    this.connectCode = undefined;
    this.connectOptions = undefined;
  }

  private connect(): Promise<void> {
    this.connectOptions = new Promise((resolve) => {
      let options: common.ConnectOptions = {
        onConnect: (elementName: bundleManager.ElementName, remote: rpc.IRemoteObject): void => {
          log.showInfo('connect connect');
          this.remote = remote;
          this.data = rpc.MessageSequence.create();
          this.reply = rpc.MessageSequence.create();
          return resolve();
        },
        onDisconnect: (elementName: bundleManager.ElementName): void => {
          log.showInfo('connect disconnect');
          this.clearConnectInfo();
          return resolve();
        },
        onFailed: (code: number): void => {
          log.showError(`connect fail errorCode = ${code}`);
          this.clearConnectInfo();
          return resolve();
        }
      };

      try {
        this.connectCode = this.context?.connectServiceExtensionAbility(FORM_SERVICE, options);
      } catch (err) {
        this.clearConnectInfo();
        log.showError(`connect fail code: ${err.code} message: ${err.message}`);
      }
    });

    return this.connectOptions;
  }

  private async request(method: string, extra: object): Promise<void> {
    if (!this.connectOptions) {
      await this.connectOptions;
    }

    if (!this.remote) {
      await this.connect();
    }

    return this.sendMessage(method, extra);
  }

  private async sendMessage(method: string, extra: object): Promise<void> {
    log.showInfo(`method = ${method}`);
    if (!this.remote) {
      log.showWarn(`Please connect before sending messages, method = ${method}`);
      return;
    }

    let msg: CallMessage = {
      method: method,
      extra: extra
    };

    let ret: boolean = FormRemoteUtils.writeStringInSegments(this.data, JSON.stringify(msg));
    this.data.writeRemoteObject(this.stub);
    if (!ret) {
      log.showError(`failed to writeStringInSegments`);
      return;
    }

    return this.remote.sendMessageRequest(REQUEST_CODE, this.data, this.reply,
      new rpc.MessageOption(SYNC, WAIT_TIME)).then((result) => {
      log.showInfo(`result.errCode = ${result.errCode}`)
      if (result.errCode === 0) {
        let str: string = FormRemoteUtils.getRemoteString(result.reply);
        log.showInfo(`reply = ${str}`);
      }
    }).catch(() => {
      log.showError(`send message failed, method: ${method}`)
    })
  }

  public openFormCenter(extra: FormCenterViewParam): void {
    this.request(RequestMethod.OPEN_FORM_CENTER_VIEW, extra);
  }

  public closeFormCenter(): void {
    this.sendMessage(RequestMethod.CLOSE_FORM_CENTER_VIEW, this.getFormCenterViewParam());
  }

  public closeFormManager(): void {
    this.sendMessage(RequestMethod.CLOSE_FORM_MANAGE_VIEW, this.getFormCenterViewParam());
  }

  private getFormCenterViewParam(): FormCenterViewParam {
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.formDisplayType = FormDisplayType.SCREEN_LOCK_CARD;
    param.openHighIndexView = true;
    param.viewHeight = 0;
    param.viewMaxHeight = 0;
    param.isSupportDrag = true;
    param.isSupportCreateAnimate = true;
    param.location = FormCenterLocation.SCREEN_LOCK;
    return param;
  }

  public playDropAnimation(key: string, aniData: ScreenLockAniParam): void {
    let param: AddFormAnimationData = {
      key: key,
      startPosition: aniData.startPosition,
      endPosition: aniData.endPosition,
      color: aniData.color,
      isLightWallpaper: aniData.isLightWallpaper,
      scaleX: aniData.scaleX,
      scaleY: aniData.scaleY,
    }
    this.sendMessage(RequestMethod.PLAY_ADD_FORM_ANIMATION, param)
  }

  public disConnect(): void {
    if (!this.remote) {
      return;
    }

    try {
      this.context?.disconnectServiceExtensionAbility(this.connectCode)
    } catch (err) {
      log.showError(`failed to disConnect`);
    } finally {
      this.clearConnectInfo();
    }
  }
}

export interface AddFormAnimationData {
  key: string,
  startPosition: Position,
  endPosition: Position,
  color: string,
  isLightWallpaper: boolean,
  scaleX: number,
  scaleY: number
}