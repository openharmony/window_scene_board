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

import { NotificationSettingDialogView } from '@ohos/notificationcomponent/newIndex'
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';

@ComponentV2
export struct ImmersiveNtfSettingDialogView {
  // 状态管理器，默认通用管理器
  private stateMgrName: SlStateMgr = SlStateMgr.MGR_COMMON;

  // 沉浸通用业务能力注入器
  @Provider() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.getNtfInjector(this.stateMgrName) ??
  v2Helper.defaultNtfInjector;

  build() {
    NotificationSettingDialogView()
  }
}