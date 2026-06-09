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
import { SysApiWrapper } from '../../../../../main/ets/com/ohos/common/SysApiWrapper';

export class DtHelper {
  /**
   * mock系统接口
   */
  public static mockSysApi() {
    SysApiWrapper.animateTo = (value: AnimateParam, event: () => void): void => {
      event?.();
      value?.onFinish?.();
    };
    SysApiWrapper.setTimeout = (handler: Function | string, delay?: number): number => {
      (handler as Function)?.();
      return Math.random();
    }
  }

  /**
   * 恢复系统接口
   */
  public static restoreSysApi() {
    SysApiWrapper.animateTo = (value: AnimateParam, event: () => void): void => {
      animateTo(value, event);
    }
    SysApiWrapper.setTimeout = (handler: Function | string, delay?: number): number => {
      return setTimeout(handler, delay);
    }
  }
}