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

import { NotificationSwipeVm } from '@ohos/notificationcomponent/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { IImmersiveNtfSwipeVm } from '../../../common/interface/IImmersiveNtfSwipeVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';

/**
 * 沉浸列表条目侧滑业务管理
 */
@ObservedV2
export class ImmersiveNtfSwipeVm extends NotificationSwipeVm implements IImmersiveNtfSwipeVm {
  // 业务注入器
  protected vmInjector: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector, ntf: NotificationBase) {
    super(vmInjector, ntf);
    this.vmInjector = vmInjector;
  }

  protected checkNeedReset(): boolean {
    if (this.cardVm?.isTouching) {
      return false;
    }
    return super.checkNeedReset();
  }
}