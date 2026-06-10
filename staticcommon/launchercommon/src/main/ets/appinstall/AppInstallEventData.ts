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

/**
 * 应用安装发送事件数据类
 */
export class AppInstallEventData {
  private _eventName: string = '';
  private _bundleName: string = '';
  private _appIndex: number = 0;

  public set appIndex(value: number) {
    this._appIndex = value;
  }

  public get appIndex(): number {
    return this._appIndex;
  }

  public set eventName(value: string) {
    this._eventName = value;
  }

  public get eventName(): string {
    return this._eventName;
  }

  public set bundleName(value: string) {
    this._bundleName = value;
  }

  public get bundleName(): string {
    return this._bundleName;
  }
}