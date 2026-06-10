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

import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import lazy { sharedData } from '../model/SendableData';
import lazy { DropdownController } from '../template/DropdownController';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import { WindowConstants } from '@ohos/commonconstants';
import { DropDownPanelManagerWrapper } from '@ohos/frameworkwrapper';

export class DropDownAdapter {
  public static getDropDownId(): number {
    if (ThreadUtil.isMainThread) {
      return DropdownController.getInstance().getId();
    } else {
      return sharedData.dropdownPersistentId;
    }
  }

  public static isDropDownShow(): boolean {
    if (ThreadUtil.isMainThread) {
      return windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN);
    } else {
      return sharedData.isDropDownShow;
    }
  }

  public static hideWindowDirectly(): void {
    // 子线程使用adapter场景，判断面板是否处于显示状态
    if (!ThreadUtil.isMainThread && !sharedData.isDropDownShow) {
      return;
    }

    DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
  }
}