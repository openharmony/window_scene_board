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

import { BusinessError } from '@ohos.base';
import rpc from '@ohos.rpc';
import common from '@ohos.app.ability.common';
import { LogDomain, Logger } from '@ohos/basicutils';
import { AudioConstants } from '../common/Constants';
import { DataConstants, SettingsKeyConstants } from '../util/CommonUtils';
import SettingsUtil from '../util/SettingsUtil';
import { PanelManagerBase } from './PanelManager';

const TAG = 'SoundPermissionManager';
const log = Logger.getLogHelper(LogDomain.SCB);

export class SoundPermissionManager implements PanelManagerBase {
  private static instance: SoundPermissionManager;
  private isRegistered: boolean = false;
  private isSigned: boolean = false;

  public static getInstance(): SoundPermissionManager {
    if (SoundPermissionManager.instance) {
      return SoundPermissionManager.instance;
    }
    SoundPermissionManager.instance = new SoundPermissionManager();
    return SoundPermissionManager.instance;
  }

  public init(): void {
    this.initSoundPermissionListener();
  }

  public destroy(): void {
    this.offSoundPermissionListener();
  }

  private async initSoundPermissionListener(): Promise<void> {
    if (await this.getPrivacyAgreementStatus()) {
      this.isSigned = true;
      return;
    }
    this.isRegistered = SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.PRIVACY_AGREEMENT_DIALOG,
      async () => {
        this.isSigned = await this.getPrivacyAgreementStatus();
        // 若未签署隐私协议，则执行拉起隐私协议弹窗
        if (!this.isSigned) {
          this.openDialog();
        }
    });
    log.showInfo(TAG, `initSoundPermissionListener res: ${this.isRegistered}`);
  }

  private offSoundPermissionListener(): void {
    if (!this.isRegistered) {
      return;
    }
    this.isRegistered = !SettingsUtil.unregisterKeyObserverSystem(SettingsKeyConstants.PRIVACY_AGREEMENT_DIALOG);
    log.showInfo(TAG, `offSoundPermissionListener res: ${this.isRegistered}`);
  }

  private async getPrivacyAgreementStatus(): Promise<boolean> {
    return await SettingsUtil.getSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED,
      AudioConstants.VALUE_DISABLE) === AudioConstants.VALUE_ENABLE;
  }

  private openDialog() {
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
        }
        log.showInfo(TAG, `param ${JSON.stringify(parameter)}`);
        data.writeInt(DataConstants.DATA_INT);
        data.writeString(DataConstants.BUNDLENAME);
        data.writeString(DataConstants.BUNDLENAME_DETAIL); // 业务方的bundleName
        data.writeString(DataConstants.ABILITYNAME);
        data.writeString(DataConstants.ABILITYNAME_DETAIL); // 业务方的abilityName
        data.writeString(DataConstants.PARAMETERS);
        data.writeString(JSON.stringify(parameter));
        remote.sendMessageRequest(DataConstants.MSG_CODE, data, reply, option)
          .then(result => {
            log.showInfo(TAG, `Start System Dialog success ${result.errCode} ${result.reply.readInt()}`);
          })
          .catch((error: BusinessError) => {
            log.showInfo(TAG, `Start System Dialog error code:${error.code},message:${error.message}`)
          })
          .finally(() => {
            data.reclaim();
            reply.reclaim(); // 释放MessageSequence创建的内存
          });
      },
      onDisconnect(elementName) {
        log.showInfo(TAG, `DisConnect from System Dialog,elementName: ${elementName.bundleName}`)
      },
      onFailed(code) {
        log.showInfo(TAG, `Connect to System Dialog Failed,code: ${code}`)
      }
    }
    try {
      let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
      const connectionId = context?.connectServiceExtensionAbility(newWant, connectOption)
    } catch (e) {
      let err: BusinessError = e as BusinessError
      log.showError(TAG, `Connect to System Dialog Failed,code: ${err.code}`)
    }
  }
}