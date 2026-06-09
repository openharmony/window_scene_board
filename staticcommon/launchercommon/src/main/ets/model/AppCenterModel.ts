/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { ArrayList } from '@kit.ArkTS';

/**
 * app center data model.
 */
export class AppCenterModel {
  private hideAppCenter: (screenId?: number) => void = (): void => {};
  private static appCenterModelInstance: AppCenterModel;
  private appCenterData: Map<number, boolean> = new Map();
  private appCenterChangeCallback: Map<number, ArrayList<Function>> = new Map();

  private constructor() {}

  public static getInstance(): AppCenterModel {
    if (CheckEmptyUtils.isEmpty(AppCenterModel.appCenterModelInstance)) {
      AppCenterModel.appCenterModelInstance = new AppCenterModel();
    }
    return AppCenterModel.appCenterModelInstance;
  }

  public setHideAppCenterFunc(hide: (screenId?: number) => void): void {
    this.hideAppCenter = hide;
  }

  public hideAppCenterWithAnimation(screenId?: number): void {
    this.hideAppCenter(screenId);
  }

  public isShow(screenId?: number): boolean {
    return this.appCenterData.get(screenId ?? 0) ?? false;
  }

  public setViewState(screenId: number, isShow: boolean): void {
    const preState = this.appCenterData.get(screenId);
    this.appCenterData.set(screenId, isShow);
    if (preState !== isShow) {
      let callbackList = this.appCenterChangeCallback.get(screenId);
      if (callbackList) {
        callbackList.forEach((func: Function) => {
          func(screenId, isShow);
        });
      }
    }
  }

  public registerStateChangeCallback(screenId: number, callback: Function): void {
    let callbackList = this.appCenterChangeCallback.get(screenId) ?? new ArrayList<Function>();
    callbackList.add(callback);
    this.appCenterChangeCallback.set(screenId, callbackList);
  }

  public unregisterStateChangeCallback(screenId: number, callback: Function): void {
    this.appCenterChangeCallback.get(screenId)?.remove(callback);
  }

  public screenDisconnect(screenId: number): void {
    this.appCenterChangeCallback.delete(screenId);
  }
}