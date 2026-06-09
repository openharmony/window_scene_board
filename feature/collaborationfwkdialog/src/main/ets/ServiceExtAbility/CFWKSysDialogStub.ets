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
import { promptAction } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { ResourceUtil } from '../common/ResourceUtil';
import CommonEventManager from '@ohos.commonEventManager';
import {
  CommonDialog,
  ReplyCode,
  RequestCommand,
  RPCReadKey,
  SysDialogZOrder,
  ToastTip
} from '../common/Constants';
import SystemDialogController from '../controller/Controller';
import type { IParam, IParameters, ISystemDialogData, IWant } from '../common/DialogDataEvent';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene';

const TAG = 'CFWKDialog-ServiceExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const START_POWER_OFF_ABILITY = 'PoweroffAbility';
const EVENT_SHOW_POWER_OFF = 'custom.event.SHOW_POWER_OFF';

export class CFWKSysDialogStub extends rpc.RemoteObject {
  private static IS_CFWK_DIALOG_OPEN = 'isCFWKDialogOpen';
  public static dialogCount: Set<string> = new Set();

  private getConnectId = (...args: Object[]): string => {
    return args.join('-');
  };

  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, option: rpc.MessageOption): boolean {
    // 鉴权通过，执行正常业务逻辑
    const connectId = this.getConnectId(rpc.IPCSkeleton?.getCallingPid(), rpc.IPCSkeleton?.getCallingTokenId());
    log.showInfo(`${connectId} onRemoteRequest start, code: ${code}`);

    if (code === RequestCommand.START_DIALOG) {
      CFWKSysDialogStub.dialogCount.add(connectId);
      AppStorage.setOrCreate(CFWKSysDialogStub.IS_CFWK_DIALOG_OPEN, true);
      return this.processStartDialog(data, reply, connectId);
    }

    if (code === RequestCommand.CLOSE_DIALOG) {
      CFWKSysDialogStub.dialogCount.delete(connectId);
      this.setDialogOffDelay();
      return this.processCloseDialog(data, reply, connectId);
    }

    if (code === RequestCommand.PRELOAD) {// 预加载 7
      CFWKSysDialogStub.dialogCount.add(connectId);
      AppStorage.setOrCreate(CFWKSysDialogStub.IS_CFWK_DIALOG_OPEN, true);
      return this.processPreLoad(data, reply, connectId);
    }

    if (code === RequestCommand.SHOW) { // 展示 6
      return this.processShow(data, reply, connectId);
    }

    if (code === RequestCommand.UNINSTALL) { // 卸载弹窗 8
      CFWKSysDialogStub.dialogCount.delete(connectId);
      this.setDialogOffDelay();
      return true;
    }

    if (code === RequestCommand.PRELOAD_UI_EXTENSION) {// 预加载UIextension 9
      return this.processPreLoadUIExtension(data, reply, connectId);
    }
    return false;
  }

  private processPreLoadUIExtension(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    log.showInfo(`${connectId} onRemoteRequest code:9 parameters size: ${size}`);
    if (size > RequestCommand.LIMIT_PARAMETER_SIZE) {
      return false;
    }
    const want: IWant = this.readRpcData(data, size);

    if (!want.bundleName || !want.abilityName || !want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:9 failed. bundleName|abilityName|parameters invalid`);
      return false;
    }

    want.parameters = this.parseWantParameters(connectId, want) as IParam;

    if (!want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:9 failed. parameters invalid`);
      return false;
    }
    let context: common.ApplicationContext = getContext()?.getApplicationContext();
    context?.preloadUIExtensionAbility(want);
    return true;
  }

  private setDialogOffDelay(): void {
    setTimeout((stub: CFWKSysDialogStub) => {
      log.showInfo(`cur dialog count: ${CFWKSysDialogStub.dialogCount.size}`);
      if (CFWKSysDialogStub.dialogCount.size <= 0) {
        AppStorage.setOrCreate(CFWKSysDialogStub.IS_CFWK_DIALOG_OPEN, false);
      }
    }, 1000, this);
  }

  private processPreLoad(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    log.showInfo(`${connectId} onRemoteRequest code:7 parameters size: ${size}`);
    const want: IWant = this.readRpcData(data, size);
    if (!want.bundleName || !want.abilityName || !want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:7 failed. bundleName|abilityName|parameters invalid`);
      return false;
    }
    want.parameters = this.parseWantParameters(connectId, want) as IParam;
    if (!want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:7 failed. parameters invalid`);
      return false;
    }
    const sysDialogZOrder = (want.parameters as IParameters)?.sysDialogZOrder ?? this.getDefaultOrder(want.parameters);
    log.showInfo(`processPreLoad ${sysDialogZOrder} sysDialogZOrder.`);
    const value: ISystemDialogData = {
      id: connectId,
      connectId,
      sysDialogZOrder: sysDialogZOrder,
      want,
      screenId: 0,
      flag: 7,
      count: -1,
      timestamp: new Date().getTime()
    };
    this.processDataByKey(connectId, value, reply);
    SystemDialogController.getInstance().loadPreloadWindow(connectId);

    return true;
  }

  private processShow(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    SystemDialogController.getInstance().showPreloadWindow(connectId);
    reply.writeInt(ReplyCode.SUCCESS);
    return true;
  }

  // 解析rpc的data数据
  private readRpcData(data: rpc.MessageParcel, size: number): IWant {
    const want: IWant = {};
    try {
      for (let i = 0; i < size; i++) {
        const key = data.readString();
        let value: string | number = '';
        if (key === RPCReadKey.FLAGS) {
          value = data.readInt();
        } else {
          value = data.readString();
        }
        Reflect.set(want, key, value);
      }
    } catch (err) {
      log.showError(`readRpcData error: ${err}`);
    }
    return want;
  }

  private processDataByKey(connectId: string, value: ISystemDialogData, reply: rpc.MessageParcel): void {
    try {
      SystemDialogController.getInstance().addDataByKey(connectId, value);
      reply.writeInt(ReplyCode.SUCCESS);
    } catch (error) {
      reply.writeInt(ReplyCode.ERROR);
      log.showError(`${connectId} onRemoteRequest sysDialog error ${error?.message}`);
    }
  }

  // 解析rpc的data中的parameters参数
  private parseWantParameters(connectId: string, want: IWant): IParameters | undefined {
    let parameters: IParameters | undefined = undefined;
    try {
      const parse = JSON.parse(String(want.parameters)) as IParameters;
      if (typeof parse === 'object') {
        parameters = parse;
        log.showWarn(`${connectId} onRemoteRequest parameters ${want.bundleName} ${want.abilityName}`);
      } else {
        parameters = undefined;
      }
    } catch (error) {
      parameters = this.retryFormat(want.parameters as IParameters);
      log.showError(`${connectId} onRemoteRequest parse parameters error ${error}`);
    }
    return parameters;
  }

  private processStartDialog(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    log.showInfo(`${connectId} onRemoteRequest code:1 parameters size: ${size}`);
    if (size > RequestCommand.LIMIT_PARAMETER_SIZE) {
      return false;
    }
    const want: IWant = this.readRpcData(data, size);

    if (!want.bundleName || !want.abilityName || !want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:1 failed. bundleName|abilityName|parameters invalid`);
      return false;
    }

    this.sendOuterHomePowerOffEvent(want.abilityName);

    this.lockRotationForPowerOff(want.abilityName);

    want.parameters = this.parseWantParameters(connectId, want) as IParam;

    if (!want.parameters) {
      log.showError(`${connectId} onRemoteRequest code:1 failed. parameters invalid`);
      return false;
    }
    const sysDialogZOrder = (want.parameters as IParameters)?.sysDialogZOrder ?? this.getDefaultOrder(want.parameters);

    const screenId = this.getFocusedScreenId(want.parameters);
    const value: ISystemDialogData = {
      id: connectId,
      connectId,
      sysDialogZOrder,
      want,
      screenId,
      flag: 1,
      timestamp: new Date().getTime()
    };
    this.processDataByKey(connectId, value, reply);
    return true;
  }

  // 获取焦点屏幕id, 默认主屏:0
  private getFocusedScreenId(parameters: IParameters): number {
    let screenId = 0;
    const focusedSession = SCBSceneSessionManager.getInstance()?.getFocusedSession();
    if (!parameters?.isForceShowMainScreen && focusedSession) {
      screenId = focusedSession?.session.screenId;
      log.showInfo(`screenId from ${screenId}`);
    }
    return screenId;
  }

  private processCloseDialog(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    log.showWarn(`processCloseDialog: ${connectId} start`);
    const code = SystemDialogController.getInstance().removeDataByKey(connectId);
    reply.writeInt(code);
    log.showWarn(`processCloseDialog: ${connectId} end`);
    return true;
  }

  private lockRotationForPowerOff(abilityName: string): void {
    if (abilityName === START_POWER_OFF_ABILITY) {
      log.showInfo(`lock power off start`);
      const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (!CommonUtils.isInvalid(screenSession)) {
        log.showInfo(`setEnableSensorRotate false`);
        screenSession?.setEnableRotate(false, 'poweroff');
      }
      log.showInfo(`lock power off end`);
    }
  }

  private sendOuterHomePowerOffEvent(abilityName: string): void {
    if (abilityName !== START_POWER_OFF_ABILITY ||
      !DeviceHelper.isSubDisplayMode()) {
      return;
    }
    log.showInfo('sendOuterHomePowerOffEvent start');
    let options: CommonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.REBOOT']
    };
    try {
      CommonEventManager.publish(EVENT_SHOW_POWER_OFF, options, (error) => {
        if (error) {
          log.showError(`sendOuterHomePowerOffEvent: ${error?.code}, message is ${error?.message}`);
        } else {
          log.showInfo('publish show power off event success');
        }
      });
    } catch (error) {
      log.showError(`sendOuterHomePowerOffEvent: ${error?.code}, message is ${error?.message}`);
    }
  }

  private retryFormat(parameters: IParameters | string) : IParameters | undefined {
    log.showWarn(`onRemoteRequest parse fail.`);
    try {
      const parse = JSON.parse(this.formatJSONString(String(parameters))) as IParameters;
      if (typeof parse === 'object') {
        return parse;
      }
    } catch (error) {
      log.showError(`onRemoteRequest parse retry fail. ${error?.message}`);
    }
    return undefined;
  }

  private formatJSONString(parameters: IParameters | string): string {
    if (typeof parameters !== 'string') {
      return '';
    }
    let tmp = String(parameters);
    String(parameters).split(',"').forEach(str => {
      if (typeof str === 'undefined' || str == null || str === '') {
        return;
      }
      let arr = str.split(':');
      if (arr.length !== 2) {
        return;
      }
      if (arr[0].trim().includes('ohos.ability.params.uriTypes') || arr[0].trim().includes('technology')) {
        tmp = tmp.replace(arr[1], `"${arr[1]}"`);
      }
    });
    return tmp;
  }

  private getDefaultOrder(parameters: IParameters | string): SysDialogZOrder {
    if (typeof parameters !== 'string') {
      return SysDialogZOrder.DEFAULT;
    }
    let result: SysDialogZOrder = SysDialogZOrder.DEFAULT;
    String(parameters).split(',').forEach(str => {
      if (typeof str === 'undefined' || str == null || str === '') {
        return;
      }
      let arr = str.split(':');
      if (arr.length !== 2) {
        return;
      }
      if (arr[0].trim().includes('sysDialogZOrder')) {
        result = arr[1] === '2' ? SysDialogZOrder.UPPER : SysDialogZOrder.DEFAULT;
      }
    });
    return result;
  }
}