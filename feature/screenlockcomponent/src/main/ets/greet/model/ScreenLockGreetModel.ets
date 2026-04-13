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
import { SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import Constants, { SlGreetStateListener } from '../constant/Constants';

const TAG = 'ScreenLockGreetModel';

class ScreenLockGreetModel {
  registerStateChangeListener(key: string = Constants.CLOCK_LISTENER, listener: SlGreetStateListener): void {
  }

  unRegisterStateChangeListener(key: string = Constants.CLOCK_LISTENER, listener: SlGreetStateListener): void {
  }

  public unLoadGreetViewWithoutAni(scene: string = ''): void {
  }
}

export let screenLockGreetModel: ScreenLockGreetModel = SingletonHelper.getInstance(ScreenLockGreetModel, TAG);