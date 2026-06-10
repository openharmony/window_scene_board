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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppNameVm } from './AppNameVm';

const TAG = 'AppNameEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppNameEvent {
  private appNameVm: AppNameVm;

  constructor(vm: AppNameVm) {
    this.appNameVm = vm;
  }

  public init(): void {
    this.appNameVm.modifier.onInit = (): void => {
      this.appNameVm.modifier.attribute?.opacity(1);
    }
  }

  /**
   * 应用名隐藏/显示动效
   * @param isDisappear 是否隐藏应用名
   */
  public appNameDisappearAnimate(isDisappear: boolean) {
    log.showInfo(`appNameDisappearAnimate isDisappear: ${isDisappear}`);
    animateTo({
      duration: 100,
      curve: Curve.Linear,
    }, () => {
      this.appNameVm.modifier.attribute?.opacity(isDisappear ? 0.01 : 0.99);
    })
  }

  /**
   * 设置应用名透明度
   * @param opacity 应用名透明度
   */
  public changeAppNameOpacity(opacity: number) {
    animateTo({
      duration: 200,
      curve: Curve.Linear,
    }, () => {
      this.appNameVm.modifier.attribute?.opacity(opacity);
    })
  }
}