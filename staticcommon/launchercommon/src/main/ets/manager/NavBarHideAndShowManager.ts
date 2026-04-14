/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'NavBarHideAndShowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 注册、执行及销毁导航条显示与隐藏
 */
export class NavBarHideAndShowManager {

  private navBarHideAndShowCallback?: Function = undefined;

  /**
   * 获取 NavBarHideAndShowManager 单例
   * @returns NavBarHideAndShowManager
   */
  public static getInstance(): NavBarHideAndShowManager {
    return SingletonHelper.getInstance(NavBarHideAndShowManager, TAG);
  }

  /**
   * 注册翻页导航条显示与隐藏
   * @param registerSource 注册来源
   * @param callback 回调函数
   */
  public registerNavBarHideAndShowCallback(registerSource: string, callback: Function): void {
    log.info(`registerNavBarHideAndShowCallback: ${registerSource}`);
    if (callback) {
      log.info(`NavBarHideAndShowCallback is not null`);
      this.navBarHideAndShowCallback = callback;
    }
  }

  /**
   * 销毁导航条显示与隐藏
   * @param unRegisterSource 销毁类型
   */
  public unRegisterNavBarHideAndShowCallback(unRegisterSource: string): void {
    log.info(`unRegisterNavBarHideAndShowCallback: ${unRegisterSource}`);
    if (this.navBarHideAndShowCallback) {
      this.navBarHideAndShowCallback = undefined;
    }
  }

  /**
   * 执行导航条显示与隐藏
   * @param executeSource 执行类型
   * @param isShow 显示
   */
  public executeCallbackByType(executeSource: string, isShow: boolean): void {
    log.info(`executeSource: ${executeSource}`);
    if (this.navBarHideAndShowCallback) {
      log.info(`isShow: ${isShow}`);
      this.navBarHideAndShowCallback(isShow);
    }
  }
}