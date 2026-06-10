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

import { rpc } from '@kit.IPCKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';

const TAG = 'ThemeServiceConnector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 负责连接和断开ThemeOpenServiceExtAbility
 */
export default class ThemeServiceConnector {
  private static connectId: number | undefined;

  public static connect(context: common.UIAbilityContext): Promise<rpc.IRemoteObject> {
    log.showInfo('connect');
    return new Promise((resolve, reject) => {
      let want: Want = {
        deviceId: '',
        bundleName: 'com.ohos.thememanager',
        abilityName: 'ThemeOpenServiceExtAbility'
      };
      let options: common.ConnectOptions = {
        onConnect(elementName, remote) {
          log.showInfo(`onConnect, elementName = ${elementName}`);
          if (!remote) {
            log.showError('onConnect remote is null');
            reject('onConnect remote is null');
          }
          resolve(remote);
        },
        onDisconnect(elementName) {
          log.showInfo(`onDisconnect, elementName = ${elementName}`);
        },
        onFailed(code) {
          log.showError('connect failed');
          reject(`connect failed, code = ${code}`);
        }
      };
      ThemeServiceConnector.connectId = context?.connectServiceExtensionAbility(want, options);
    });
  }

  public static disconnect(context: common.UIAbilityContext): void {
    try {
      context?.disconnectServiceExtensionAbility(ThemeServiceConnector.connectId).then(() => {
        log.showInfo('disconnectServiceExtensionAbility success');
      }).catch((error: Error) => {
        log.showError(`disconnectServiceExtensionAbility failed: ${error?.message}}`);
      });
    } catch (error) {
      log.showError(`disconnectServiceExtensionAbility failed: ${error?.message}}`);
    }
  }
}