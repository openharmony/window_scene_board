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
import { GlobalContext, sSettingsUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import {
  LogDomain,
  Logger,
  SingleBase,
  SingleContext,
  singleManager,
} from '@ohos/basicutils';
import { settings, systemParameterEnhance, BusinessError } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';
import display from '@ohos.display';
import { rpc } from '@kit.IPCKit';

const TAG = 'CloudExpandDialogMgr';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const CLOUD_REQUEST_CALL_CODE: number = 1;
const CLOUD_DATA_PAIRS: number = 3;
const CLOUD_REPLY_CALL_CODE: number = 3;
const CLOUD_MODE_STATUS_KEY: string = 'AFTER_CLOUD_VEDIO_COVER';
const CLOUD_MODE: string = 'ohos.boot.minisys.mode';
const CLOUD_MODE_KEY: string = 'const.cloud.feature_enable';
const CLOUD_DIALOG_LEVEL: number = 2;
const CLOUD_DISABLED_GESTURE: number = 1;

export enum CloudChangeStatus {
  CLOUD_TO_FOLD = 'toFold',
  CLOUD_TO_EXPAND = 'toExpand',
  CLOUD_TO_APPEAR = 'aboutToAppear'
}

export class CloudExpandDialogMgr extends SingleBase {
  public static singleName: string = 'CloudExpandDialogMgr';
  private static sInstance: CloudExpandDialogMgr;

  // 是否是三折屏设备
  private isThreeFoldDevice: boolean = false;
  // 判断当前是否在云端模式
  private isCloudMode: boolean = false;
  // 云端展开态弹框是否已经开启
  private isDialogstatusOpen: boolean = false;
  // RPC通知关闭云端展开态弹窗code
  private closeDialogFlag: number = 3;
  // 云端展开态弹窗rpc远端代理
  private remoteProxy: rpc.IRemoteObject = new rpc.RemoteObject('DeadCallBack');
  // 设备是否支持云端
  private supportCloud: string = 'false';

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.supportCloud = systemParameterEnhance.getSync(CLOUD_MODE_KEY, 'false');
  }

  public static getInstance(ctx?: SingleContext): CloudExpandDialogMgr {
    return singleManager.get<CloudExpandDialogMgr>(CloudExpandDialogMgr, ctx);
  }

  /**
   * 判断当前是否在云端模式
   *
   * @returns true: 解锁后的界面是桌面
   */
  private isCloud(): boolean {
    return sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, CLOUD_MODE_STATUS_KEY,
      '', getContext(this)) === 'INTO_CLOUD' || systemParameterEnhance.getSync(CLOUD_MODE, '') === 'cloud';
  }

  /**
   * 云端模式下，在大折叠产品展开态时拉起云端霸屏弹窗
   *
   */
  public startCloudDialog(status: string): void {
    if (this.supportCloud === 'true' && DeviceHelper.isFold()) {
      this.isCloudMode = this.isCloud();
      log.showInfo(TAG, `isCloudMode: ${this.isCloudMode}; change status: ${status}}`);
      if (status === CloudChangeStatus.CLOUD_TO_APPEAR && this.isCloudMode &&
        DeviceHelper.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) {
        this.openStatusDialog();
      }
      if (status === CloudChangeStatus.CLOUD_TO_FOLD && this.isCloudMode) {
        this.closeStatusDialog();
      }
      if (status === CloudChangeStatus.CLOUD_TO_EXPAND && this.isCloudMode) {
        this.openStatusDialog();
      }
    }
  }

  public registerCloudModeMonitor(): void {
    log.showInfo(TAG, 'registerCloudModeMonitor');
    try {
      if (this.supportCloud === 'true' && DeviceHelper.isFold()) {
        settings.registerKeyObserver(GlobalContext.getContext(), CLOUD_MODE_STATUS_KEY,
          settings.domainName.DEVICE_SHARED, () => {
          let curMode = sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, CLOUD_MODE_STATUS_KEY,
            '', getContext(this))
          this.isCloudMode = this.isCloud();
          if (this.isCloudMode && DeviceHelper.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) {
            this.openStatusDialog();
          } else if (this.isDialogstatusOpen && curMode === 'EXIT_CLOUD') {
            log.showInfo(TAG, `The dialog box already exists and start to exit`);
            this.closeStatusDialog();
          }
          log.showInfo(TAG, 'registerMonitor isCloudMode changed: ' + this.isCloudMode);
        });
      }
    } catch (error) {
      log.showInfo(TAG, 'registerMonitor failed, error: ' + error);
    }
  }

  public unregisterCloudModeMonitor(): void {
    log.showInfo(TAG, 'unregisterMonitor');
    try {
      if (this.supportCloud === 'true' && DeviceHelper.isFold()) {
        settings.unregisterKeyObserver(GlobalContext.getContext(), CLOUD_MODE_STATUS_KEY,
          settings.domainName.DEVICE_SHARED);
      }
    } catch (error) {
      log.showInfo(TAG, 'unregisterMonitor failed, error: ' + error);
    }
  }

  private openStatusDialog(): void {
    if (this.isDialogstatusOpen) {
      log.showInfo(TAG, `The dialog box already exists`);
      return;
    }
    log.showInfo(TAG, `openStatusDialog`);
    let want: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'com.ohos.sceneboard.systemdialog'
    }
    let that = this;
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        that.sendMessage(remote);
      },
      onDisconnect(elementName) {
        log.showInfo(TAG, `DisConnect from System Dialog, elementName: ${elementName.bundleName}`)
      },
      onFailed(code) {
        log.showInfo(TAG, `Connect to System Dialog Failed, code: ${code}`)
      }
    }
    try {
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      const connectionId = context.connectServiceExtensionAbility(want, connectOption);
      log.showInfo(TAG, `start connecting. connectionId ${connectionId}`);
    } catch (err) {
      log.showInfo(TAG, `connect to systemDialog failed, code: ${err}`);
    }
  }

  private sendMessage(remote: rpc.IRemoteObject): void {
    this.remoteProxy = remote;
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    let parameter: Record<string, Object> = {
      'ability.want.params.uiExtensionType': 'sysDialog/common',
      'sysDialogZOrder': CLOUD_DIALOG_LEVEL,
      'disableUpGesture':CLOUD_DISABLED_GESTURE
    }
    log.showInfo(TAG, `param ${JSON.stringify(parameter)}`);
    data.writeInt(CLOUD_DATA_PAIRS);
    data.writeString('bundleName');
    data.writeString('com.ohos.cloudmodeassistant'); // 业务方的bundleName
    data.writeString('abilityName');
    data.writeString('ExpandedDialogUIExtAbility'); // 业务方的abilityName
    data.writeString('parameters');
    data.writeString(JSON.stringify(parameter));
    // @param code 表示客户端发送的服务请求代码。
    // @param data 表示客户端发送的{@link MessageSequence}对象。
    // @param reply 表示远程服务发送的响应消息对象。
    // @param options 指示操作是同步的还是异步的。
    // @return 如果操作成功返回{@code true}； 否则返回 {@code false}。
    this.isDialogstatusOpen = true;
    remote.sendMessageRequest(CLOUD_REQUEST_CALL_CODE, data, reply, option)
      .then(result => {
        log.showInfo(TAG, `Start System Dialog success ${result.errCode} ${result.reply.readInt()}`);
      })
      .catch((error: BusinessError) => {
        log.showInfo(TAG, `Start System Dialog error code:${error.code},message:${error.message}`);
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim(); // 释放MessageSequence创建的内存
      });
    log.showInfo(TAG, `send isDialogstatusOpen: ${this.isDialogstatusOpen}`);
  }

  private closeStatusDialog(): void {
    if (!this.isDialogstatusOpen) {
      log.showInfo(TAG, `The dialog box not exists`);
      return;
    }
    log.showInfo(TAG, 'closeStatusDialog');
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    this.isDialogstatusOpen = false;
    this.remoteProxy.sendMessageRequest(CLOUD_REPLY_CALL_CODE, data, reply, option).then((ret) => {
      let msg = reply.readInt();
      log.showInfo(TAG, `close dialog ret:${ret}, msg:${msg}`);
    }).catch((error: BusinessError) => {
      log.showInfo(TAG, `close dialog failed, code: ${error.code}, msg:${error.message}`);
    }).finally(() => {
      // 释放MessageSequence创建的内存
      data.reclaim();
      reply.reclaim();
    });
  }
}