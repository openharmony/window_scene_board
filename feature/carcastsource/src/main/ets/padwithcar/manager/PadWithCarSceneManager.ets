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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBSceneSessionArray,
} from '@ohos/windowscene';
import { BusinessError } from '@kit.BasicServicesKit';
import { IdlCarCastServiceImpl } from '../idlService/IdlCarCastServiceImpl';
import { resultStringCallback } from '../idlService/IIdlCarCastService';
import IdlCarAssistantServiceProxy from '../service/IdlCarAssistantServiceProxy';
import { CommonCallBack, RpcMessage } from '../service/IIdlCarAssistantService';
import { Response } from '../idlService/IdlCarCastServiceStub';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarSceneManager');

/**
 * PadWithCarSceneManager
 *
 * @since 2025-03-12
 */
export class PadWithCarSceneManager {
  private scbSceneSessionArray: SCBSceneSessionArray = new SCBSceneSessionArray();
  private screenProperty: SCBScreenProperty = new SCBScreenProperty();
  public isLastCalledHere: boolean = false;
  private connectId: number = 0;
  private screenChangeCallback?: Function;
  private messageRecvCallback?: Function;
  private padWithCarServiceProxy: IdlCarAssistantServiceProxy | undefined = undefined;
  private static want: Want = {
    bundleName: 'com.ohos.cardistributedassist',
    abilityName: 'ProjectionServiceExtAbility'
  };
  private static instance?: PadWithCarSceneManager;

  static getInstance(): PadWithCarSceneManager {
    if (!PadWithCarSceneManager.instance) {
      PadWithCarSceneManager.instance = new PadWithCarSceneManager();
      log.info(`SuperLauncherSceneManager is create`);
    }
    return PadWithCarSceneManager.instance;
  }

  /**
   * init
   *
   * @param screenProperty screenProperty
   */
  public init(screenProperty: SCBScreenProperty): void {
    this.connectAbility(() => {
      log.showInfo('init: connectAbility');
    });
    this.screenProperty = screenProperty;
  }

  /**
   * deInit
   */
  public deInit(): void {
    try {
      GlobalContext.getContext().disconnectServiceExtensionAbility(this.connectId).then(() => {
        log.showInfo('disconnect succeed.');
      }).catch((error: BusinessError) => {
        log.showError(`disconnect failed. Error code: ${error?.code}`);
      });
    } catch (error) {
      log.showError(`disconnect failed. Error code: ${error?.code}`);
    }
    log.showInfo(`aboutToDisappear screenId = ${this.screenProperty.screenId}`);
    if (this.padWithCarServiceProxy) {
      this.padWithCarServiceProxy.unRegisterCallback();
    }
    this.scbSceneSessionArray.splice(0);
    this.screenChangeCallback = undefined;
    this.padWithCarServiceProxy = undefined;
    PadWithCarSceneManager.instance = undefined;
  }

  /**
   * registerMessageRecvCallback 监听出行助手事件回调
   *
   * @param callback  回调返回的功能函数
   */
  public registerMessageRecvCallback(callback: Function): void {
    this.messageRecvCallback = callback;
  }

  /**
   * unregisterMessageRecvCallback 取消监听出行助手事件回调
   */
  public unregisterMessageRecvCallback(): void {
    this.messageRecvCallback = undefined;
  }

  /**
   * registerCallingScreenChangeCallback 监听输入框事件回调
   *
   * @param callback  回调返回的功能函数
   */
  public registerCallingScreenChangeCallback(callback: Function): void {
    this.screenChangeCallback = callback;
  }

  /**
   * unregisterCallingScreenChangeCallback 取消监听输入框事件回调
   */
  public unregisterCallingScreenChangeCallback(): void {
    this.screenChangeCallback = undefined;
  }

  /**
   * setSceneSessionArray 设置当前移栈应用
   *
   * @param sceneSessionArray sceneSessionArray
   */
  public setSceneSessionArray(sceneSessionArray: SCBSceneSessionArray): void {
    this.scbSceneSessionArray = sceneSessionArray;
  }

