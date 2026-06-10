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

import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  ExtendScreenConnectStatusChangeListener,
  SCBScreenSessionManager
} from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import sSCBOobeManager from '@ohos/windowscene/src/main/ets/oobe/SCBOobeManager';
import { display, screen } from '@kit.ArkUI';
import { ExternalScreenConnectNtF } from './ExternalScreenConnectNtF';

const TAG: string = 'ExtendedScreenDialogController';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const settingKey :string = 'settings.ExtendedScreenDialog.enable';

export class ExtendedScreenDialogController {
  private static instance: ExtendedScreenDialogController;
  private static isDialogOpen: boolean = false;
  private isBigScreen: boolean = DeviceHelper.isBigScreenMachine() && DeviceHelper.isPC();
  private isExtendScreen: boolean = false;
  private openDialogChance: boolean = false;
  private isLocked: boolean = false;
  private context: Context = getContext(this);
  private manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
  private extendScreenConnectStatusChangeListener: ExtendScreenConnectStatusChangeListener = {
    onExtendScreenConnectStatusChange: (screenId: number,
      extendScreenConnectStatus: screenSessionManager.ExtendScreenConnectStatus) => {
      log.showInfo(`onExtendScreenConnectStatusChange info: ${screenId} - ${extendScreenConnectStatus}`);
      Promise.resolve().then(() => {
        const res: boolean = extendScreenConnectStatus === screenSessionManager.ExtendScreenConnectStatus.CONNECT;
        if (res && !this.isExtendScreen) {
          this.openDialogChance = true;
        }
        this.isExtendScreen = res;
        this.judgeOpenDialog();
      });
    }
  }

  public static getInstance(): ExtendedScreenDialogController {
    if (ExtendedScreenDialogController.instance) {
      return ExtendedScreenDialogController.instance;
    }
    ExtendedScreenDialogController.instance = new ExtendedScreenDialogController();
    return ExtendedScreenDialogController.instance;
  }

  public rePublishNotification(): void {
    ExternalScreenConnectNtF.rePublishNotification();
  }

  constructor() {
    this.initListenAndStatus();
  }

  /**
   * 判断是否连接外接显示器，并且为拓展模式
   * @returns
   */
  public isExtendScreenConnect(): boolean {
    let isConnect: boolean = false;
    try {
      for (let i = 0; i < SCBScreenSessionManager.getInstance().getScreenSessionList().length; i++) {
        let screenID = SCBScreenSessionManager.getInstance().getScreenSessionList()[i]?.session?.screenId;
        let sourceMode = display.getDisplayByIdSync(screenID).sourceMode;
        log.showInfo(`ExtendedScreenDialogController screenID:${screenID} sourceMode:${sourceMode}`);
        isConnect = sourceMode === display.DisplaySourceMode.EXTEND;
        if (isConnect) {
            break;
        }
      }
      log.showInfo(`ExtendedScreenDialogController isConnect:${isConnect}`);
    } catch (error) {
      log.showInfo(`ExtendedScreenDialogController message: ${error.message}`);
    }
    this.isExtendScreen = isConnect;
    this.openDialogChance = isConnect;
    return isConnect;
  }

  private initListenAndStatus(): void {
    log.showInfo(`initListenAndStatus`);
    try {
      screen.on('connect', (id: number) => {
        log.showInfo(`ExtendedScreenDialogController connect`);
        if (id < 1000) {
          ExternalScreenConnectNtF.publishScreenConnNotification(true);
          if (this.isExtendScreenConnect()) {
            this.judgeOpenDialog();
          }
        }
      });
      screen.on('disconnect', (id: number) => {
        log.showInfo(`ExtendedScreenDialogController disconnect`);
        if (id < 1000) {
          ExternalScreenConnectNtF.cancelNotification();
          this.closeExtendedScreenDialog();
        }
      });
    } catch (error) {
      log.showError(`initListenAndStatus error code: ${error.code}, message: ${error.message}`);
    }

  }

  private judgeOpenDialog(): void {
    log.showInfo(`judgeOpenDialog info: ${this.isExtendScreen} - ${ExtendedScreenDialogController.isDialogOpen} - ` +
      `${sSCBOobeManager.isOobeActivated()} - ${AppStorage.get<boolean>('isLock')} - ${this.isBigScreen} - ` +
      `${this.openDialogChance}`);
    if (this.openJudge()) {
      if (!ExtendedScreenDialogController.isDialogOpen) {
        this.openExtendedScreenDialog();
        this.openDialogChance = false;
      }
    } else if (ExtendedScreenDialogController.isDialogOpen) {
      this.closeExtendedScreenDialog();
    }
  }

  private openJudge(): boolean {
    return this.isBigScreen && this.openDialogChance && this.isExtendScreen && !AppStorage.get<boolean>('isLock') &&
      !sSCBOobeManager.isOobeActivated() && sSettingsUtil.getSystemValue(settingKey, '0', this.context) !== '1';
  }

  private closeExtendedScreenDialog(): void {
    ExtendedScreenDialogController.isDialogOpen = false;
  }

  private openExtendedScreenDialog(): void {
    let newWant: Want = {
      bundleName: 'com.ohos.sceneboard', // 请求大桌面进程中的ServiceExtention
      abilityName: 'com.ohos.sceneboard.systemdialog'
    }
    let connectOption: common.ConnectOptions = {
      onConnect(elementName, remote) {
        let option = new rpc.MessageOption();
        let data = rpc.MessageSequence.create();
        let reply = rpc.MessageSequence.create();
        let parameter: Record<string, Object> = {
          'ability.want.params.uiExtensionType': 'sysDialog/common',
          'isForceShowMainScreen': true,
          'isSetPcBgColorTransparent': true
        }
        data.writeInt(3);
        data.writeString('bundleName');
        data.writeString('com.ohos.sceneboard'); // 业务方的bundleName
        data.writeString('abilityName');
        data.writeString('ExtendedScreenDialogAbility'); // 业务方的abilityName
        data.writeString('parameters');
        data.writeString(JSON.stringify(parameter));
        remote.sendMessageRequest(1, data, reply, option)
          .then((result) => {
            log.showInfo(`Start System Dialog success ${result.errCode} ${result.reply.readInt()}`);
            ExtendedScreenDialogController.isDialogOpen = true;
          })
          .catch((error: BusinessError) => {
            log.showError(`Start System Dialog error code:${error.code},message:${error.message}`);
          })
          .finally(() => {
            data.reclaim();
            reply.reclaim(); // 释放MessageSequence创建的内存
          });
      },
      onDisconnect(elementName) {
        log.showInfo(`DisConnect from System Dialog,elementName: ${elementName.bundleName}`);
        ExtendedScreenDialogController.isDialogOpen = false;
      },
      onFailed(code) {
        log.showError(`Connect to System Dialog Failed,code: ${code}`);
      }
    }
    try {
      let context: common.UIAbilityContext = this.context as common.UIAbilityContext;
      const connectionId = context?.connectServiceExtensionAbility(newWant, connectOption);
    } catch (e) {
      let err: BusinessError = e as BusinessError;
      log.showError(`Connect to System Dialog Failed,code: ${err.code}`);
    }
  }
}