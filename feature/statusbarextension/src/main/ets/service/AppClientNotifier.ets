/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { rpc } from '@kit.IPCKit';
import { StatusBarConnectEvent } from './StatusBarServiceEventManager';

const TAG = 'AppClientNotifier';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const maxNum: number = 50;

/**
 * 对接客户端的通知发送装置
 */
export class AppClientNotifier {
  private clientProxyMap: Map<number, rpc.IRemoteObject> = new Map();
  private pluginSlots: Map<number, string> = new Map();
  private static instance: AppClientNotifier | undefined = undefined;

  public static getInstance(): AppClientNotifier {
    if (AppClientNotifier.instance === undefined) {
      AppClientNotifier.instance = new AppClientNotifier();
    }
    return AppClientNotifier.instance;
  }

  public handleClientRegistration(clientPid: number, pluginSlot: string, data: rpc.MessageSequence): void {
    if (!this.clientProxyMap.has(clientPid)) {
      if (this.clientProxyMap.size < maxNum) {
        let ro = data.readRemoteObject();
        this.clientProxyMap.set(clientPid, ro);
        this.pluginSlots.set(clientPid, pluginSlot);
        logger.showInfo(`Register client pid success: ${clientPid}`);
      } else {
        logger.showError(`Register client pid fail: out of range`);
      }
    } else {
      logger.showInfo(`Register client pid already exist: ${clientPid}`);
    }
  }

  public unregisterClient(clientPids: Set<number>): void {
    clientPids?.forEach((clientPid) => {
      if (this.clientProxyMap.has(clientPid)) {
        this.clientProxyMap.delete(clientPid);
        this.pluginSlots.delete(clientPid);
        logger.showInfo(`Delete client pid success: ${clientPid}`);
      }
    });
  }

  public notifyClientMenuClicked(pluginSlot: string, menuCode: string): void {
    logger.showInfo(`Notify client menu clicked start ${pluginSlot}-${menuCode}`);
    this.pluginSlots.forEach((slot, key) => {
      if (slot === pluginSlot && this.clientProxyMap.has(key)) {
        logger.showInfo(`Notify client for pid ${key} and pluginSlot ${pluginSlot}`);
        let ro = this.clientProxyMap.get(key);
        if (!ro) {
          logger.showError(`Notify client proxy ${slot} not exist`);
          return;
        }
        this.notifyClientMessage(menuCode, StatusBarConnectEvent.UPDATE_RIGHT_MENU_CLICK_HANDLER, ro);
      }
    });
  }

  public notifyClientIconClicked(pluginSlot: string, iconClickType: string): void {
    logger.showInfo(`Notify client icon clicked start ${pluginSlot}-${iconClickType}`);
    this.pluginSlots.forEach((slot, key) => {
      if (slot === pluginSlot && this.clientProxyMap.has(key)) {
        logger.showInfo(`Notify client for pid ${key} and pluginSlot${pluginSlot}`);
        let ro = this.clientProxyMap.get(key);
        if (!ro) {
          logger.showError(`Notify client proxy ${slot} not exist`);
          return;
        }
        this.notifyClientMessage(iconClickType, StatusBarConnectEvent.ON_ICON_CLICK, ro);
      }
    });
  }

  private notifyClientMessage<T>(message: T, code: number, proxy: rpc.IRemoteObject): void {
    try {
      let option = new rpc.MessageOption();
      let data = rpc.MessageSequence.create();
      let reply = rpc.MessageSequence.create();
      data.writeInterfaceToken('app_callback');
      this.writeMsg(message, data);
      this.sendMessage(proxy, code, data, reply, option);
    } catch (err) {
      logger.showError(err);
    }
  }

  private writeMsg<T>(message: T, data: rpc.MessageSequence): void {
    try {
      switch (typeof message) {
        case 'string':
          data.writeString(message);
          return;
        default:
          return;
      }
    } catch (err) {
      throw err as Error;
    }
  }

  private sendMessage(proxy: rpc.IRemoteObject, code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): void {
    proxy.sendMessageRequest(code, data, reply, option).then((result) => {
      logger.showInfo(`send auth result is ${result?.errCode}`);
    }).catch((e: Error) => {
      logger.showError(`send auth result error, message:${e?.message}`);
    }).finally(() => {
      data.reclaim();
      reply.reclaim();
      logger.showInfo(`Notify client end code ${code}`);
    });
  }
}