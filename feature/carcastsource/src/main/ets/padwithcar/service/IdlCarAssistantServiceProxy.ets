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

import { CheckEmptyUtils, JsonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import IIdlCarAssistantService, { CommonCallBack, RpcMessage } from './IIdlCarAssistantService';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'IdlCarAssistantServiceProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, TAG);
const PROJECTION_SERVICE_TOKEN_NAME: string = 'PROJECTION_SERVICE_TOKEN_NAME';

/**
 * IdlCarAssistantServiceProxy
 *
 * @since 2025-03-12
 */
export default class IdlCarAssistantServiceProxy implements IIdlCarAssistantService {
  public static readonly EVENT_INIT_PROJECTION_SESSION: number = 1;
  public static readonly EVENT_START_MOVE_TASK_TO_VD: number = 2;
  public static readonly ACTION_START_SHELL_ABILITY = 'startShellAbility';
  public static readonly ACTION_ABILITY_IN_PIP = 'abilityInPIP';
  public static readonly ACTION_ABILITY_IS_READY = 'abilityIsReady';
  public static readonly ACTION_KEYBOARD_IS_SHOW = 'keyBoardIsShow';
  public static readonly ACTION_KEYBOARD_IS_HIDE = 'keyBoardIsHide';
  public static readonly ACTION_BACK_GESTURE = 'backGesture';
  public static readonly ACTION_MOVE_TO_MAIN = 'moveToMain';
  public static readonly ACTION_MINIMIZE_SCENE = 'minimizeScene';
  private static readonly COMMAND_SEND_CAR_ASSISTANT = 1;
  private static readonly COMMAND_REGISTER_CALLBACK: number = 2;
  private static readonly COMMAND_UNREGISTER_CALLBACK: number = 3;
  private static readonly SCENE_BOARD_BUNDLE_NAME: string = 'com.ohos.sceneboard';
  private proxy: rpc.IRemoteObject;

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  /**
   * 发送消息至出行助手
   *
   * @param msg msg
   * @param callBack callBack
   */
  sendMsgToCarAssistant(msg: RpcMessage, callBack?: CommonCallBack): void {
    if (CheckEmptyUtils.isEmpty(this.proxy)) {
      log.showWarn('sendMsgToCarAssistant: proxy is invalid');
      return;
    }
    log.showInfo(`sendMsgToCarAssistant: action = ${msg.action}`);
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(PROJECTION_SERVICE_TOKEN_NAME);
    data.writeString(JsonUtils.toJson(msg));
    this.proxy.sendMessageRequest(IdlCarAssistantServiceProxy.COMMAND_SEND_CAR_ASSISTANT, data, reply, option)
      .then((result) => {
        if (result.errCode === 0) {
          callBack?.(result.reply.readString());
        } else {
          log.showWarn(`sendMsgToCarAssistant: fail code = ${result.errCode}`);
        }
      })
      .catch((error: Error) => {
        log.showError(`sendMsgToCarAssistant failed, message = ${error.message}`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }

  /*
   * 注册服务端回调，实现服务端可以回调客户端的接口，完成双向通信
   *
   * @param clientProxy IRemoteObject 本端代理实例
   */
  registerCallback(clientProxy: rpc.IRemoteObject): void {
    if (CheckEmptyUtils.isEmpty(clientProxy)) {
      log.showWarn('registerCallback: clientProxy is empty!');
      return;
    }
    if (CheckEmptyUtils.isEmpty(this.proxy)) {
      log.showWarn('registerCallback: proxy is empty!');
      return;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(PROJECTION_SERVICE_TOKEN_NAME);
    data.writeString(IdlCarAssistantServiceProxy.SCENE_BOARD_BUNDLE_NAME);
    data.writeRemoteObject(clientProxy);
    this.proxy.sendMessageRequest(IdlCarAssistantServiceProxy.COMMAND_REGISTER_CALLBACK, data, reply, option)
      .then((result) => {
        if (result.errCode !== 0) {
          log.showWarn(`registerCallback: failed, errCode = ${result.errCode}`);
          return;
        }
        log.showInfo(`registerCallback: success`);
      })
      .catch((err: BusinessError) => {
        log.showError(`registerCallback: failed, get exception`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }

  /*
   * 反注册服务端回调，销毁本端远程实例
   *
   */
  unRegisterCallback(): void {
    if (CheckEmptyUtils.isEmpty(this.proxy)) {
      log.showWarn('unRegisterCallback: proxy is empty!');
      return;
    }
    const option: rpc.MessageOption = new rpc.MessageOption();
    const data: rpc.MessageSequence = new rpc.MessageSequence();
    const reply: rpc.MessageSequence = new rpc.MessageSequence();
    data.writeInterfaceToken(PROJECTION_SERVICE_TOKEN_NAME);
    data.writeString(IdlCarAssistantServiceProxy.SCENE_BOARD_BUNDLE_NAME);
    this.proxy.sendMessageRequest(IdlCarAssistantServiceProxy.COMMAND_UNREGISTER_CALLBACK, data, reply, option)
      .then((result) => {
        if (result.errCode !== 0) {
          log.showWarn(`unRegisterCallback: failed, errCode: ${result.errCode}`);
          return;
        }
        log.showInfo(`unRegisterCallback: success`);
      })
      .catch((err: BusinessError) => {
        log.showError(`unRegisterCallback: failed, get exception`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      });
  }
}