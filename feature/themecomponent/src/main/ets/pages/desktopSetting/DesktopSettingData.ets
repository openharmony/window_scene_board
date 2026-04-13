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

/**
 * DesktopSetting数据类
 */
@Observed
export class DesktopSettingData {

  private _autoAlignStatus: boolean = false;

  private _lockLayoutStatus: boolean = false;

  public set autoAlignStatus(value: boolean) {
    this._autoAlignStatus = value;
  }

  public get autoAlignStatus(): boolean {
    return this._autoAlignStatus;
  }

  public set lockLayoutStatus(value: boolean) {
    this._lockLayoutStatus = value;
  }

  public get lockLayoutStatus(): boolean {
    return this._lockLayoutStatus;
  }

  public toString(): string {
    return `DesktopSettingData autoAlignStatus: ${this.autoAlignStatus}` +
      `, lockLayoutStatus: ${this.lockLayoutStatus}`;
  }
}