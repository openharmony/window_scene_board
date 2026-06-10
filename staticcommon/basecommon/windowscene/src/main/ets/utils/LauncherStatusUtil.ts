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
import { SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'LauncherStatusUtil';

export class LauncherStatusUtil {
  private isShowOutLauncher: boolean = false;

  private isSimpleMode: boolean = false;

  private isDrawerMode: boolean = false;

  private isDesktopAddMode: boolean = false;

  private closeDrawerPage?: () => void;

  private openDrawerPage?: () => void;

  public updateShowOutLauncherStatus(isFolded: boolean): void {
      this.isShowOutLauncher = false;
  }

  /**
   * mock isShowOutLauncher, for DT use only
   *
   * @return string phone
   */
  public setShowOutLauncherStatus(isShowOutLauncher: boolean): void {
    this.isShowOutLauncher = isShowOutLauncher;
  }

  public getShowOutLauncherStatus(): boolean {
    return this.isShowOutLauncher;
  }

  public isCurrentDesktopVisible(isOuter: boolean = false): boolean {
    return this.isShowOutLauncher === isOuter;
  }

  /**
   * 获取当前是否处于简易模式
   */
  public getSimpleModeStatus(): boolean {
    return this.isSimpleMode;
  }

  /**
   * 更新当前简易模式状态
   *
   * @param isSimpleMode 是否处于简易模式
   */
  public setSimpleModeStatus(isSimpleMode: boolean): void {
    this.isSimpleMode = isSimpleMode;
  }

  /**
   * 获取当前是否处于抽屉模式
   *
   * @returns boolean 是否抽屉模式
   */
  public getDrawerModeStatus(): boolean {
    return this.isDrawerMode;
  }

  /**
   * 更新当前是否抽屉模式状态
   *
   * @param isDrawerMode 是否处于抽屉模式
   */
  public setDrawerModeStatus(isDrawerMode: boolean): void {
    this.isDrawerMode = isDrawerMode;
  }

  /**
   * 关闭抽屉桌面
   */
  public drawerPageAnimatedOut(): void {
    if (this.isDrawerMode && this.closeDrawerPage) {
      this.closeDrawerPage();
    }
  }

  /**
   * 设置关闭抽屉的方法
   *
   * @param closeDrawerPage 关闭抽屉的方法
   */
  public setDrawerPageAnimatedOutFunc(closeDrawerPage: () => void): void {
    this.closeDrawerPage = closeDrawerPage;
  }

  /**
   * 进入抽屉桌面
   */
  public drawerPageAnimatedIn(): void {
    if (!this.isDrawerMode && this.openDrawerPage) {
      this.openDrawerPage();
    }
  }

  /**
   * 设置打开抽屉的方法
   *
   * @param openDrawerPage 打开抽屉的方法
   */
  public setDrawerPageAnimatedInFunc(openDrawerPage: () => void): void {
    this.openDrawerPage = openDrawerPage;
  }

  /**
   * 获取当前是否处于桌面反向添加应用页面
   */
  public getDesktopAddModeStatus(): boolean {
    return this.isDesktopAddMode;
  }

  /**
   * 更新当前是否桌面反向添加应用页面
   *
   * @param isDesktopAddMode 是否处于抽屉模式
   */
  public setDesktopAddModeStatus(isDesktopAddMode: boolean): void {
    this.isDesktopAddMode = isDesktopAddMode;
  }

}

export const launcherStatusUtil: LauncherStatusUtil = SingletonHelper.getInstance(LauncherStatusUtil, TAG);