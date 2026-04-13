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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'OuterHomeVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * SystemUI状态栏ViewModel
 */
@Observed
export class OuterHomeVm {
  public static get = SingletonHelper.createFactory(() => new OuterHomeVm());

  /**
   * 是否不响应大字体
   */
  public isIgnoreFontScaleState: boolean = false;
  /**
   * 外屏通知列表第一个组组件ID
   */
  public firstNtfCompId: string = '';
  /**
   * 小外屏不响应大字体开关
   */
  public changeIgnoreFontScaleState(isIgnoreFontScaleState : boolean) {
    if (this.isIgnoreFontScaleState === isIgnoreFontScaleState) {
      return;
    }
    log.showInfo(`changeIgnoreFontScaleState to ${this.isIgnoreFontScaleState}`)
    this.isIgnoreFontScaleState = isIgnoreFontScaleState;
  }
  /**
   * firstNtfCompId赋值方法
   */
  public setFirstNtfCompId(firstNtfCompId: string | undefined) {
    if (firstNtfCompId === undefined || this.firstNtfCompId === firstNtfCompId) {
      return;
    }
    log.showInfo(`setFirstNtfCompId to ${this.firstNtfCompId}`);
    this.firstNtfCompId = firstNtfCompId;
  }
}