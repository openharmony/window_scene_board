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

import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import type Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import { promptAction } from '@kit.ArkUI';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import CommonEventManager from '@ohos.commonEventManager';
import { ResourceUtil } from '../common/ResourceUtil';
import { SysDialogZOrder, RequestCommand, CommonDialog, ReplyCode, ToastTip, RPCReadKey } from '../common/Constants';
import SystemDialogController from '../controller/Controller';
import { IExtraInfo, IParam, IParameters, ISystemDialogData, IWant } from '../common/DialogDataEvent';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'Dialog-ServiceExtensionAbility1';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const getConnectId = (...args: Object[]): string => {
  return args.join('-');
};

const START_POWER_OFF_ABILITY = 'PoweroffAbility';
const EVENT_SHOW_POWER_OFF = 'custom.event.SHOW_POWER_OFF';

class Stub extends rpc.RemoteObject {
  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, option: rpc.MessageOption): boolean {
    // 鉴权通过，执行正常业务逻辑
    const connectId = getConnectId(rpc.IPCSkeleton?.getCallingPid(), rpc.IPCSkeleton?.getCallingTokenId());
    log.showInfo(TAG, `${connectId} onRemoteRequest start`);

    if (code === RequestCommand.SEND_REMOTE_OBJECT) {
      return this.processSendRemoteObject(data, reply, connectId);
    }

    if (code === RequestCommand.START_DIALOG) {
      return this.processStartDialog(data, reply, connectId);
    }

    if (code === RequestCommand.CLOSE_DIALOG) {
      return this.processCloseDialog(data, reply, connectId);
    }

    if (code === RequestCommand.COMMON_DIALOG) {
      return this.processCommonDialog(data, reply, connectId);
    }

    if (code === RequestCommand.TOAST) {
      return this.processToast(data, reply, connectId);
    }
    return false;
  }

  private processToast(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    if (size !== ToastTip.SIZE) {
      log.showError(TAG, `${connectId} onRemoteRequest code:5 parameters size:${size}`);
      return false;
    }
    const originWant: IWant = this.readRpcData(data, size);
    if (!originWant?.parameters) {
      log.showError(TAG, `${connectId} onRemoteRequest code:5 failed parameters invalid`);
      return false;
    }
    originWant.parameters = this.parseWantParameters(connectId, originWant) as IParam;
    log.showInfo(TAG, `${connectId} onRemoteRequest code:5 parameters ${JSON.stringify(originWant.parameters)}`);

    const params = originWant.parameters as Object as promptAction.ShowToastOptions;
    let message: string | Resource = $r('app.string.thermal_aware_toast');
    const resourceId = params ? Reflect.get(params, 'resourceKey') as string : undefined;
    if (resourceId) {
      message = this.getResourseById(resourceId, connectId);
    }
    try {
      const toastOptions: promptAction.ShowToastOptions = {
        message: message,
        showMode: (params?.showMode as promptAction.ToastShowMode) ?? promptAction.ToastShowMode.TOP_MOST,
        duration: (params?.duration as number) ?? 1500,
        bottom: (params?.bottom as (string | number)) ?? '80vp'
      };
      ArkUIAdapter.uiContext?.getPromptAction().showToast(toastOptions);
    } catch (err) {
      log.showError(TAG, `${connectId} onRemoteRequest code:5 showToast err ${err}`);
    }
    reply.writeInt(ReplyCode.SUCCESS);
    return true;
  }

  // 调用commonDialog弹框
  private processCommonDialog(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    if (size !== CommonDialog.SIZE) {
      log.showError(TAG, `${connectId} onRemoteRequest code:4 parameters size:${size}`);
      return false;
    }
    const originWant: IWant = this.readRpcData(data, size);
    if (!originWant?.parameters) {
      log.showError(TAG, `${connectId} onRemoteRequest code:4 failed parameters invalid`);
      return false;
    }
    log.showInfo(TAG, `${connectId} onRemoteRequest code:4 parameters: ${originWant?.parameters}`);
    // 解析parameters
    originWant.parameters = this.parseWantParameters(connectId, originWant) as IParam;
    const sysDialogZOrder = SysDialogZOrder.DEFAULT;
    // 构造commonDialog的want参数
    const targetWant = this.getCommonDialogWant(originWant, connectId);
    const screenId = this.getFocusedScreenId(originWant.parameters as IParameters);
    const value: ISystemDialogData = {
      id: connectId,
      connectId,
      sysDialogZOrder,
      want: targetWant,
      screenId,
      timestamp: new Date().getTime()
    };
    this.processDataByKey(connectId, value, reply);
    return true;
  }

  // 构造commonDialog的want
  private getCommonDialogWant(originWant: IWant, connectId: string): IWant {
    const resourseInfo = (originWant?.parameters as IParameters)?.extraInfo as IExtraInfo;
    const appName = resourseInfo.appName;
    const title = this.getResourseById(resourseInfo?.title, connectId);
    const content = this.getResourseById(resourseInfo?.content, connectId);
    const button = this.getResourseById(resourseInfo?.button, connectId);
    let message = content;
    if (appName && content) {
      message = `"${appName}" ${content}`;
    }
    const want: IWant = {
      bundleName: CommonDialog.BUNDLE_NAME,
      abilityName: CommonDialog.ABILITY_NAME,
      parameters: {}
    };
    (want!.parameters as IParameters)!.extraInfo = { title, content: message, button };
    want!.parameters![CommonDialog.UEC_TYPE_KEY] = CommonDialog.UEC_TYPE_VALUE;
    return want;
  }

  // 根据resourceId获取对应的值
  private getResourseById(resourceId: string, connectId: string): string {
    let result = '';
    try {
      result = ResourceUtil.getInnerStringByName(resourceId) as string || '';
      log.showInfo(TAG, `${connectId} getResourseById result ${result}`);
    } catch (error) {
      log.showError(TAG, `${connectId} getResourseById error ${resourceId} ${error?.message}`);
    }
    return result;
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
      log.showError(TAG, `readRpcData error: ${err}`);
    }
    return want;
  }

  private processDataByKey(connectId: string, value: ISystemDialogData, reply: rpc.MessageParcel): void {
    try {
      let sysDialogStatus = SystemDialogController.getInstance().getSysDialogStatus();
      if (DeviceHelper.isPC()) {
        sysDialogStatus = SystemDialogController.getInstance().getStatusByScreenId(value.screenId as number);
      }
      log.showInfo(TAG, `${connectId} onRemoteRequest check sysDialog ${value.screenId} ${sysDialogStatus}`);
      if (sysDialogStatus) {
        SystemDialogController.getInstance().addDataByKey(connectId, value);
        reply.writeInt(ReplyCode.SUCCESS);
      } else {
        log.showWarn(TAG, `${connectId} onRemoteRequest sysDialog not ready ${ReplyCode.ERROR}`);
        // 未初始化完成
        reply.writeInt(ReplyCode.ERROR);
      }
    } catch (error) {
      reply.writeInt(ReplyCode.ERROR);
      log.showError(TAG, `${connectId} onRemoteRequest sysDialog error ${error?.message}`);
    }
  }

  // 解析rpc的data中的parameters参数
  private parseWantParameters(connectId: string, want: IWant): IParameters | undefined {
    let parameters: IParameters | undefined = undefined;
    try {
      const parse = JSON.parse(String(want.parameters)) as IParameters;
      if (typeof parse === 'object') {
        parameters = parse;
        log.showWarn(TAG, `${connectId} onRemoteRequest parameters ${want.bundleName} ${want.abilityName}`);
      } else {
        parameters = undefined;
      }
    } catch (error) {
      parameters = this.retryFormat(want.parameters as IParameters);
      log.showError(TAG, `${connectId} onRemoteRequest parse parameters error ${error}`);
    }
    return parameters;
  }

  private processStartDialog(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    const size = data.readInt();
    log.showInfo(TAG, `${connectId} onRemoteRequest code:1 parameters size: ${size}`);
    if (size > RequestCommand.LIMIT_PARAMETER_SIZE) {
      return false;
    }
    const want: IWant = this.readRpcData(data, size);

    if (!want.bundleName || !want.abilityName || !want.parameters) {
      log.showError(TAG, `${connectId} onRemoteRequest code:1 failed. bundleName|abilityName|parameters invalid`);
      return false;
    }

    if (DeviceHelper.isSmallFoldProduct() && DeviceHelper.isSubDisplayMode() &&
      want.abilityName === START_POWER_OFF_ABILITY) {
      this.sendOuterHomePowerOffEvent(want.abilityName);
      return true;
    }

    this.lockRotationForPowerOff(want.abilityName);

    want.parameters = this.parseWantParameters(connectId, want) as IParam;

    if (!want.parameters) {
      log.showError(TAG, `${connectId} onRemoteRequest code:1 failed. parameters invalid`);
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
      log.showInfo(TAG, `screenId from ${screenId}`);
    }
    return screenId;
  }

  private processCloseDialog(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    log.showWarn(TAG, `processCloseDialog: ${connectId} start`);
    const code = SystemDialogController.getInstance().removeDataByKey(connectId);
    reply.writeInt(code);
    log.showWarn(TAG, `processCloseDialog: ${connectId} end`);
    return true;
  }

  private lockRotationForPowerOff(abilityName: string): void {
    if (abilityName === START_POWER_OFF_ABILITY) {
      log.showInfo(TAG, `lock power off start`);
      const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      if (!CommonUtils.isInvalid(screenSession)) {
        log.showInfo(TAG, `setEnableSensorRotate false`);
        screenSession?.setEnableRotate(false, 'poweroff');
      }
      log.showInfo(TAG, `lock power off end`);
    }
  }

  private sendOuterHomePowerOffEvent(abilityName: string): void {
    if (abilityName !== START_POWER_OFF_ABILITY || !DeviceHelper.isSmallFoldProduct() ||
      !DeviceHelper.isSubDisplayMode()) {
      return;
    }
    log.showInfo(TAG, 'sendOuterHomePowerOffEvent start');
    let options: CommonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.REBOOT']
    };
    try {
      CommonEventManager.publish(EVENT_SHOW_POWER_OFF, options, (error) => {
        if (error) {
          log.showError(TAG, `sendOuterHomePowerOffEvent: ${error?.code}, message is ${error?.message}`);
        } else {
          log.showInfo(TAG, 'publish show power off event success');
        }
      });
    } catch (error) {
      log.showError(TAG, `sendOuterHomePowerOffEvent: ${error?.code}, message is ${error?.message}`);
    }
  }

  private retryFormat(parameters: IParameters | string) : IParameters | undefined {
    log.showWarn(TAG, `onRemoteRequest parse fail.`);
    try {
      const parse = JSON.parse(this.formatJSONString(String(parameters))) as IParameters;
      if (typeof parse === 'object') {
        return parse;
      }
    } catch (error) {
      log.showError(TAG, `onRemoteRequest parse retry fail. ${error?.message}`);
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

  private processSendRemoteObject(data: rpc.MessageParcel, reply: rpc.MessageParcel, connectId: string): boolean {
    log.showInfo(TAG, `onRemoteRequest code:2 start ${connectId}`);
    const remoteObject = data.readRemoteObject() as rpc.RemoteObject;
    log.showInfo(TAG, `onRemoteRequest code:2 ${remoteObject}`);
    const sysDialogStatus = SystemDialogController.getInstance().getSysDialogStatus();
    if (remoteObject && sysDialogStatus) {
      SystemDialogController.getInstance().addDataByKey(connectId, { id: connectId, connectId, remoteObject, want: {}});
      log.showInfo(TAG, 'onRemoteRequest code:2 end');
      reply.writeInt(ReplyCode.SUCCESS);
      return true;
    }

    return false;
  }
}

export class DialogServiceExtAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    log.showInfo(TAG, 'onCreate');
    ResourceUtil.setContext(this.context);
    SystemDialogController.getInstance().setContext(this.context);
  }

  onConnect(): Stub {
    log.showInfo(TAG, 'onConnect');
    return new Stub('SystemDialog');
  }

  onDisconnect(): void {
    log.showInfo(TAG, 'onDisconnect');
  }

  onDestroy(): void {
    log.showInfo(TAG, 'onDestroy');
  }
}
