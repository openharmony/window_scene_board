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
import { threadCall, ThreadCallCommRegisterIntf, ThreadCallType } from '../messageChannel/ThreadCall';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import lazy { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';
import lazy { DesktopModeManager } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopModeManager';

const TAG = 'DesktopModeManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface ModeChangeCallbackIntf extends ThreadCallCommRegisterIntf {
  registerTag: string;
  callback: (preDesktopMode:  DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => void;
}

export class DesktopModeManagerAdapter {
  @threadCall(ThreadCallType.Sync)
  public static getDesktopMode(): DesktopModeEnum {
    log.showInfo(`getDesktopMode`);
    return DesktopModeManager.getInstance().getDesktopMode();
  }

  @threadCall(ThreadCallType.Register)
  public static registerModeChangeCallback(obj: ModeChangeCallbackIntf, tag: string): void {
    log.showInfo(`registerModeChangeCallback tag ${tag}`)
    DesktopModeManager.getInstance()
      .registerModeChangeCallback(obj.registerTag, obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterModeChangeCallback(obj: ModeChangeCallbackIntf, tag: string): void {
    log.error(`unRegisterModeChangeCallback tag ${tag}`)
    DesktopModeManager.getInstance()
      .unRegisterModeChangeCallback(obj.registerTag);
  }
}