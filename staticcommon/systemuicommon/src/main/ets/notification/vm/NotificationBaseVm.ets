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
import { BaseVm } from '../../vm/BaseVm';
import { NotificationBase } from '../../model/NotificationBase';
import { INotificationVmInjector } from '../interface/INotificationVmInjector';

export class NotificationBaseVm extends BaseVm<INotificationVmInjector> {}

/**
 * 与每一条通知相关的VM
 */
@ObservedV2
export class NotificationItemBaseVm<T extends NotificationBase = NotificationBase> extends NotificationBaseVm {
  @Trace public ntf: T;

  constructor(vmInjector: INotificationVmInjector, ntf: T) {
    super(vmInjector);
    this.ntf = ntf;
  }

  init(): void { }

  destroy(): void {}

  onUpdate(ntf: T): void {
    this.ntf = ntf;
  }
}