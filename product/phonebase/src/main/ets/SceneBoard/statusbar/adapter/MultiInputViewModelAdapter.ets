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

import lazy { MultiInputViewModel } from '@ohos/multiinput/src/main/ets/default/common/viewmodel/MultiInputViewModel';
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/newTsIndex';
import { ThreadCallCommRegisterIntf } from '@ohos/systemuicommon/src/main/ets/messageChannel/ThreadCall';

export class MultiInputViewModelAdapter {

  @threadCall()
  public static updateStatusAndFloatingTitleFromGestureTopBar(isShow: boolean): void {
    MultiInputViewModel.getInstance().updateStatusAndFloatingTitleFromGestureTopBar(isShow);
  }
  @threadCall(ThreadCallType.Sync)
  public static isPreventHideTitleBarStatusBar(): boolean {
    return MultiInputViewModel.getInstance().isPreventHideTitleBarStatusBar();
  }
  @threadCall()
  public static setPreventHideTitleBarStatusBar(isHold: boolean): void {
    MultiInputViewModel.getInstance().setPreventHideTitleBarStatusBar(isHold);
  }
  @threadCall(ThreadCallType.Register)
  public static registerStatusBarVisibleCallback(obj: ThreadCallCommRegisterIntf, tag: string) {
    MultiInputViewModel.getInstance().registerStatusBarVisibleCallback(obj.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterStatusBarVisibleCallback(obj: ThreadCallCommRegisterIntf, tag: string) {
    MultiInputViewModel.getInstance().unregisterStatusBarVisibleCallback(obj.callback);
  }
}