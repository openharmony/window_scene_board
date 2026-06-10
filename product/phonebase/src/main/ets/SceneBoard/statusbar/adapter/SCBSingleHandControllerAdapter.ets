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
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/newTsIndex';
import lazy {
  SCBSingleHandController, SingleHandRect,
  SingleHandStatusChangeCallback
} from '../../scenemanager/onehandmode/SCBSingleHandController';
const TAG = 'SCBSingleHandControllerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface SingleHandStatusChangeIntf{
  callingName: string;
  callback: SingleHandStatusChangeCallback;
}

export enum SingleHandMode {
  LEFT = 'left',
  RIGHT = 'right',
  MIDDLE = 'middle',
}

export class SCBSingleHandControllerAdapter {

  public static init() {

  }

  @threadCall(ThreadCallType.Register)
  public static registerSingleHandStatusChangeCallback(callback: SingleHandStatusChangeCallback, tag: string): void {
    log.showInfo(`registerSingleHandStatusChangeCallback tag ${tag}`)
    SCBSingleHandController.getInstance()
      .registerSingleHandStatusChangeCallback(TAG, callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unregisterSingleHandStatusChangeCallback(callback: SingleHandStatusChangeCallback, tag: string): void {
    log.showInfo(`unregisterSingleHandStatusChangeCallback tag ${tag}`)
    return SCBSingleHandController.getInstance()
      .unregisterSingleHandStatusChangeCallback(TAG);
  }

  @threadCall(ThreadCallType.Sync)
  public static GetCurrentSingleHandRect(): SingleHandRect {
    log.showInfo(`GetCurrentSingleHandRect`)
    return SCBSingleHandController.getInstance().GetCurrentSingleHandRect();
  }

}