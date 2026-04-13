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

import Notification from '@ohos.notificationManager';
import resourceManager from '@ohos.resourceManager';
import { wantAgent } from '@kit.AbilityKit';
import INotificationConfig from './INotificationConfig';
import AigcNotificationManager, { AigcNoticeType } from './AigcNotificationManager';
import { Log } from '../IdlService/Log';

const TAG = '[AigcService]PandoraNotificationConfig';
const NOTIFICATION_ID: number = 522;
const AIGC_NOTIFICATION_ID: number = 523;
const DYNAMIC_NOTIFICATION_ID: number = 524;
const DEFAULT_VERSION: string = 'default';
const AIGC_VERSION: string = 'V2';
const DYNAMIC_VERSION: string = 'V3';

const DEFAULT_NOTIFICATION_CONTENT: Map<AigcNoticeType, Resource> = new Map([
  [AigcNoticeType.EXECUTING, $r('app.string.notification_main_time_travel_ongoing_content')],
  [AigcNoticeType.FINISH, $r('app.string.notification_main_time_travel_finish_content')],
  [AigcNoticeType.FAIL, $r('app.string.time_travel_generate_failed')]
])

const AIGC_NOTIFICATION_CONTENT: Map<AigcNoticeType, Resource> = new Map([
  [AigcNoticeType.EXECUTING, $r('app.string.notification_main_dimensional_travel_ongoing_content')],
  [AigcNoticeType.FINISH, $r('app.string.notification_main_dimensional_travel_finish_content')],
  [AigcNoticeType.FAIL, $r('app.string.dimensional_travel_generate_failed')]
]);

const DYNAMIC_NOTIFICATION_CONTENT: Map<AigcNoticeType, Resource> = new Map([
  [AigcNoticeType.EXECUTING, $r('app.string.notification_dynamic_lead_ongoing_content')],
  [AigcNoticeType.FINISH, $r('app.string.notification_dynamic_lead_finish_content')],
  [AigcNoticeType.FAIL, $r('app.string.dynamic_lead_generate_failed')]
]);

const NOTIFICATION_CONTENT_MAP: Map<string, Map<AigcNoticeType, Resource>> = new Map([
  [DEFAULT_VERSION, DEFAULT_NOTIFICATION_CONTENT],
  [AIGC_VERSION, AIGC_NOTIFICATION_CONTENT],
  [DYNAMIC_VERSION, DYNAMIC_NOTIFICATION_CONTENT],
]);

export default class PandoraNotificationConfig implements INotificationConfig {
  getNotificationId(version?: string): number {
    return version === AIGC_VERSION ? AIGC_NOTIFICATION_ID :
      version === DYNAMIC_VERSION ? DYNAMIC_NOTIFICATION_ID : NOTIFICATION_ID;
  }

  async getWantAgent(editorId: string, status: number, errCode: number, version?: string): Promise<object | null> {
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: 'com.ohos.sceneboard',
          abilityName: version === AIGC_VERSION ? 'ThemeComponentAbility' : 'AigcAbility',
          parameters: {
            'ability.want.params.uiExtensionType': 'sys/commonUI',
            'editorId': editorId,
            'startMode': AigcNotificationManager.NOTIFICATION_MODE,
            'status': status,
            'errCode': errCode,
            'version': version ?? '',
            'loadContent': 'pages/AigcHome',
            'noticePullUp': 'PandoraPullUpFinished',
            // 'pushPathName': version === DYNAMIC_VERSION ? Constants.DYNAMICS_THEME_EDITOR : 'pandoraThemeEditor'
            'pushPathName': 'pandoraThemeEditor'
          }
        }
      ],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 200
    }
    try {
      return await wantAgent.getWantAgent(wantAgentInfo);
    } catch (err) {
      Log.error(TAG, `get want agent has an error, msg: ${err?.message}, code: ${err?.code}.`);
      return null;
    }
  }

  buildTextContent(resourceManager: resourceManager.ResourceManager,
    type: number, version?: string): Notification.NotificationBasicContent | undefined {
    let msgName: string = '';
    let msgContent: string = '';
    try {
      msgName = resourceManager.getStringSync($r('app.string.notification_main_pandora_title'));
      version = version ? version : DEFAULT_VERSION;
      const notificationContentMap: Map<AigcNoticeType, Resource> | undefined = NOTIFICATION_CONTENT_MAP.get(version);
      msgContent = resourceManager.getStringSync(notificationContentMap?.get(type));
      let textContent: Notification.NotificationBasicContent = {
        title: msgName,
        text: msgContent
      }
      return textContent;
    } catch (err) {
      Log.error(TAG, `get notification text error. Code is ${err?.code}, message is ${err?.message}`);
      return undefined;
    }
  }
}