  /**
   * setLastCalledHere 输入法当前点击窗口
   *
   * @param isCalledHere
   */
  public setLastCalledHere(isCalledHere: boolean): void {
    this.isLastCalledHere = isCalledHere;
  }

  public isCurrentProjection(windowId: number): boolean {
    return this.scbSceneSessionArray.find((item) => item?.session?.persistentId === windowId) !== undefined;
  }

  /**
   * handleCallingSessionChange 处理输入法状态变化
   *
   * @param windowId windowId
   */
  public handleCallingSessionChange(windowId: number): void {
    if (!this.isCurrentProjection(windowId)) {
      log.showInfo('HandleCallingSessionChange is not current projection');
      if (this.isLastCalledHere) {
        this.screenChangeCallback?.(false);
      }
      this.isLastCalledHere = false;
      return;
    }
    log.showInfo(`handleCallingSessionChange: isLastCalledHere = ${this.isLastCalledHere}, windowId = ${windowId}`);
    if (this.isLastCalledHere) {
      return;
    }
    this.isLastCalledHere = true;
    if (this.screenChangeCallback) {
      this.screenChangeCallback(true);
    }
  }

  /**
   * recvMessage 接收到助手发送的消息
   * @param code 事件码
   * @param params 参数
   * @param callback 回调
   */
  public recvMessage(code: number, params: string, callback: resultStringCallback): void {
    log.showInfo(`recvMessage code = ${code}`);
    this.messageRecvCallback?.(code, params);
    callback?.(Response.SUCCESS, Response.DEFAULT_RET);
  }

  /**
   * handleKeyBoardVisible
   *
   * @param isShow true is show, false is hide
   */
  public handleKeyBoardVisible(isShow: boolean): void {
    this.sendMsgToCarAssistant({
      action: isShow ? IdlCarAssistantServiceProxy.ACTION_KEYBOARD_IS_SHOW :
      IdlCarAssistantServiceProxy.ACTION_KEYBOARD_IS_HIDE
    });
  }

  /**
   * 发送消息到出行助手
   *
   * @param msg 消息参数
   * @param callBack 结果回调
   */
  public sendMsgToCarAssistant(msg: RpcMessage, callBack?: CommonCallBack): void {
    try {
      if (this.padWithCarServiceProxy) {
        this.padWithCarServiceProxy.sendMsgToCarAssistant(msg, callBack);
        return;
      }
      log.showWarn('sendMsgToCarAssistant: is not connected');
    } catch (err) {
      log.error(`sendMsgToCarAssistant failed, error code is ${err?.code}`);
    }
  }

  private connectAbility(onConnect?: () => void): void {
    try {
      this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(PadWithCarSceneManager.want,
        {
          onConnect: (elementName, proxy) => {
            log.showInfo(`onConnect: bundleName = ${elementName.bundleName}`);
            this.padWithCarServiceProxy = new IdlCarAssistantServiceProxy(proxy);
            this.registerCallback();
            onConnect?.();
          },
          onDisconnect: (elementName) => {
            log.showInfo(`onDisconnect: bundleName = ${elementName.bundleName}`);
          },
          onFailed: (code) => {
            log.showError(`onFailed：code = ${code}`);
          }
        });
    } catch (error) {
      log.showError(`connectAbility failed. Error code: ${error?.code}`);
    }
  }

  /**
   * 注册服务端回调，实现服务端可以回调客户端的接口，完成双向通信
   *
   */
  private registerCallback(): void {
    log.showInfo('registerCallback');
    const carCastService: IdlCarCastServiceImpl = new IdlCarCastServiceImpl('carCastService');
    if (this.padWithCarServiceProxy) {
      this.padWithCarServiceProxy.registerCallback(carCastService);
      return;
    }
    log.showWarn('registerCallback: is not connected');
    this.connectAbility();
  }
}