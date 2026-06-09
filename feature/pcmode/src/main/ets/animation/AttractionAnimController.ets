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

import { LogDomain, LogHelper, AppStorageUtil } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import context from '@ohos.app.ability.common';
import settings from '@ohos.settings';
import { SCBSceneHelper } from '../utils/SCBSceneHelper';

const TAG = '[AttractionAnimController]';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const DATA_SHARE_ATTRACTION_ENABLE: string = 'settings.attraction.enabled';
const EFFECT_ATTRACTION: string = 'attraction';
const EFFECT_DEFAULT: string = 'default';
const DEFAULT_VAL: string = EFFECT_DEFAULT; // 默认值设置

export class AttractionAnimController {
  private attractionState: string = '';
  private static instance: AttractionAnimController;
  private stateChangeCallbackMap: Map<number, Function> = new Map();

  public static getInstance(): AttractionAnimController {
    if (!AttractionAnimController.instance) {
      AttractionAnimController.instance = new AttractionAnimController();
      globalThis.attractionAnimController = AttractionAnimController.instance;
    }
    return AttractionAnimController.instance;
  }

  private constructor() {
    this.init();
  }

  private init(): void {
    if (SCBSceneHelper.is2D()) {
      this.attractionState = EFFECT_DEFAULT;
      return;
    }
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    const attractionVal: string = settings.getValueSync(context, DATA_SHARE_ATTRACTION_ENABLE, DEFAULT_VAL,
      settings.domainName.USER_PROPERTY);
    if (attractionVal === '') {
      settings.setValueSync(context, DATA_SHARE_ATTRACTION_ENABLE, DEFAULT_VAL, settings.domainName.USER_PROPERTY);
      this.attractionState = DEFAULT_VAL;
    } else {
      this.attractionState = attractionVal;
    }
    try {
      settings.registerKeyObserver(context, DATA_SHARE_ATTRACTION_ENABLE, settings.domainName.USER_PROPERTY,
        AttractionAnimController.settingDataChanged);
    } catch (error) {
      log.showError(`registerKeyObserver error, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public unRegisterSettingDataObserver(): void {
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return;
    }
    settings.unregisterKeyObserver(context, DATA_SHARE_ATTRACTION_ENABLE, settings.domainName.USER_PROPERTY);
  }

  public registerStateChangeCallback(screenId: number, callback: (isAttractionEffect: boolean) => void): void {
    this.stateChangeCallbackMap.set(screenId, callback);
  }

  public isAttractionEnabled(): boolean {
    return this.attractionState === EFFECT_ATTRACTION;
  }

  private getAttractionEffect(): string {
    log.showInfo(`getAttractionEffect`);
    let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
    if (context === undefined) {
      return this.attractionState;
    }
    return settings.getValueSync(context, DATA_SHARE_ATTRACTION_ENABLE, DEFAULT_VAL,
      settings.domainName.USER_PROPERTY);
  }

  private updateAttractionEffect(): void {
    const state: string = this.getAttractionEffect();
    if (this.attractionState === state) {
      return;
    }
    if (state === EFFECT_DEFAULT || state === EFFECT_ATTRACTION) {
      this.attractionState = state;
      log.showInfo(`attractionState: ${this.attractionState}`);
      this.stateChangeCallbackMap.forEach((callback) => {
        callback(this.isAttractionEnabled());
      })
    }
  }

  private static settingDataChanged(): void {
    AttractionAnimController.getInstance().updateAttractionEffect();
  }
}