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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import Settings from '@ohos.settings';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG: string = 'PluginDistributedController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 当前通信共享设备名的数据项名称
const DISTRIBUTED_DEVICE_NAME: string = 'distributed_modem_device_name';
// 当前通信共享电话共享开关的数据项名称
const DISTRIBUTED_CALL_STATE: string = 'distributed_call_phone_sharing_sink';
// 当前通信共享信息共享开关的数据项名称
const DISTRIBUTED_SMS_STATE: string = 'distributed_call_sms_sharing_sink';
// 当前通信共享设备名的默认值
const DISTRIBUTED_DEVICE_NAME_DEFAULT: string = '';
// 当前通信共享电话共享开关的默认值   关闭是0  开启是1
const DISTRIBUTED_CALL_STATE_DEFAULT: string = '0';
// 当前通信共享信息共享开关的默认值   关闭是0  开启是1
const DISTRIBUTED_SMS_STATE_DEFAULT: string = '0';
// 开关开启的值
const STATE_ON: string = '1';

const enum DataFlowType {
  DATA_FLOW_TYPE_NONE,
  DATA_FLOW_TYPE_DOWN,
  DATA_FLOW_TYPE_UP,
  DATA_FLOW_TYPE_UP_DOWN,
  DATA_FLOW_TYPE_DORMANT,
}

export class PluginDistributedController {
  private isShow: boolean = false;
  private isNetworkSharing: boolean = false;
  private isSharedNetworkAvailable: boolean = false;

  constructor() {
  }

  public setShowState(isShow: boolean) {
    log.info(`setNetworkSharingState : ${isShow}`);
    this.isShow = isShow;
  }

  public setNetworkSharingState(isNetworkSharing: boolean) {
    log.info(`setNetworkSharingState : ${isNetworkSharing}`);
    this.isNetworkSharing = isNetworkSharing;
  }

  public setSharedNetworkAvailableState(isSharedNetworkAvailable: boolean) {
    log.info(`setSharedNetworkAvailableState : ${isSharedNetworkAvailable}`);
    this.isSharedNetworkAvailable = isSharedNetworkAvailable;
  }

  public getSharedNetworkImage(isWhite: boolean, isNetworkSharing: boolean, type: DataFlowType): Resource {
    log.info(`getSharedNetworkImg isWhite : ${isWhite}  DataFlowType : ${type}`);
    if (!isNetworkSharing) {
      return isWhite ? $r('app.media.ic_status_bar_distributed_modem_white_pc') :
      $r('app.media.ic_status_bar_distributed_modem_pc');
    }
    let sharedNetworkImage: Resource | null;
    switch (type) {
      case DataFlowType.DATA_FLOW_TYPE_DOWN:
        sharedNetworkImage = isWhite ? $r('app.media.ic_status_bar_distributed_down_white_pc') :
        $r('app.media.ic_status_bar_distributed_down_pc');
        break;
      case DataFlowType.DATA_FLOW_TYPE_UP:
        sharedNetworkImage = isWhite ? $r('app.media.ic_status_bar_distributed_up_white_pc') :
        $r('app.media.ic_status_bar_distributed_up_pc');
        break;
      case DataFlowType.DATA_FLOW_TYPE_UP_DOWN:
        sharedNetworkImage = isWhite ? $r('app.media.ic_status_bar_distributed_up_down_white_pc') :
        $r('app.media.ic_status_bar_distributed_up_down_pc');
        break;
      case DataFlowType.DATA_FLOW_TYPE_NONE:
      case DataFlowType.DATA_FLOW_TYPE_DORMANT:
        sharedNetworkImage = isWhite ? $r('app.media.ic_status_bar_distributed_up_down_0_white_pc') :
        $r('app.media.ic_status_bar_distributed_up_down_0_pc');
        break;
      default:
        sharedNetworkImage = isWhite ? $r('app.media.ic_status_bar_distributed_modem_white_pc') :
        $r('app.media.ic_status_bar_distributed_modem_pc');
        break;
    }
    return sharedNetworkImage;
  }

  public getSharedNetworkTips(): string {
    log.info('getSharedNetworkTips');
    let context = GlobalContext.getContext();
    let deviceName: string = DISTRIBUTED_DEVICE_NAME_DEFAULT;
    let canUseCalls: string = DISTRIBUTED_CALL_STATE_DEFAULT;
    let canUseSms: string = DISTRIBUTED_SMS_STATE_DEFAULT;
    let isWifiConnected: boolean = false;
    try {
      deviceName = Settings.getValueSync(context, DISTRIBUTED_DEVICE_NAME, DISTRIBUTED_DEVICE_NAME_DEFAULT);
      canUseCalls = Settings.getValueSync(context, DISTRIBUTED_CALL_STATE, DISTRIBUTED_CALL_STATE_DEFAULT);
      canUseSms = Settings.getValueSync(context, DISTRIBUTED_SMS_STATE, DISTRIBUTED_SMS_STATE_DEFAULT);
      log.info(` get ${DISTRIBUTED_CALL_STATE} value is ${canUseCalls} get ${DISTRIBUTED_SMS_STATE} value is ${canUseSms}`);
    } catch (e) {
      log.error(`get settings switch value error. use default`);
    }
    if (!this.isShow) {
      return '';
    }
    if (this.isNetworkSharing) {
      return ResUtils.getInnerStringNumS($r('app.string.shared_network_tips'), `${deviceName}`);
    }
    if (this.isSharedNetworkAvailable) {
      if (canUseCalls === STATE_ON && canUseSms === STATE_ON) {
        return ResUtils.getInnerStringNumS($r('app.string.shared_network_tips1'), `${deviceName}`);
      }
      if (canUseCalls === STATE_ON) {
        return ResUtils.getInnerStringNumS($r('app.string.shared_network_tips_network_calls'), `${deviceName}`);
      }
      if (canUseSms === STATE_ON) {
        return ResUtils.getInnerStringNumS($r('app.string.shared_network_tips_network_messages'), `${deviceName}`);
      }
      return ResUtils.getInnerStringNumS($r('app.string.shared_network_tips_network'), `${deviceName}`);
    }
    return '';
  }
}

export let pluginDistributedController = new PluginDistributedController();