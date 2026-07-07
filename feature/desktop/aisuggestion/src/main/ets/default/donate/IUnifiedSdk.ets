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
// import type { DispatchParams } from '@ohos-aidispatch/abilitybasesdkoh/src/main/ets/beans/DispatchParams';
import type common from '@ohos.app.ability.common';

/**
 * 统一SDK接口
 *
 * @since 2023-08-11
 */
export interface IUnifiedSdk {
  /**
   * 连接服务
   *
   * @param context 上下文
   * @returns 连接结果
   */
  connect(context: common.UIAbilityContext | common.ServiceExtensionContext): Promise<void>;

  /**
   * 断连服务
   */
  disconnect(): void;

  /**
   * 发送消息
   *
   * @param dispatchParams 消息的json数据
   * @returns payload对象
   */
  dispatch(dispatchParams: ESObject): Promise<object>;
}