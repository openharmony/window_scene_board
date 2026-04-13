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
import { LogDomain, LogHelper } from '@ohos/basicutils';


const TAG = 'AppCenterDynamicEffects';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppCenterDynamicEffects {
  private appItemPosX: number[] = [];
  private appItemPosY: number[] = [];
  private appItemOpacity: number[] = [];
  private rtlAppItemPosX: number[] = [];
  private bkOpacity: number = 0;

  constructor(appItemPosX: number[] = [], rtlAppItemPosX: number[] = [], appItemPosY: number[] = [],
    appItemOpacity: number[] = [], bkOpacity: number = 0) {
    this.appItemPosX = appItemPosX;
    this.rtlAppItemPosX = rtlAppItemPosX;
    this.appItemPosY = appItemPosY;
    this.appItemOpacity = appItemOpacity;
    this.bkOpacity = bkOpacity;
  }

  public getAppItemPosX(): number[] {
    return this.appItemPosX;
  }

  public getRtlAppItemPosX(): number[] {
    return this.rtlAppItemPosX;
  }

  public getAppItemPosY(): number[] {
    return this.appItemPosY;
  }

  public getAppItemOpacity(): number[] {
    return this.appItemOpacity;
  }

  public getBkOpacity(): number {
    return this.bkOpacity;
  }

  public setAppItemPosX(appItemPosX: number[]) {
    this.appItemPosX = appItemPosX;
  }

  public setRtlAppItemPosX(rtlAppItemPosX: number[]) {
    this.rtlAppItemPosX = rtlAppItemPosX;
  }

  public setAppItemPosY(appItemPosY: number[]) {
    this.appItemPosY = appItemPosY;
  }

  public setAppItemOpacity(appItemOpacity: number[]) {
    this.appItemOpacity = appItemOpacity;
  }

  public setBkOpacity(bkOpacity: number) {
    this.bkOpacity = bkOpacity;
  }
}