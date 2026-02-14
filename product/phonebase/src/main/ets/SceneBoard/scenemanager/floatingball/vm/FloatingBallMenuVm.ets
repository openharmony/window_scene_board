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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FloatingBallBaseVm } from './FloatingBallBaseVm';
import { IFloatingBallMenuVm } from '../interface/IFloatingBallMenuVm';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';

const TAG = 'FloatingBallMenuVm';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ObservedV2
export class FloatingBallMenuVm extends FloatingBallBaseVm implements IFloatingBallMenuVm {
  @Trace public isShow: boolean = false;
  @Trace public opacity: number = 1;
  @Trace public scale: number = 1;
  public width: number = 0;
  public height: number = 0;

  constructor(vmInjector: IFloatingBallInjector) {
    log.showInfo(TAG, 'menu vm constructor');
    super(vmInjector);
  }

  public init(width: number, height: number): void {
    this.width = width;
    this.height = height;
    this.opacity = 0;
    this.scale = 1;
  }

  public destroy(): void {
    log.showInfo(TAG, 'menu vm destroy');
  }
}