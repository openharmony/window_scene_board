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
import { Logger, LogDomain } from '@ohos/basicutils';
import { Singleton } from '../utils/Singleton';

const TAG = 'StatusBarExternalVm';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@ObservedV2
export class StatusBarExternalVm {
  @Singleton.decorate()
  public static get instance(): StatusBarExternalVm { return new StatusBarExternalVm(); }
  /**
   * 状态栏是否显示渐变背景
   */
  @Trace public isShowGradientBackground: boolean = false;
  
  /**
   * 设置状态栏是否显示渐变背景色
   * @param isShow
   */
  public setIsShowGradientBackground(isShow: boolean) {
    if (this.isShowGradientBackground === isShow) {
      return;
    }
    this.isShowGradientBackground = isShow;
    log.showInfo(TAG, `isShowGradientBackground: ${this.isShowGradientBackground}`);
  }
}