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
import { Singleton } from '../utils/Singleton';
import { common, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';

let TAG = 'MetaServiceConnectExtension'
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const UNKNOWN_ERROR = 100;
const COMMAND_CLOSE_LIVE_VIEW_SWITCH = 4;
interface IIdlSettingService {
  closeDeviceLiveViewSwitch(sceneId: string, serviceBundleName: string,
    callback: closeLiveViewSwitchCallback): void;
}

type closeLiveViewSwitchCallback = (errCode: number, returnValue: number) => void;

class IdlSettingServiceProxy implements IIdlSettingService {

  constructor(proxy: rpc.IRemoteObject) {
    this.proxy = proxy;
  }

  closeDeviceLiveViewSwitch(sceneId: string, serviceBundleName: string, callback: closeLiveViewSwitchCallback): void {
    log.showInfo('into closeDeviceLiveViewSwitch')
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeString(sceneId);
    dataSequence.writeString(serviceBundleName);
    this.proxy.sendMessageRequest(COMMAND_CLOSE_LIVE_VIEW_SWITCH, dataSequence, replySequence,
      option)
      .then((result: rpc.RequestResult) => {
        try {
          log.showInfo(TAG + 'call success')
          let errCodeVar = result.reply.readInt();
          let returnValueVar = result.reply.readInt();
          callback(errCodeVar, returnValueVar);
        } catch (e) {
          log.showInfo(TAG + 'call failed')
          callback(UNKNOWN_ERROR, UNKNOWN_ERROR);
          log.showInfo('call service extension ability closeDeviceLiveViewSwitch method failed', e);
          return;
        }
      })
      .catch((e: Error) => {
        log.showInfo('sendMessageRequest failed, message: ' + e.message)
      })
      .finally(() => {
        dataSequence.reclaim();
        replySequence.reclaim();
      });
  }
  private proxy: rpc.IRemoteObject;
}

// 未安装实况卡片，点击拒绝，调用元服务接口
export class MetaServiceConnect {
  private context = GlobalContext.getContext()

  @Singleton.decorate()
  public static get instance(): MetaServiceConnect {
    return new MetaServiceConnect();
  }

  public collectMetaSerciveLiveChange(sceneId: string, appId: string): void {
    log.showInfo(`requestCloseLiveViewSitch, appId: ${appId}`);
    let want: Want = {
      bundleName: 'com.ohos.asde',
      abilityName: 'settingExtensionAbility',
    };
    let options: common.ConnectOptions = {
      onConnect(elementName, remote: rpc.IRemoteObject) {
        log.showInfo(`requestCloseLiveViewSitch, appId: ${appId}`);
        if (remote === null) {
          log.showInfo(`onConnect remote is null`);
          return;
        }
        log.showInfo(`connect`);
        let proxy: IdlSettingServiceProxy = new IdlSettingServiceProxy(remote);
        proxy.closeDeviceLiveViewSwitch(sceneId, appId,
          (errorCode: number, retVal: number) => {
            log.showInfo(`requestCloseLiveViewSitch, errorCode: ${errorCode}, retVal: ${retVal}`);
          });
        log.showInfo('onConnect...');
      },
      onDisconnect(elementName) {
        log.showInfo('onDisconnect...');
      },
      onFailed(code) {
        log.showInfo('onFailed...');
      },
    };
    try {
      this.context.connectServiceExtensionAbility(want, options);
    } catch (err) {
      // 处理入参错误异常
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      log.error(`connectServiceExtensionAbility failed, code is ${code}, message is ${message}`);
    }
  }
}


