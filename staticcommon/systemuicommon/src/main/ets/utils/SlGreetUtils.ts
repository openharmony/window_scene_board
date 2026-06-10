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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'SlGreetUtils';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

class SlGreetUtils {
  private _slGreetViewIsShow: boolean = false;

  public set slGreetViewIsShow(value: boolean) {
    if (this._slGreetViewIsShow === value || value === undefined) {
      return;
    }
    this._slGreetViewIsShow = value;
  }

  public get slGreetViewIsShow(): boolean {
    return this._slGreetViewIsShow;
  }
}

export let slGreetUtils: SlGreetUtils =
  SingletonHelper.getInstance(SlGreetUtils, TAG);