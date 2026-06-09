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

import { NotificationListVm } from '@ohos/notificationcomponent/newIndex';
import { NormalNotificationGroup, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { IUpdateParam } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationListVm';
import { IGraftNtfListVm } from '../../../common/interface/IGraftNtfListVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';

/**
 * 嫁接通知中心List业务
 */
export class GraftNtfListVm extends NotificationListVm implements IGraftNtfListVm {
  // 业务注入器
  protected vmInjector: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.vmInjector = vmInjector;
  }

  updateNtf(updateParam: IUpdateParam): void {
    // 主要用于解除组通知时刷新，嫁接沉浸列表数据刷新
    this.vmInjector?.getImmersiveListVm()?.graftUpdateNtf();
  }

  groupForEach(callback: (value: NotificationBase, key: string, map: Map<string, NotificationBase>) => void): void {
    // 嫁接沉浸数据管理
    return this.vmInjector?.getImmDataVm()?.groupForEach(callback);
  }

  getNtfByGroupKey(groupKey: string): NotificationBase | undefined {
    // 嫁接沉浸数据管理
    return this.vmInjector?.getImmDataVm()?.getNtfByGroupKey(groupKey);
  }

  getNtfByHashCode(hashcode: string): NotificationBase | undefined {
    // 嫁接沉浸数据管理
    return this.vmInjector?.getImmDataVm()?.getNtfByHashCode(hashcode);
  }

  getGroupNtf(ntf: NotificationBase): NormalNotificationGroup | undefined {
    // 嫁接沉浸数据管理
    return this.vmInjector?.getImmDataVm()?.getGroupNtf(ntf);
  }

  releaseGroup(group: NormalNotificationGroup): void {
    // 嫁接沉浸数据管理
    return this.vmInjector?.getImmDataVm()?.releaseGroup(group);
  }
}