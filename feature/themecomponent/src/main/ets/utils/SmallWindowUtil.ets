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

import { common } from '@kit.AbilityKit';
import { settings } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { Log } from '../aigcServiceAbility/IdlService/Log';

const TAG: string = 'SmallWindowUtil';

const SETTINGS_WINDOW_MODE: string = 'settings.windowMode';
const DEFAULT_VALUE: string = '-1';
const WINDOW_FLOATING: number = 4;
const WINDOW_SPLIT_SCREEN: number = 5;
const DIALOG_Y: number = -96;
const SYSTEM_TOP_MOST: number = 2;

export class SmallWindowUtil {
  public static checkWindowSmall(): boolean {
    let windowStatusType: number = -1;
    try {
      let context = getContext() as common.ExtensionContext;
      windowStatusType = Number(settings.getValueSync(context, SETTINGS_WINDOW_MODE, DEFAULT_VALUE));
      Log.info(TAG, `checkWindowFull windowStatusType ${windowStatusType}`);
    } catch (err) {
      Log.error(TAG, `get windowStatusType err, code: ${err.code}`);
    }
    return ((windowStatusType === WINDOW_FLOATING) || (windowStatusType === WINDOW_SPLIT_SCREEN));
  }

  public static showToast(): void {
    Log.info(TAG, 'show toast');
    try {
      promptAction.showToast({
        showMode: SYSTEM_TOP_MOST,
        message: $r('app.string.icon_edit_not_support_small_step'),
        alignment: Alignment.Bottom,
        offset: {
          dx: 0, dy: vp2px(DIALOG_Y)
        },
      });
    } catch (err) {
      Log.error(TAG, `show toast failed: ${err?.code} - ${err?.message}`);
    }
    return;
  }
}