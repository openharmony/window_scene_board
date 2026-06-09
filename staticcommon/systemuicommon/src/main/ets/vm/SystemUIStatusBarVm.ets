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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'SystemUIStatusBarVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * SystemUI状态栏ViewModel
 */
@Observed
export class SystemUIStatusBarVm {
  public static get = SingletonHelper.createFactory(() => new SystemUIStatusBarVm());

  /**
   * 状态栏节点组缓存是否开启
   */
  public renderGroupEnable: boolean = true;
  /**
   * 状态栏是否显示模糊组件
   */
  public isShowBlue: boolean = false;
  /**
   * 状态栏模糊组件是否响应变化
   */
  public showBlueChangeEnable: boolean = true;
  /**
   * 状态栏是否显示渐变背景
   */
  public isShowGradientBackground: boolean = false;
  /**
   * 在外屏锁屏界面下拉通知中心输入密码并解锁以后，是否需要展示通知中心
   */
  public isShowNCAfterUnlock: boolean = false;
  /**
   * 切换状态栏节点组缓存的禁用和开启
   */
  public changeRenderGroupEnable(enable : boolean) {
    if (this.renderGroupEnable === enable) {
      return;
    }
    this.renderGroupEnable = enable;
  }

  /**
   * 切换模糊组件响应变化的开启和禁用
   */
  public changeShowBlueEnable(enable: boolean) {
    if (!enable) {
      this.changeIsShowBlue(false);
    }
    if (this.showBlueChangeEnable === enable) {
      return;
    }
    this.showBlueChangeEnable = enable;
    log.showInfo(`BlurAreaVisibilityEvent changeShowBlueEnable ${this.showBlueChangeEnable}`);
  }
  /**
   * 切换状态栏底部的模糊组件显示或隐藏
   */
  public changeIsShowBlue(isShow: boolean) {
    if (this.isShowBlue === isShow || !this.showBlueChangeEnable) {
      return;
    }
    this.isShowBlue = isShow;
    log.showInfo(`BlurAreaVisibilityEvent isShowBlue: ${this.isShowBlue} ,Enable ${this.showBlueChangeEnable}`);
  }

  /**
   * 设置状态栏是否显示渐变背景色
   * @param isShow
   */
  public setIsShowGradientBackground(isShow: boolean) {
    if (this.isShowGradientBackground === isShow) {
      return;
    }
    this.isShowGradientBackground = isShow;
    log.showInfo(`isShowGradientBackground: ${this.isShowGradientBackground}`);
  }
  /**
   * 扩展可折叠设备外屏解锁后，是否继续展示通知中心开关
   */
  public changeIsShowNCAfterUnlock(isShowNCAfterUnlock: boolean, reason?: string) {
    if (this.isShowNCAfterUnlock === isShowNCAfterUnlock) {
      return;
    }
    this.isShowNCAfterUnlock = isShowNCAfterUnlock;
    log.showInfo(`changeIsShowNCAfterUnlock to ${this.isShowNCAfterUnlock} reason:${reason ?? 'default reason'}`);
  }

  /**
   * 获取isShowNCAfterUnlock
   */
  public getIsShowNCAfterUnlock(): boolean {
    return this.isShowNCAfterUnlock;
  }
}