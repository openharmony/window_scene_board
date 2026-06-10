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

import commonEventManager from '@ohos.commonEventManager';
import { AsyncCallback } from '@kit.BasicServicesKit';

/*
 * 公共事件注册封装接口类
 */
export interface TsCommonEventSubscribe {
  /**
   * 获取需要注册的公共事件信息
   * @param userId 需要接收公共事件的用户ID
   * @returns 需要注册的公共事件信息
   */
  getSubscribeInfo(userId?: number): commonEventManager.CommonEventSubscribeInfo;

  /**
   * 对应的公共事件接收处理回调
   * @returns 公共事件接收处理回调
   */
  getCallback(): AsyncCallback<commonEventManager.CommonEventData>;
}