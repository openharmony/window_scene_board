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
import accessibility from '@ohos.accessibility';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants from '../model/Constants';
import { StringUtil } from '../model/StringUtil';

const TAG: string = 'AccessibilityUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class AccessibilityUtil {
  /**
   * 判断当前是否在无障碍模式下
   */
  public static isAccessibilityMode(): boolean {
    if (accessibility.isOpenAccessibilitySync() && accessibility.isOpenTouchGuideSync()) {
      return true;
    }
    return false;
  }

  /**
   * 发送主动聚焦事件
   */
  public static requestFocusForAccessibility(uniqueId: string) {
    if (StringUtil.checkStrIsEmpty(uniqueId)) {
      return;
    }
    
    let eventInfo: accessibility.EventInfo = ({
      type: 'requestFocusForAccessibility',
      bundleName: Constants.SCENE_BOARD_BUNDLE_NAME,
      triggerAction: 'common',
      customId: Constants.DEVICE_ITEM_ID + uniqueId
    });

    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      log.showInfo(`Succeeded in send event`);
    });
  }
}
