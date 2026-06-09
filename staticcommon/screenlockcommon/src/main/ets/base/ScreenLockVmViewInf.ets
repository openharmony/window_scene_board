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

import { KeyGuardMode } from '../bean/KeyGuardStatusEnum';
import { KeyguardStatusService } from '../manager/KeyguardStatusService';
import { AbstractInitialAble } from './AbstractInitialAble';
import { CacheValue } from './GlobalStatusCache';

/**
 * 基础View层的VM
 */
export abstract class BaseViewVm extends AbstractInitialAble {
  private _persistentId: number;

  private modeChangeCallback: Callback<CacheValue> = ((val: CacheValue) => {
    this.onModeChanged(val as KeyGuardMode);
  });

  constructor(persistentId: number) {
    super();
    this._persistentId = persistentId;
  }

  public get persistentId(): number {
    return this._persistentId;
  }

  /**
   * [继承接口]
   *
   * @param _params 初始化参数
   */
  protected doInit(_params?: object): void {
    KeyguardStatusService.onModeChanged(this.modeChangeCallback);
  }

  /**
   * [继承接口]
   *
   * @param mode 当前新的模式
   */
  protected onModeChanged(mode: KeyGuardMode): void {
  }

  /**
   * [继承接口]
   */
  protected doRelease(): void {
    KeyguardStatusService.onModeChangedUnsubscribe(this.modeChangeCallback);
  }
}