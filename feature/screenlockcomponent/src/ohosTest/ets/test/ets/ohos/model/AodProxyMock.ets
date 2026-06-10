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
import { AodElemPosition } from '@ohos/themeservice';
import IAodProxy from '../../../../../../main/ets/onemirror/model/IAodProxy';

export class AodProxyMock implements IAodProxy {
  isPartAodPlayMirror(): boolean {
    return false;
  }

  isOnlineMixAod(): boolean {
    return false;
  }

  isFullAodPlayMirror(): boolean {
    return false;
  }

  isPartEmoji(): boolean {
    return this._mockIsPartEmoji;
  }

  isPartScreenAOD(): boolean {
    return this._mockIsPartScreenAOD;
  }

  isFingerprintEnable(): boolean {
    return true;
  }

  private _mockResult: boolean = false;
  private _mockIsSupportAod: boolean = false;
  private _mockIsPartEmoji: boolean = false;

  public set mockIsPartEmoji(value: boolean) {
    this._mockIsPartEmoji = value;
  }

  public get mockIsPartEmoji(): boolean {
    return this._mockIsPartEmoji;
  }
  private _mockIsPartScreenAOD: boolean = false;

  public set mockIsPartScreenAOD(value: boolean) {
    this._mockIsPartScreenAOD = value;
  }

  public get mockIsPartScreenAOD(): boolean {
    return this._mockIsPartScreenAOD;
  }

  public set mockResult(value: boolean) {
    this._mockResult = value;
  }

  public get mockResult(): boolean {
    return this._mockResult;
  }

  public set mockIsSupportAod(value: boolean) {
    this._mockIsSupportAod = value;
  }

  public get mockIsSupportAod(): boolean {
    return this._mockIsSupportAod;
  }

  checkAod(): Promise<void> {
    return new Promise(() => {
    });
  }

  isFullScreenAOD(): boolean {
    return true;
  }

  isAODEnable(): boolean {
    return this._mockIsSupportAod;
  }

  isAodDataInValid(): boolean {
    return false;
  }

  updateTPState(isOpen: boolean): void {

  }

  start(isSupportScreenToEnd : boolean): Promise<void> {
    this._mockResult = true;
    return new Promise(() => {
    });
  }

  stop(screenStatus: number): Promise<void> {
    this._mockResult = true;
    return new Promise(() => {
    });
  }

  getAodLayerInfo(isRealtime: boolean): Promise<AodElemPosition> {
    return new Promise((resolve, reject) => {
      resolve({ type: 0 });
    });
  }
}